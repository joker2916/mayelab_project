import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/providers.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/theme/app_theme.dart';
import 'package:drift/drift.dart' as drift;

int _amountTextToCents(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return 0;
  final value = double.tryParse(normalized);
  if (value == null || value.isNaN || value.isInfinite || value < 0) return 0;
  return (value * 100).round();
}

String _centsToAmountText(int cents) {
  if (cents == 0) return '';
  return (cents / 100).toStringAsFixed(2);
}

bool _isAmountInputValid(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return true;
  return RegExp(r'^\d+([\.,]\d{0,2})?$').hasMatch(text);
}

class EcrituresPage extends ConsumerStatefulWidget {
  const EcrituresPage({super.key});

  @override
  ConsumerState<EcrituresPage> createState() => _EcrituresPageState();
}

class _EcrituresPageState extends ConsumerState<EcrituresPage> {
  static const String _companyId = 'default-company';

  @override
  Widget build(BuildContext context) {
    final ecrituresAsync = ref.watch(ecrituresStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Écritures'), elevation: 0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle écriture'),
      ),
      body: ecrituresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (ecritures) {
          if (ecritures.isEmpty) return _buildEmptyState();
          return _buildListe(ecritures);
        },
      ),
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
            child: Icon(Icons.receipt_long,
                size: 64, color: AppTheme.primaryColor.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Aucune écriture',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Appuyez sur (+) pour créer une écriture',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildListe(List<Ecriture> ecritures) {
    final repo = ref.read(ecrituresRepositoryProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ecritures.length,
      itemBuilder: (context, i) => _EcritureCard(
        ecriture: ecritures[i],
        onEdit: () async {
          final ewl = await repo.fetchWithLines(ecritures[i].id);
          if (ewl != null) _ouvrirFormulaire(existing: ewl);
        },
        onDelete: () => _supprimer(ecritures[i]),
      ),
    );
  }

  void _ouvrirFormulaire({EcritureWithLines? existing}) async {
    final repo = ref.read(ecrituresRepositoryProvider);
    final comptes = await repo.getComptes();

    if (comptes.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.warning_amber, color: Colors.white),
            SizedBox(width: 8),
            Text('Ajoutez d\'abord des comptes'),
          ]),
          backgroundColor: AppTheme.warningColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (!mounted) return;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (ctx) => _EcritureFormSheet(
        comptes: comptes,
        existing: existing,
      ),
    );

    if (result == null) return;

    final lignesCompanion = (result['lignes'] as List<Map<String, dynamic>>)
        .map((l) => LigneEcrituresCompanion(
              compteId: drift.Value(l['compteId'] as int),
              debit: drift.Value(l['debit'] as int),
              credit: drift.Value(l['credit'] as int),
              description: drift.Value(l['description'] as String),
            ))
        .toList();

    try {
      if (existing == null) {
        await repo.create(
          companyId: _companyId,
          libelle: result['libelle'] as String,
          reference: result['reference'] as String?,
          date: result['date'] as DateTime,
          lignes: lignesCompanion,
        );
      } else {
        await repo.update(
          ecritureId: existing.ecriture.id,
          libelle: result['libelle'] as String,
          reference: result['reference'] as String?,
          date: result['date'] as DateTime,
          lignes: lignesCompanion,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _supprimer(Ecriture e) async {
    final repo = ref.read(ecrituresRepositoryProvider);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_amber,
                color: AppTheme.errorColor, size: 24),
          ),
          const SizedBox(width: 12),
          const Text('Supprimer ?'),
        ]),
        content: Text('Supprimer "${e.libelle}" ?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) await repo.delete(e.id);
  }
}

