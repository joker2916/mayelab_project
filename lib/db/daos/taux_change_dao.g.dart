// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taux_change_dao.dart';

// ignore_for_file: type=lint
mixin _$TauxChangeDaoMixin on DatabaseAccessor<AppDatabase> {
  $TauxChangeTable get tauxChange => attachedDatabase.tauxChange;
  TauxChangeDaoManager get managers => TauxChangeDaoManager(this);
}

class TauxChangeDaoManager {
  final _$TauxChangeDaoMixin _db;
  TauxChangeDaoManager(this._db);
  $$TauxChangeTableTableManager get tauxChange =>
      $$TauxChangeTableTableManager(_db.attachedDatabase, _db.tauxChange);
}
