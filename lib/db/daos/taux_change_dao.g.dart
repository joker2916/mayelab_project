// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taux_change_dao.dart';

// ignore_for_file: type=lint
mixin _$TauxChangeDaoMixin on DatabaseAccessor<AppDatabase> {
  $CurrenciesTable get currencies => attachedDatabase.currencies;
  $TauxChangeTable get tauxChange => attachedDatabase.tauxChange;
  TauxChangeDaoManager get managers => TauxChangeDaoManager(this);
}

class TauxChangeDaoManager {
  final _$TauxChangeDaoMixin _db;
  TauxChangeDaoManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db.attachedDatabase, _db.currencies);
  $$TauxChangeTableTableManager get tauxChange =>
      $$TauxChangeTableTableManager(_db.attachedDatabase, _db.tauxChange);
}
