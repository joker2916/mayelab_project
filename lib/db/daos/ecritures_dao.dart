import 'package:drift/drift.dart';
import '../app_database.dart';

part 'ecritures_dao.g.dart';

@DriftAccessor(tables: [Ecritures, LigneEcritures, Comptes])
class EcrituresDao extends DatabaseAccessor<AppDatabase>
    with _$EcrituresDaoMixin {
  EcrituresDao(super.db);

  Stream<List<Ecriture>> watchAll() {
    return (select(ecritures)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<LigneEcriture>> getLignes(String ecritureId) {
    return (select(ligneEcritures)
          ..where((t) => t.ecritureId.equals(ecritureId)))
        .get();
  }

  Future<List<Compte>> getAllComptes() {
    return (select(comptes)..orderBy([(c) => OrderingTerm.asc(c.code)])).get();
  }
}
