// lib/db/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'daos/taux_change_dao.dart';
import 'package:mayelab_project/db/attachements_table.dart';

part 'app_database.g.dart';

final _uuid = Uuid();

const int rateScale = 1000000;

// ---------------------------
// TABLES
// ---------------------------

class Companies extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get taxNumber => text().nullable()();
  TextColumn get currencyDefault => text()
      .nullable()
      .customConstraint('NULLABLE REFERENCES currencies(id)')();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Currencies extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get code => text().withLength(min: 1, max: 10).unique()();
  TextColumn get name => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ExchangeRates extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get fromCurrency =>
      text().customConstraint('REFERENCES currencies(id)')();
  TextColumn get toCurrency =>
      text().customConstraint('REFERENCES currencies(id)')();
  IntColumn get rate => integer()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
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
  TextColumn get nom => text().withLength(min: 1, max: 200)();
  IntColumn get lft => integer()();
  IntColumn get rgt => integer()();
}

class Ecritures extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get companyId =>
      text().customConstraint('NOT NULL REFERENCES companies(id)')();

  TextColumn get currencyId => text()
      .nullable()
      .customConstraint('NULLABLE REFERENCES currencies(id)')();
  TextColumn get libelle => text().withLength(min: 1, max: 500)();
  TextColumn get reference => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get statut => text().withDefault(const Constant('BROUILLON'))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LigneEcritures extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get ecritureId =>
      text().customConstraint('REFERENCES ecritures(id)')();
  IntColumn get compteId =>
      integer().customConstraint('REFERENCES comptes(id)')();
  IntColumn get debit => integer().withDefault(const Constant(0))();
  IntColumn get credit => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get entityId => text().nullable()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

class TauxChange extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviseSource => text()
      .withLength(min: 1, max: 10)
      .customConstraint('NOT NULL REFERENCES currencies(code)')();
  TextColumn get deviseCible => text()
      .withLength(min: 1, max: 10)
      .customConstraint('NOT NULL REFERENCES currencies(code)')();

  RealColumn get tauxAchat => real()();
  RealColumn get tauxVente => real()();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime().nullable()();
  DateTimeColumn get dateModification =>
      dateTime().clientDefault(() => DateTime.now())();
}

// ---------------------------
// DATABASE
// ---------------------------

