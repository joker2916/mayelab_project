// lib/ecritures_repository.dart
import 'package:drift/drift.dart';
import 'db/app_database.dart';

class EcrituresRepository {
  final AppDatabase db;
  EcrituresRepository(this.db);

  Stream<List<Ecriture>> watchAll() => db.watchAllPieces();

  Future<List<Compte>> getComptes() =>
      (db.select(db.comptes)..orderBy([(c) => OrderingTerm.asc(c.code)])).get();

  Future<List<LigneEcriture>> getLignes(String ecritureId) =>
      (db.select(db.ligneEcritures)
            ..where((t) => t.ecritureId.equals(ecritureId)))
          .get();

  Future<String> create({
    required String companyId,
    required String libelle,
    String? reference,
    DateTime? date,
    List<LigneEcrituresCompanion>? lignes,
  }) =>
      db.createPieceWithLines(
        companyId: companyId,
        libelle: libelle,
        reference: reference,
        date: date,
        lines: lignes,
      );

  Future<void> update({
    required String ecritureId,
    required String libelle,
    String? reference,
    DateTime? date,
    List<LigneEcrituresCompanion>? lignes,
  }) =>
      db.updatePieceWithLines(
        ecritureId: ecritureId,
        libelle: libelle,
        reference: reference,
        date: date,
        lines: lignes,
      );

  Future<void> delete(String id) => db.deletePieceById(id);

  Future<EcritureWithLines?> fetchWithLines(String id) =>
      db.fetchPieceWithLines(id);

  Future<List<GrandLivreLigne>> getGrandLivre(int compteId) =>
      db.fetchGrandLivre(compteId);
}
