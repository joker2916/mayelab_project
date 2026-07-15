// lib/services/audit_log_helper.dart
import 'package:drift/drift.dart';
import 'package:mayelab_project/db/app_database.dart';

class AuditLogHelper {
  final AppDatabase _db;

  AuditLogHelper(this._db);

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a');
  }

  /// Enregistrer une action
  Future<void> log({
    required String action,
    required String module,
    String? entityId,
    String? details,
  }) async {
    await _db.insertAuditLog(
      entity: module,
      action: action,
      entityId: entityId,
      details: details,
    );
  }

  /// Récupérer tous les logs
  Future<List<AuditLog>> getAllLogs() async {
    return await (_db.select(_db.auditLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Filtrer par module
  Future<List<AuditLog>> getLogsByModule(String module) async {
    final target = _normalize(module);
    final logs = await getAllLogs();
    return logs.where((l) => _normalize(l.entity) == target).toList();
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
