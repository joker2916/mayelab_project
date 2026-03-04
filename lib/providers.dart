import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:drift/drift.dart';

// 1) Provider de la DB
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// 2) Repository simple (dans le même fichier pour éviter confusion)
//    (plus tard on le séparera si tu veux)
class ComptesRepository {
  final AppDatabase db;
  ComptesRepository(this.db);

  Stream<List<Compte>> watchAll() {
    return (db.select(
      db.comptes,
    )..orderBy([(t) => OrderingTerm.asc(t.code)]))
        .watch();
  }

  Future<void> seedIfEmpty() async {
    // Version SIMPLE: on lit la table, si elle n’est pas vide => on ne seed pas.
    final existing = await db.select(db.comptes).get();
    if (existing.isNotEmpty) return;

    await db.into(db.comptes).insert(
          ComptesCompanion.insert(code: '101', nom: 'Caisse', lft: 1, rgt: 2),
          mode: InsertMode.insertOrIgnore,
        );
  }
}

final comptesRepositoryProvider = Provider<ComptesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ComptesRepository(db);
});

// 3) Seed au démarrage
final seedProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(comptesRepositoryProvider);
  await repo.seedIfEmpty();
});

// 4) Stream des comptes pour l’écran
final comptesStreamProvider = StreamProvider<List<Compte>>((ref) {
  final repo = ref.watch(comptesRepositoryProvider);
  return repo.watchAll();
});
