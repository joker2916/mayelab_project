// lib/services/audit_log_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuditLogHelper {
  static final AuditLogHelper _instance = AuditLogHelper._internal();
  factory AuditLogHelper() => _instance;
  AuditLogHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'audit_log.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            module TEXT NOT NULL,
            details TEXT,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Enregistrer une action
  Future<void> log({
    required String action,
    required String module,
    String? details,
  }) async {
    final db = await database;
    await db.insert('audit_log', {
      'action': action,
      'module': module,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Récupérer tous les logs (du plus récent au plus ancien)
  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await database;
    return await db.query(
      'audit_log',
      orderBy: 'timestamp DESC',
    );
  }

  /// Filtrer par module
  Future<List<Map<String, dynamic>>> getLogsByModule(String module) async {
    final db = await database;
    return await db.query(
      'audit_log',
      where: 'module = ?',
      whereArgs: [module],
      orderBy: 'timestamp DESC',
    );
  }

  /// Filtrer par période
  Future<List<Map<String, dynamic>>> getLogsByPeriod(
      DateTime debut, DateTime fin) async {
    final db = await database;
    return await db.query(
      'audit_log',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [debut.toIso8601String(), fin.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
  }

  /// Supprimer les logs anciens (optionnel, maintenance)
  Future<int> deleteOlderThan(DateTime date) async {
    final db = await database;
    return await db.delete(
      'audit_log',
      where: 'timestamp < ?',
      whereArgs: [date.toIso8601String()],
    );
  }
}
