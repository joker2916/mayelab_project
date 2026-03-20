// lib/screens/audit_log_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/services/audit_log_helper.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  final _auditHelper = AuditLogHelper();
  List<Map<String, dynamic>> _logs = [];
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
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _loading = true);

    List<Map<String, dynamic>> logs;
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

  String _formatTimestamp(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('dd/MM/yyyy HH:mm:ss', 'fr_FR').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _selectedModule = value);
              _loadLogs();
            },
            itemBuilder: (_) => _modules
                .map((m) => PopupMenuItem(
                      value: m,
                      child: Row(
                        children: [
                          if (m == _selectedModule)
                            const Icon(Icons.check,
                                size: 18, color: Colors.blue)
                          else
                            const SizedBox(width: 18),
                          const SizedBox(width: 8),
                          Text(m),
                        ],
                      ),
                    ))
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun log enregistré',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
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
                    // Barre d'info
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
                          Text(
                            '${_logs.length} entrée(s) — Filtre : $_selectedModule',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    // Liste
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: _logs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          final action = log['action'] ?? '';
                          final module = log['module'] ?? '';
                          final details = log['details'] ?? '';
                          final timestamp = log['timestamp'] ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _colorForAction(action).withOpacity(0.15),
                              child: Icon(
                                _iconForAction(action),
                                color: _colorForAction(action),
                                size: 22,
                              ),
                            ),
                            title: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _colorForAction(action)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    action,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _colorForAction(action),
                                    ),
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
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (details.isNotEmpty)
                                    Text(
                                      details,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTimestamp(timestamp),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isThreeLine: details.isNotEmpty,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