// ═══════════════════════════════════════════
// CARTE ÉCRITURE (widget séparé = pas de rebuild global)
// ═══════════════════════════════════════════
class _EcritureCard extends StatelessWidget {
  final Ecriture ecriture;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EcritureCard({
    required this.ecriture,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long,
                    color: AppTheme.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ecriture.libelle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      if ((ecriture.reference ?? '').isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.darkGrey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(ecriture.reference!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (ecriture.date != null)
                        Text(
                          '${ecriture.date!.day.toString().padLeft(2, '0')}/${ecriture.date!.month.toString().padLeft(2, '0')}/${ecriture.date!.year}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                    ]),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Icon(Icons.edit, size: 18, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text('Modifier'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete, size: 18, color: AppTheme.errorColor),
                      SizedBox(width: 8),
                      Text('Supprimer'),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// FORMULAIRE (widget séparé = son propre state)
// ═══════════════════════════════════════════
class _EcritureFormSheet extends StatefulWidget {
  final List<Compte> comptes;
  final EcritureWithLines? existing;

  const _EcritureFormSheet({required this.comptes, this.existing});

  @override
  State<_EcritureFormSheet> createState() => _EcritureFormSheetState();
}

class _EcritureFormSheetState extends State<_EcritureFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _libelleCtrl;
  late final TextEditingController _referenceCtrl;
  late DateTime _date;
  String _selectedCurrency = 'USD';
  late List<Map<String, dynamic>> _lignes;

  @override
  void initState() {
    super.initState();
    _libelleCtrl =
        TextEditingController(text: widget.existing?.ecriture.libelle ?? '');
    _referenceCtrl =
        TextEditingController(text: widget.existing?.ecriture.reference ?? '');
    _date = widget.existing?.ecriture.date ?? DateTime.now();

    _lignes = widget.existing != null
        ? widget.existing!.lignes
            .map((l) => {
                  'compteId': l.compteId,
                  'debit': l.debit,
                  'credit': l.credit,
                  'description': l.description ?? '',
                })
            .toList()
        : [
            {
              'compteId': widget.comptes.first.id,
              'debit': 0,
              'credit': 0,
              'description': ''
            }
          ];
  }

  @override
  void dispose() {
    _libelleCtrl.dispose();
    _referenceCtrl.dispose();
    super.dispose();
  }

  int get _totalDebit =>
      _lignes.fold<int>(0, (sum, l) => sum + ((l['debit'] as int?) ?? 0));
  int get _totalCredit =>
      _lignes.fold<int>(0, (sum, l) => sum + ((l['credit'] as int?) ?? 0));

  bool _validateBusinessRules() {
    if (_lignes.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Une écriture doit contenir au moins 2 lignes.'),
        ),
      );
      return false;
    }

    for (int i = 0; i < _lignes.length; i++) {
      final ligne = _lignes[i];
      final debit = (ligne['debit'] as int?) ?? 0;
      final credit = (ligne['credit'] as int?) ?? 0;

      if (debit < 0 || credit < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ligne ${i + 1} : montants négatifs interdits.'),
          ),
        );
        return false;
      }

      if (debit > 0 && credit > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Ligne ${i + 1} : renseigne soit débit, soit crédit.'),
          ),
        );
        return false;
      }

      if (debit == 0 && credit == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ligne ${i + 1} : montant débit ou crédit requis.'),
          ),
        );
        return false;
      }
    }

    if (_totalDebit <= 0 || _totalDebit != _totalCredit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Écriture déséquilibrée: débit ${(_totalDebit / 100).toStringAsFixed(2)} ≠ crédit ${(_totalCredit / 100).toStringAsFixed(2)}',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return false;
    }

    return true;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateBusinessRules()) return;

    Navigator.pop(context, {
      'libelle': _libelleCtrl.text.trim(),
      'reference': _referenceCtrl.text.trim().isEmpty
          ? null
          : _referenceCtrl.text.trim(),
      'date': _date,
      'lignes': _lignes,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.existing == null ? Icons.add : Icons.edit,
                      color: AppTheme.primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.existing == null
                      ? 'Nouvelle écriture'
                      : 'Modifier écriture',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ]),
              const SizedBox(height: 20),

              // Libellé
              _label('Libellé *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _libelleCtrl,
                decoration: InputDecoration(
                  hintText: 'Ex: Achat fournitures',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
              ),
              const SizedBox(height: 14),

              // Référence
              _label('Référence'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _referenceCtrl,
                decoration: InputDecoration(
                  hintText: 'Ex: FAC-001',
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),

              // Devise + Date
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Devise'),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCurrency,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                  value: 'USD', child: Text('🇺🇸 USD')),
                              DropdownMenuItem(
                                  value: 'CDF', child: Text('🇨🇩 CDF')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedCurrency = v);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Date'),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _date = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 20),

              // Lignes header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lignes comptables',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () => setState(() => _lignes.add({
                          'compteId': widget.comptes.first.id,
                          'debit': 0,
                          'credit': 0,
                          'description': ''
                        })),
                    icon: const Icon(Icons.add_circle_outline, size: 18),
                    label: const Text('Ajouter'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Lignes
              for (int i = 0; i < _lignes.length; i++)
                _LigneCard(
                  key: ValueKey('ligne_$i'),
                  index: i,
                  ligne: _lignes[i],
                  comptes: widget.comptes,
                  canRemove: _lignes.length > 1,
                  onRemove: () => setState(() => _lignes.removeAt(i)),
                  onChanged: (updated) => setState(() => _lignes[i] = updated),
                ),

              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _totalDebit == _totalCredit && _totalDebit > 0
                      ? AppTheme.successColor.withValues(alpha: 0.08)
                      : AppTheme.errorColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _totalDebit == _totalCredit && _totalDebit > 0
                        ? AppTheme.successColor.withValues(alpha: 0.3)
                        : AppTheme.errorColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Total débit: ${(_totalDebit / 100).toStringAsFixed(2)} | Total crédit: ${(_totalCredit / 100).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 20),

              // Boutons
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.existing == null ? Icons.add : Icons.save,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(widget.existing == null ? 'Créer' : 'Modifier'),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.bold));
  }
}

