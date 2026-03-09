// lib/comptes_repository.dart
import 'package:drift/drift.dart';
import 'package:mayelab_project/db/app_database.dart';

class ComptesRepository {
  final AppDatabase _db;
  ComptesRepository(this._db);

  Stream<List<Compte>> watchAll() {
    return _db.select(_db.comptes).watch();
  }

  Future<List<Compte>> getAll() {
    return _db.select(_db.comptes).get();
  }

  Future<int> create({
    required String code,
    required String nom,
    required int lft,
    required int rgt,
  }) {
    return _db.into(_db.comptes).insert(
          ComptesCompanion(
            code: Value(code),
            nom: Value(nom),
            lft: Value(lft),
            rgt: Value(rgt),
          ),
        );
  }

  Future<void> deleteById(int id) async {
    await (_db.delete(_db.comptes)..where((t) => t.id.equals(id))).go();
  }

  Future<void> seedIfEmpty() async {
    final all = await getAll();
    if (all.isNotEmpty) return;

    // Compte racine 1
    await create(code: '1', nom: 'Actif', lft: 1, rgt: 4);
    // Sous-compte
    await create(code: '10', nom: 'Immobilisations', lft: 2, rgt: 3);
    // Compte racine 2
    await create(code: '2', nom: 'Passif', lft: 5, rgt: 6);
  }
}
