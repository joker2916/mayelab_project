// lib/db/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

final _uuid = Uuid();

const int RATE_SCALE = 1000000; // six décimales

// ---------------------------
// TABLES
// ---------------------------

class Companies extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get currencyDefault =>
      text().nullable().customConstraint('REFERENCES currencies(id)')();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Currencies extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get code => text().withLength(min: 1, max: 10)();
  TextColumn get name => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Sequences extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get companyId => text()();
  TextColumn get journalId => text().nullable()();
  IntColumn get lastNumber => integer().withDefault(const Constant(0))();
  IntColumn get padding => integer().withDefault(const Constant(4))();
  TextColumn get prefix => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Comptes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 50)();
  // On expose 'nom' parce que ton UI utilise c.nom
  TextColumn get nom => text().withLength(min: 1, max: 200)();
  IntColumn get lft => integer()();
  IntColumn get rgt => integer()();
}

class Ecritures extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get companyId => text()();
  TextColumn get libelle => text().withLength(min: 1, max: 500)();
  TextColumn get reference => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get statut => text().withDefault(const Constant('BROUILLON'))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  // corrigé : appel de méthode nullable()
  DateTimeColumn get updatedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// ✅ APRÈS
class LigneEcritures extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get ecritureId =>
      text().customConstraint('REFERENCES ecritures(id)')();
  IntColumn get compteId =>
      integer().customConstraint('REFERENCES comptes(id)')(); // ✅ INTEGER
  IntColumn get debit => integer().withDefault(const Constant(0))();
  IntColumn get credit => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Attachments extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get ecritureId =>
      text().customConstraint('REFERENCES ecritures(id)')();
  TextColumn get filename => text()();
  TextColumn get path => text()();
  TextColumn get mime => text().nullable()();
  IntColumn get size => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get action => text()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

// ---------------------------
// DATABASE (Drift) + METHODS
// ---------------------------

