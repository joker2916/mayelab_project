import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/services/audit_log_helper.dart';
import 'package:mayelab_project/theme/app_theme.dart';

class AuditLogPage extends StatefulWidget {
  final AppDatabase database;

  const AuditLogPage({super.key, required this.database});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  late final AuditLogHelper _auditHelper;
  List<AuditLog> _logs = [];
  bool _loading = true;
  String _selectedModule = 'Tous';

  static const Map<String, String?> _moduleFilters = {
    'Tous': null,
    'Comptes': 'comptes',
    'Écritures': 'ecritures',
    'Journal': 'journal',
    'Auth': 'auth',
  };

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
    final selectedEntity = _moduleFilters[_selectedModule];
    if (selectedEntity == null) {
      logs = await _auditHelper.getAllLogs();
    } else {
      logs = await _auditHelper.getLogsByModule(selectedEntity);
    }

    setState(() {
      _logs = logs;
      _loading = false;
    });
  }

  IconData _iconForAction(String action) {
    switch (action.toLowerCase()) {
      case 'création':
      case 'insert':
        return Icons.add_circle;
      case 'modification':
      case 'update':
        return Icons.edit;
      case 'suppression':
      case 'delete':
        return Icons.delete;
      case 'connexion':
      case 'login':
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
      case 'insert':
        return AppTheme.successColor;
      case 'modification':
      case 'update':
        return AppTheme.warningColor;
      case 'suppression':
      case 'delete':
        return AppTheme.errorColor;
      case 'connexion':
      case 'login':
        return AppTheme.primaryColor;
      case 'validation':
        return AppTheme.secondaryColor;
      case 'annulation':
        return Colors.purple;
      default:
        return AppTheme.darkGrey;
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
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.tune, size: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                setState(() => _selectedModule = value);
                _loadLogs();
              },
              itemBuilder: (context) => _modules
                  .map((m) => PopupMenuItem(
                        value: m,
                        child: Row(
                          children: [
                            if (m == _selectedModule)
                              const Icon(Icons.check,
                                  size: 18, color: AppTheme.primaryColor)
                            else
                              const SizedBox(width: 24),
                            const SizedBox(width: 8),
                            Text(m),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? _buildEmptyState()
              : _buildLogsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 64,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun log enregistré',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (_selectedModule != 'Tous')
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'Filtre actif : $_selectedModule',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppTheme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogsList() {
    return Column(
      children: [
        // Barre info totaux
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            border: Border(
              bottom: BorderSide(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                '${_logs.length} enregistrement${_logs.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
              ),
            ],
          ),
        ),
        // Liste des logs
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _logs.length,
            itemBuilder: (context, index) {
              final log = _logs[index];
              return _buildLogCard(log);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogCard(AuditLog log) {
    final actionColor = _colorForAction(log.action);
    final hasDetails = (log.details ?? '').isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showLogDetails(log),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header : action + module
              Row(
                children: [
                  // Icône action
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: actionColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _iconForAction(log.action),
                      color: actionColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action + Module
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.action,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: actionColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.mediumGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            log.entity,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Détails (si présents)
              if (hasDetails) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                  child: Text(
                    log.details!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              // Timestamp
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTimestamp(log.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(AuditLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _colorForAction(log.action).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconForAction(log.action),
                color: _colorForAction(log.action),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.action),
                  Text(
                    log.entity,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Module', log.entity),
            const SizedBox(height: 12),
            _detailRow('Action', log.action),
            const SizedBox(height: 12),
            _detailRow('Date/Heure', _formatTimestamp(log.createdAt)),
            if ((log.details ?? '').isNotEmpty) ...[
              const SizedBox(height: 12),
              _detailRow('Détails', log.details!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGrey,
              ),
        ),
      ],
    );
  }
}
