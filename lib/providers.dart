import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/comptes_repository.dart';
import 'package:mayelab_project/ecritures_repository.dart';

// DB
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Comptes Repository
final comptesRepositoryProvider = Provider<ComptesRepository>((ref) {
  final db = ref.read(databaseProvider);
  return ComptesRepository(db);
});

// Ecritures Repository
final ecrituresRepositoryProvider = Provider<EcrituresRepository>((ref) {
  final db = ref.read(databaseProvider);
  return EcrituresRepository(db);
});

// Seed au démarrage
final seedProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(comptesRepositoryProvider);
  await repo.seedIfEmpty();
});

// Stream des comptes
final comptesStreamProvider = StreamProvider<List<Compte>>((ref) {
  final repo = ref.watch(comptesRepositoryProvider);
  return repo.watchAll();
});

// Stream des écritures
final ecrituresStreamProvider = StreamProvider<List<Ecriture>>((ref) {
  final repo = ref.watch(ecrituresRepositoryProvider);
  return repo.watchAll();
});

// grand livre par compte
final grandLivreProvider = FutureProvider.family<List<GrandLivreLigne>, int>(
  (ref, compteId) {
    final repo = ref.watch(ecrituresRepositoryProvider);
    return repo.getGrandLivre(compteId);
  },
);
