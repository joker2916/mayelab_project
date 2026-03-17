import 'package:drift/drift.dart';
import '../app_database.dart';

part 'taux_change_dao.g.dart';

@DriftAccessor(tables: [TauxChange])
class TauxChangeDao extends DatabaseAccessor<AppDatabase>
    with _$TauxChangeDaoMixin {
  TauxChangeDao(AppDatabase db) : super(db);

  Future<List<TauxChangeData>> getAllTauxChange() => select(tauxChange).get();

  Future<List<TauxChangeData>> getTauxByDeviseSource(String deviseSource) =>
      (select(tauxChange)..where((t) => t.deviseSource.equals(deviseSource)))
          .get();

  Future<List<TauxChangeData>> getTauxByPaire(
          String deviseSource, String deviseCible) =>
      (select(tauxChange)
            ..where((t) =>
                t.deviseSource.equals(deviseSource) &
                t.deviseCible.equals(deviseCible))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.dateDebut, mode: OrderingMode.desc)
            ]))
          .get();

  Future<TauxChangeData?> getTauxActif(
          String deviseSource, String deviseCible, DateTime date) =>
      (select(tauxChange)
            ..where((t) =>
                t.deviseSource.equals(deviseSource) &
                t.deviseCible.equals(deviseCible) &
                t.dateDebut.isSmallerOrEqualValue(date) &
                (t.dateFin.isNull() | t.dateFin.isBiggerOrEqualValue(date)))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.dateDebut, mode: OrderingMode.desc)
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<int> insertTauxChange(TauxChangeCompanion entry) =>
      into(tauxChange).insert(entry);

  Future<bool> updateTauxChange(TauxChangeData entry) =>
      update(tauxChange).replace(entry);

  Future<int> deleteTauxChange(int id) =>
      (delete(tauxChange)..where((t) => t.id.equals(id))).go();

  Future<int> deleteTauxExpires(DateTime date) => (delete(tauxChange)
        ..where(
            (t) => t.dateFin.isNotNull() & t.dateFin.isSmallerThanValue(date)))
      .go();

  Stream<List<TauxChangeData>> watchAllTauxChange() =>
      select(tauxChange).watch();

  Stream<List<TauxChangeData>> watchTauxByPaire(
          String deviseSource, String deviseCible) =>
      (select(tauxChange)
            ..where((t) =>
                t.deviseSource.equals(deviseSource) &
                t.deviseCible.equals(deviseCible))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.dateDebut, mode: OrderingMode.desc)
            ]))
          .watch();
}