@DriftDatabase(
  tables: [
    Companies,
    Currencies,
    ExchangeRates,
    Sequences,
    Comptes,
    Ecritures,
    LigneEcritures,
    Attachments,
    AuditLogs,
    TauxChange,
  ],
  daos: [TauxChangeDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(exchangeRates);
            await m.addColumn(ecritures, ecritures.currencyId);
          }
          if (from < 3) {
            await m.createTable(tauxChange);
          }
          if (from < 4) {
            // Nouvelle colonne details dans AuditLogs
            await m.addColumn(auditLogs, auditLogs.details);
            await customStatement('''
              DELETE FROM ecritures
              where company_id NOT IN (SELECT id FROM companies)
            ''');
          }
        },
        beforeOpen: (openingDetails) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await _seedCurrencies();
        },
      );

  // ---------------------------
  // SEED
  // ---------------------------

  Future<void> _seedCurrencies() async {
    final existing = await select(currencies).get();
    if (existing.isNotEmpty) return;
    await into(currencies).insert(CurrenciesCompanion(
      id: const Value('USD'),
      code: const Value('USD'),
      name: const Value('Dollar américain'),
    ));
    await into(currencies).insert(CurrenciesCompanion(
      id: const Value('CDF'),
      code: const Value('CDF'),
      name: const Value('Franc Congolais'),
    ));
  }

  // ---------------------------
  // AUDIT LOGS
  // ---------------------------

  Future<void> insertAuditLog({
    required String entity,
    required String action,
    String? entityId,
  }) async {
    await into(auditLogs).insert(
      AuditLogsCompanion(
        entity: Value(entity),
        entityId: Value(entityId),
        action: Value(action),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<AuditLog>> fetchAuditLogs({
    String? entity,
    String? entityId,
    int limit = 200,
  }) async {
    final q = select(auditLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    if (entity != null) q.where((t) => t.entity.equals(entity));
    if (entityId != null) q.where((t) => t.entityId.equals(entityId));
    return q.get();
  }

  // ---------------------------
  // SEQUENCES
  // ---------------------------

  Future<String> nextSequenceReference({
    required String companyId,
    String? journalId,
    String? prefix,
    int padding = 4,
  }) async {
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
        lastNumber: const Value(1),
        padding: Value(padding),
      ));
      final number = '1'.padLeft(padding, '0');
      return '${prefix ?? ''}$number';
    } else {
      final next = existing.lastNumber + 1;
      await (update(sequences)..where((s) => s.id.equals(existing.id))).write(
        SequencesCompanion(lastNumber: Value(next)),
      );
      final number = next.toString().padLeft(existing.padding, '0');
      return '${existing.prefix ?? ''}$number';
    }
  }

  // ---------------------------
  // ECRITURES (PIECES)
  // ---------------------------

  Future<String> createPieceWithLines({
    required String companyId,
    required String libelle,
    String? journalId,
    String? reference,
    String? currencyId,
    DateTime? date,
    List<LigneEcrituresCompanion>? lines,
  }) async {
    return transaction<String>(() async {
      final id = _uuid.v4();
      final now = DateTime.now();

      String? finalReference = reference;
      if (finalReference == null) {
        try {
          finalReference = await nextSequenceReference(
            companyId: companyId,
            journalId: journalId,
          );
        } catch (_) {
          finalReference = null;
        }
      }

      if (lines != null && lines.isNotEmpty) _validateEquilibre(lines);

      await into(ecritures).insert(EcrituresCompanion(
        id: Value(id),
        companyId: Value(companyId),
        currencyId: Value(currencyId),
        libelle: Value(libelle),
        reference: Value(finalReference),
        date: Value(date ?? now),
        statut: const Value('BROUILLON'),
        createdAt: Value(now),
      ));

      if (lines != null && lines.isNotEmpty) {
        for (final l in lines) {
          await into(ligneEcritures).insert(
            l.copyWith(
              id: Value(_uuid.v4()),
              ecritureId: Value(id),
            ),
          );
        }
      }

      await insertAuditLog(
        entity: 'ecritures',
        entityId: id,
        action: 'INSERT',
      );

      return id;
    });
  }

  Stream<List<Ecriture>> watchAllPieces() {
    return (select(ecritures)..where((t) => t.isDeleted.equals(false))).watch();
  }

  Future<void> deletePieceById(String id) async {
    try {
      await (update(ecritures)..where((t) => t.id.equals(id))).write(
        EcrituresCompanion(
          isDeleted: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } catch (_) {
      await (delete(ecritures)..where((t) => t.id.equals(id))).go();
    }

    await insertAuditLog(
      entity: 'ecritures',
      entityId: id,
      action: 'DELETE',
    );
  }

  Future<void> updatePieceWithLines({
    required String ecritureId,
    required String libelle,
    String? reference,
    String? currencyId,
    DateTime? date,
    List<LigneEcrituresCompanion>? lines,
  }) async {
    await transaction(() async {
      final now = DateTime.now();

      if (lines != null && lines.isNotEmpty) _validateEquilibre(lines);

      await (update(ecritures)..where((t) => t.id.equals(ecritureId))).write(
        EcrituresCompanion(
          libelle: Value(libelle),
          reference: Value(reference),
          currencyId: Value(currencyId),
          date: Value(date ?? now),
          updatedAt: Value(now),
        ),
      );

      await (delete(ligneEcritures)
            ..where((t) => t.ecritureId.equals(ecritureId)))
          .go();

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

      await insertAuditLog(
        entity: 'ecritures',
        entityId: ecritureId,
        action: 'UPDATE',
      );
    });
  }

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

  // ---------------------------
  // ATTACHMENTS
  // ---------------------------

  Future<String> addAttachment({
    required String ecritureId,
    required String filename,
    required String path,
    String? mime,
    int? size,
  }) async {
    final id = _uuid.v4();
    await into(attachments).insert(AttachmentsCompanion(
      id: Value(id),
      ecritureId: Value(ecritureId),
      filename: Value(filename),
      path: Value(path),
      mime: Value(mime),
      size: Value(size),
    ));
    return id;
  }

  // ---------------------------
  // GRAND LIVRE
  // ---------------------------

  Future<List<GrandLivreLigne>> fetchGrandLivre(int compteId) async {
    final query = select(ligneEcritures).join([
      innerJoin(ecritures, ecritures.id.equalsExp(ligneEcritures.ecritureId)),
    ])
      ..where(ligneEcritures.compteId.equals(compteId))
      ..where(ecritures.isDeleted.equals(false))
      ..orderBy([OrderingTerm.asc(ecritures.date)]);

    final rows = await query.get();
    return rows.map((row) {
      return GrandLivreLigne(
        ligne: row.readTable(ligneEcritures),
        ecriture: row.readTable(ecritures),
      );
    }).toList();
  }

  // ---------------------------
  // VALIDATION
  // ---------------------------

  void _validateEquilibre(List<LigneEcrituresCompanion> lines) {
    final totalDebit = lines.fold(0, (s, l) => s + l.debit.value);
    final totalCredit = lines.fold(0, (s, l) => s + l.credit.value);
    if (totalDebit != totalCredit) {
      throw Exception(
        'Écriture déséquilibrée : '
        'Débit ${totalDebit / 100} ≠ Crédit ${totalCredit / 100}',
      );
    }
  }
}

// ---------------------------
// WRAPPERS
// ---------------------------

class EcritureWithLines {
  final Ecriture ecriture;
  final List<LigneEcriture> lignes;
  EcritureWithLines(this.ecriture, this.lignes);
}

class GrandLivreLigne {
  final LigneEcriture ligne;
  final Ecriture ecriture;
  GrandLivreLigne({required this.ligne, required this.ecriture});
}

// ---------------------------
// CONNECTION
// ---------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final docs = await getApplicationDocumentsDirectory();
    final file = File(p.join(docs.path, 'mayelab_app.db'));
    return NativeDatabase(file);
  });
}
