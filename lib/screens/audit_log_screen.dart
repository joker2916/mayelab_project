// lib/screens/audit_log_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/services/audit_log_helper.dart';

class AuditLogScreen extends StatefulWidget {
  final AppDatabase database;

  const AuditLogScreen({super.key, required this.database});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  late final AuditLogHelper _auditHelper;
  List<AuditLog> _logs = [];
  bool _loading = true;
  String _selectedModule = 'Tous';

  final List<String> _modules = [
    'Tous',
    'Comptes',
    'Écritures',
    'Journal',
    'Auth',
  ];

  @override
  void initState() {
    super.initState();
    _auditHelper = AuditLogHelper(widget.database);
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);

    List<AuditLog> logs;
    if (_selectedModule == 'Tous') {
      logs = await _auditHelper.getAllLogs();
    } else {
      logs = await _auditHelper.getLogsByModule(_selectedModule);
    }

    setState(() {
      _logs = logs;
      _loading = false;
    });
  }

  IconData _iconForAction(String action) {
    switch (action.toLowerCase()) {
      case 'création':
        return Icons.add_circle;
      case 'modification':
        return Icons.edit;
      case 'suppression':
        return Icons.delete;
      case 'connexion':
        return Icons.login;
      case 'validation':
        return Icons.check_circle;
      case 'annulation':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _colorForAction(String action) {
    switch (action.toLowerCase()) {
      case 'création':
        return Colors.green;
      case 'modification':
        return Colors.orange;
      case 'suppression':
        return Colors.red;
      case 'connexion':
        return Colors.blue;
      case 'validation':
        return Colors.teal;
      case 'annulation':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm:ss', 'fr_FR').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal d\'audit'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _selectedModule = value);
              _loadLogs();
            },
            itemBuilder: (context) => _modules
                .map((m) => PopupMenuItem(value: m, child: Text(m)))
                .toList(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun log enregistré',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      if (_selectedModule != 'Tous')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Filtre actif : $_selectedModule',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      color: Colors.blue.shade50,
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('${_logs.length} enregistrement(s)'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _logs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          final action = log.action;
                          final module = log.entity;
                          final details = log.details ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _colorForAction(action)
                                  .withValues(alpha: 0.15),
                              child: Icon(
                                _iconForAction(action),
                                color: _colorForAction(action),
                                size: 20,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  action,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _colorForAction(action),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    module,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (details.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(details,
                                        style: const TextStyle(fontSize: 13)),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _formatTimestamp(log.createdAt),
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey[500]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
