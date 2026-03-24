// lib/services/audit_log_helper.dart
import 'package:drift/drift.dart';
import 'package:mayelab_project/db/app_database.dart';

class AuditLogHelper {
  final AppDatabase _db;

  static AuditLogHelper? _instance;

  factory AuditLogHelper(AppDatabase db) {
    _instance ??= AuditLogHelper._internal(db);
    return _instance!;
  }

  AuditLogHelper._internal(this._db);

  /// Enregistrer une action
  Future<void> log({
    required String action,
    required String module,
    String? details,
  }) async {
    await _db.into(_db.auditLogs).insert(AuditLogsCompanion(
          entity: Value(module),
          entityId: Value(details),
          action: Value(action),
        ));
  }

  /// Récupérer tous les logs
  Future<List<AuditLog>> getAllLogs() async {
    return await (_db.select(_db.auditLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Filtrer par module
  Future<List<AuditLog>> getLogsByModule(String module) async {
    return await (_db.select(_db.auditLogs)
          ..where((t) => t.entity.equals(module))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Filtrer par période
  Future<List<AuditLog>> getLogsByPeriod(DateTime debut, DateTime fin) async {
    return await (_db.select(_db.auditLogs)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(debut) &
              t.createdAt.isSmallerOrEqualValue(fin))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Supprimer les logs anciens
  Future<int> deleteOlderThan(DateTime date) async {
    return await (_db.delete(_db.auditLogs)
          ..where((t) => t.createdAt.isSmallerThanValue(date)))
        .go();
  }
}
