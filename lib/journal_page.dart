// lib/journal_page.dart
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/providers.dart';

class JournalPage extends ConsumerWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PieceFormPage(db: db),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Ecriture>>(
        stream: db.watchAllPieces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Aucune pièce'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final e = items[i];
              return ListTile(
                title: Text(e.libelle),
                subtitle: Text(
                  '${e.reference ?? ''} — ${e.date?.toString().substring(0, 10) ?? ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, db, e.id),
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PieceFormPage(db: db, ecritureId: e.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, AppDatabase db, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer'),
        content: const Text('Supprimer cette pièce ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true) await db.deletePieceById(id);
  }
}

// ============================================================
// FORMULAIRE PIECE + LIGNES
// ============================================================

class _LigneForm {
  int? compteId;
  String compteLabel = '';
  final debitCtrl = TextEditingController();
  final creditCtrl = TextEditingController();

  int get debitCents => ((double.tryParse(debitCtrl.text) ?? 0) * 100).round();
  int get creditCents =>
      ((double.tryParse(creditCtrl.text) ?? 0) * 100).round();

  void dispose() {
    debitCtrl.dispose();
    creditCtrl.dispose();
  }
}

class PieceFormPage extends StatefulWidget {
  final AppDatabase db;
  final String? ecritureId; // null = création

  const PieceFormPage({super.key, required this.db, this.ecritureId});

  @override
  State<PieceFormPage> createState() => _PieceFormPageState();
}

class _PieceFormPageState extends State<PieceFormPage> {
  final _libelleCtrl = TextEditingController();
  final _refCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  final List<_LigneForm> _lignes = [];
  List<Compte> _comptes = [];
  bool _loading = true;

  bool get isEdit => widget.ecritureId != null;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _comptes = await widget.db.select(widget.db.comptes).get();

    if (isEdit) {
      final data = await widget.db.fetchPieceWithLines(widget.ecritureId!);
      if (data != null) {
        _libelleCtrl.text = data.ecriture.libelle;
        _refCtrl.text = data.ecriture.reference ?? '';
        _date = data.ecriture.date ?? DateTime.now();
        for (final l in data.lignes) {
          final lf = _LigneForm()
            ..compteId = l.compteId
            ..debitCtrl.text =
                l.debit > 0 ? (l.debit / 100).toStringAsFixed(2) : ''
            ..creditCtrl.text =
                l.credit > 0 ? (l.credit / 100).toStringAsFixed(2) : '';
          // trouver le label
          final c = _comptes.where((c) => c.id == l.compteId).firstOrNull;
          if (c != null) lf.compteLabel = '${c.code} - ${c.nom}';
          _lignes.add(lf);
        }
      }
    }

    // Au moins 2 lignes par défaut
    while (_lignes.length < 2) {
      _lignes.add(_LigneForm());
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _libelleCtrl.dispose();
    _refCtrl.dispose();
    for (final l in _lignes) {
      l.dispose();
    }
    super.dispose();
  }

  void _addLigne() => setState(() => _lignes.add(_LigneForm()));

  void _removeLigne(int index) {
    if (_lignes.length <= 2) return;
    setState(() {
      _lignes[index].dispose();
      _lignes.removeAt(index);
    });
  }

  int get _totalDebit => _lignes.fold(0, (s, l) => s + l.debitCents);
  int get _totalCredit => _lignes.fold(0, (s, l) => s + l.creditCents);
  bool get _isEquilibre => _totalDebit == _totalCredit && _totalDebit > 0;

  Future<void> _save() async {
    final libelle = _libelleCtrl.text.trim();
    if (libelle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le libellé est obligatoire')),
      );
      return;
    }

    // Vérifier que chaque ligne a un compte
    for (int i = 0; i < _lignes.length; i++) {
      if (_lignes[i].compteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ligne ${i + 1} : sélectionnez un compte')),
        );
        return;
      }
    }

    if (!_isEquilibre) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Écriture déséquilibrée : '
            'Débit ${(_totalDebit / 100).toStringAsFixed(2)} ≠ '
            'Crédit ${(_totalCredit / 100).toStringAsFixed(2)}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final lines = _lignes
        .map((l) => LigneEcrituresCompanion(
              compteId: Value(l.compteId!),
              debit: Value(l.debitCents),
              credit: Value(l.creditCents),
            ))
        .toList();

    try {
      if (isEdit) {
        await widget.db.updatePieceWithLines(
          ecritureId: widget.ecritureId!,
          libelle: libelle,
          reference: _refCtrl.text.trim().isEmpty ? null : _refCtrl.text.trim(),
          date: _date,
          lines: lines,
        );
      } else {
        await widget.db.createPieceWithLines(
          companyId: 'default-company',
          libelle: libelle,
          reference: _refCtrl.text.trim().isEmpty ? null : _refCtrl.text.trim(),
          date: _date,
          lines: lines,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar:
            AppBar(title: Text(isEdit ? 'Modifier pièce' : 'Nouvelle pièce')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier pièce' : 'Nouvelle pièce'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _save),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- EN-TÊTE ----
            TextField(
              controller: _libelleCtrl,
              decoration: const InputDecoration(
                labelText: 'Libellé *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _refCtrl,
              decoration: const InputDecoration(
                labelText: 'Référence (optionnelle)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Date : ${_date.toString().substring(0, 10)}',
              ),
            ),
            const SizedBox(height: 20),

            // ---- LIGNES ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lignes d\'écriture',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _addLigne,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...List.generate(_lignes.length, (i) {
              final l = _lignes[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Ligne ${i + 1}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          if (_lignes.length > 2)
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
                              onPressed: () => _removeLigne(i),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Sélecteur de compte
                      DropdownButtonFormField<int>(
                        value: l.compteId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Compte',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: _comptes
                            .map((c) => DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text('${c.code} - ${c.nom}',
                                      overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => l.compteId = val),
                      ),
                      const SizedBox(height: 8),

                      // Débit + Crédit
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: l.debitCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Débit',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: l.creditCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Crédit',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Divider(),

            // ---- TOTAUX ----
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isEquilibre ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Débit : ${(_totalDebit / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Crédit : ${(_totalCredit / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Icon(
                    _isEquilibre ? Icons.check_circle : Icons.warning,
                    color: _isEquilibre ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---- BOUTON SAUVEGARDER ----
            ElevatedButton.icon(
              onPressed: _isEquilibre ? _save : null,
              icon: const Icon(Icons.save),
              label: Text(isEdit ? 'Mettre à jour' : 'Enregistrer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