// ═══════════════════════════════════════════
// LIGNE COMPTABLE (widget séparé = rebuild isolé)
// ═══════════════════════════════════════════
class _LigneCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> ligne;
  final List<Compte> comptes;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _LigneCard({
    super.key,
    required this.index,
    required this.ligne,
    required this.comptes,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_LigneCard> createState() => _LigneCardState();
}

class _LigneCardState extends State<_LigneCard> {
  late int _compteId;
  late final TextEditingController _debitCtrl;
  late final TextEditingController _creditCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _compteId = widget.comptes.any((c) => c.id == widget.ligne['compteId'])
        ? widget.ligne['compteId'] as int
        : widget.comptes.first.id;
    final debitCents = (widget.ligne['debit'] as int?) ?? 0;
    final creditCents = (widget.ligne['credit'] as int?) ?? 0;
    _debitCtrl = TextEditingController(text: _centsToAmountText(debitCents));
    _creditCtrl = TextEditingController(text: _centsToAmountText(creditCents));
    _descCtrl =
        TextEditingController(text: widget.ligne['description'] as String);
  }

  @override
  void dispose() {
    _debitCtrl.dispose();
    _creditCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged({
      'compteId': _compteId,
      'debit': _amountTextToCents(_debitCtrl.text),
      'credit': _amountTextToCents(_creditCtrl.text),
      'description': _descCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mediumGrey),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Ligne ${widget.index + 1}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600)),
              ),
              if (widget.canRemove)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: AppTheme.errorColor, size: 20),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            initialValue: _compteId,
            decoration: InputDecoration(
              labelText: 'Compte',
              prefixIcon: const Icon(Icons.account_balance),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: widget.comptes
                .map((c) => DropdownMenuItem(
                    value: c.id, child: Text('${c.code} - ${c.nom}')))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _compteId = v);
                _notifyChange();
              }
            },
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: _debitCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Débit',
                  prefixIcon: const Icon(Icons.arrow_upward,
                      color: AppTheme.errorColor, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) =>
                    _isAmountInputValid(v ?? '') ? null : 'Montant invalide',
                onChanged: (_) => _notifyChange(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _creditCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Crédit',
                  prefixIcon: const Icon(Icons.arrow_downward,
                      color: AppTheme.successColor, size: 18),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (v) =>
                    _isAmountInputValid(v ?? '') ? null : 'Montant invalide',
                onChanged: (_) => _notifyChange(),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descCtrl,
            decoration: InputDecoration(
              labelText: 'Description',
              prefixIcon: const Icon(Icons.notes),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (_) => _notifyChange(),
          ),
        ],
      ),
    );
  }
}