@DriftDatabase(
  tables: [
    Companies,
    Currencies,
    Sequences,
    Comptes,
    Ecritures,
    LigneEcritures,
    Attachments,
    AuditLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Sequences: generate reference number
  Future<String> nextSequenceReference({
    required String companyId,
    String? journalId,
    String? prefix,
    int padding = 4,
  }) async {
    // Gère journalId nullable : on construit la requête en conséquence
    final q = select(sequences)..where((s) => s.companyId.equals(companyId));
    if (journalId == null) {
      q.where((s) => s.journalId.isNull());
    } else {
      q.where((s) => s.journalId.equals(journalId));
    }
    final existing = await q.getSingleOrNull();
    if (existing == null) {
      final id = _uuid.v4();
      await into(sequences).insert(SequencesCompanion(
        id: Value(id),
        companyId: Value(companyId),
        journalId: Value(journalId),
        prefix: Value(prefix),
        lastNumber: Value(1),
        padding: Value(padding),
      ));
      final number = '1'.padLeft(padding, '0');
      // corrigé : pas d'espaces indésirables dans l'interpolation
      return '${prefix ?? ''}$number';
    } else {
      final next = existing.lastNumber + 1;
      await (update(sequences)..where((s) => s.id.equals(existing.id))).write(
        SequencesCompanion(lastNumber: Value(next)),
      );
      final pad = existing.padding;
      final number = next.toString().padLeft(pad, '0');
      return '${existing.prefix ?? ''}$number';
    }
  }

  // Alias pour ton UI
  Future<String> createPieceWithLines({
    required String companyId,
    required String libelle,
    String? journalId,
    String? reference,
    DateTime? date,
    List<LigneEcrituresCompanion>? lines,
  }) async {
    return transaction<String>(() async {
      // Génère un id pour la pièce
      final id = _uuid.v4();
      final now = DateTime.now();
      // Si reference n'est pas fournie, génère une référence via la sequence (optionnel)
      String? finalReference = reference;
      if (finalReference == null) {
        try {
          // nextSequenceReference gère journalId nullable
          finalReference = await nextSequenceReference(
            companyId: companyId,
            journalId: journalId,
            prefix: null,
          );
        } catch (_) {
          // si la génération échoue, on reste avec null
          finalReference = null;
        }
      }

      // Insère l'ecriture (pièce) — attention: Ecritures n'a PAS de colonne journalId
      await into(ecritures).insert(EcrituresCompanion(
        id: Value(id),
        companyId: Value(companyId),
        libelle: Value(libelle),
        reference: Value(finalReference),
        date: Value(date ?? now),
        statut: Value('BROUILLON'),
        createdAt: Value(now),
      ));

      // Insère les lignes si fournies
      if (lines != null && lines.isNotEmpty) {
        for (final l in lines) {
          // on s'assure d'assigner un id unique et de lier à l'ecriture créée
          await into(ligneEcritures).insert(
            l.copyWith(
              id: Value(_uuid.v4()),
              ecritureId: Value(id),
            ),
          );
        }
      }

      return id;
    });
  }

  Future<String> addAttachment({
    required String ecritureId,
    required String filename,
    required String path,
    String? mime,
    int? size,
  }) async {
    final id = _uuid.v4();
    await into(attachments).insert(
      AttachmentsCompanion(
        id: Value(id),
        ecritureId: Value(ecritureId),
        filename: Value(filename),
        path: Value(path),
        mime: Value(mime),
        size: Value(size),
      ),
    );
    return id;
  }

  Future<List<AuditLog>> fetchAuditLogs({
    String? entity,
    String? entityId,
    int limit = 200,
  }) async {
    final q = (select(auditLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit));
    if (entity != null) q.where((t) => t.entity.equals(entity));
    if (entityId != null) q.where((t) => t.entityId.equals(entityId));
    return q.get();
  }

  Stream<List<Ecriture>> watchAllPieces() {
    return (select(ecritures)..where((t) => t.isDeleted.equals(false))).watch();
  }

  Future<void> deletePieceById(String id) async {
    try {
      await (update(ecritures)..where((t) => t.id.equals(id))).write(
        EcrituresCompanion(
          isDeleted: Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      await (delete(ecritures)..where((t) => t.id.equals(id))).go();
    }
  }

  /// Met à jour une écriture (pièce) et remplace toutes ses lignes (transaction).
  Future<void> updatePieceWithLines({
    required String ecritureId,
    required String libelle,
    String? reference,
    DateTime? date,
    List<LigneEcrituresCompanion>? lines,
  }) async {
    await transaction(() async {
      final now = DateTime.now();
      // Met à jour l'ecriture
      await (update(ecritures)..where((t) => t.id.equals(ecritureId))).write(
        EcrituresCompanion(
          libelle: Value(libelle),
          reference: Value(reference),
          date: Value(date ?? now),
          updatedAt: Value(now),
        ),
      );

      // Supprime les lignes existantes liées à cette écriture
      await (delete(ligneEcritures)
            ..where((t) => t.ecritureId.equals(ecritureId)))
          .go();

      // Réinsère les lignes fournies (si présentes)
      if (lines != null && lines.isNotEmpty) {
        for (final l in lines) {
          await into(ligneEcritures).insert(
            l.copyWith(
              id: Value(_uuid.v4()),
              ecritureId: Value(ecritureId),
            ),
          );
        }
      }
    });
  }

  /// Charge une écriture avec ses lignes (utile pour l'UI d'édition)
  Future<EcritureWithLines?> fetchPieceWithLines(String ecritureId) async {
    final ecrit = await (select(ecritures)
          ..where((t) => t.id.equals(ecritureId)))
        .getSingleOrNull();
    if (ecrit == null) return null;
    final lignes = await (select(ligneEcritures)
          ..where((t) => t.ecritureId.equals(ecritureId)))
        .get();
    return EcritureWithLines(ecrit, lignes);
  }
}

/// Wrapper simple pour retourner l'entité + ses lignes
class EcritureWithLines {
  final Ecriture ecriture;
  final List<LigneEcriture> lignes;
  EcritureWithLines(this.ecriture, this.lignes);
}

// ---------------------------
// LAZY DB CONNECTION
// ---------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, 'mayelab_app.db'));
    return NativeDatabase(file);
  });
}
