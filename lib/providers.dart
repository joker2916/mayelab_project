// lib/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/comptes_repository.dart';
import 'package:mayelab_project/ecritures_repository.dart';

// 1) DB
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// 2) Comptes Repository
final comptesRepositoryProvider = Provider<ComptesRepository>((ref) {
  final db = ref.read(databaseProvider);
  return ComptesRepository(db);
});

// 3) Ecritures Repository ✅ NOUVEAU
final ecrituresRepositoryProvider = Provider<EcrituresRepository>((ref) {
  final db = ref.read(databaseProvider);
  return EcrituresRepository(db);
});

// 4) Seed au démarrage
final seedProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(comptesRepositoryProvider);
  await repo.seedIfEmpty();
});

// 5) Stream des comptes
final comptesStreamProvider = StreamProvider<List<Compte>>((ref) {
  final repo = ref.watch(comptesRepositoryProvider);
  return repo.watchAll();
});

// 6) Stream des écritures ✅ NOUVEAU
final ecrituresStreamProvider = StreamProvider<List<Ecriture>>((ref) {
  final repo = ref.watch(ecrituresRepositoryProvider);
  return repo.watchAll();
});
