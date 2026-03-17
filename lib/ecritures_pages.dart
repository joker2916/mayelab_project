// lib/ecritures_pages.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/providers.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:drift/drift.dart' as drift;

class EcrituresPage extends ConsumerStatefulWidget {
  const EcrituresPage({super.key});

  @override
  ConsumerState<EcrituresPage> createState() => _EcrituresPageState();
}

class _EcrituresPageState extends ConsumerState<EcrituresPage> {
  static const String _companyId = 'default-company';

  AppDatabase get _db => ref.read(databaseProvider);

  void _ouvrirFormulaire({EcritureWithLines? existing}) async {
    final comptes = await (_db.select(_db.comptes)
          ..orderBy([(c) => drift.OrderingTerm(expression: c.code)]))
        .get();

    if (comptes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez d\'abord des comptes')),
      );
      return;
    }

    final formKey = GlobalKey<FormState>();
    final libelleCtrl =
        TextEditingController(text: existing?.ecriture.libelle ?? '');
    final referenceCtrl =
        TextEditingController(text: existing?.ecriture.reference ?? '');
    DateTime date = existing?.ecriture.date ?? DateTime.now();
    String selectedCurrency = 'USD';

    List<Map<String, dynamic>> lignes = existing != null
        ? existing.lignes
            .map((l) => {
                  'compteId': l.compteId,
                  'debit': l.debit,
                  'credit': l.credit,
                  'description': l.description ?? '',
                })
            .toList()
        : [
            {
              'compteId': comptes.first.id,
              'debit': 0,
              'credit': 0,
              'description': '',
            }
          ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        existing == null
                            ? 'Nouvelle écriture'
                            : 'Modifier écriture',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Libellé
                      TextFormField(
                        controller: libelleCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Libellé *'),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Requis' : null,
                      ),
                      const SizedBox(height: 8),

                      // Référence
                      TextFormField(
                        controller: referenceCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Référence'),
                      ),
                      const SizedBox(height: 8),

                      // Devise
                      Row(
                        children: [
                          const Text('Devise : ',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: selectedCurrency,
                            items: const [
                              DropdownMenuItem(
                                  value: 'USD', child: Text('🇺🇸 USD')),
                              DropdownMenuItem(
                                  value: 'CDF', child: Text('🇨🇩 CDF')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setModalState(() => selectedCurrency = v);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Date
                      Row(
                        children: [
                          const Text('Date : '),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setModalState(() => date = picked);
                              }
                            },
                            child: Text(
                              '${date.day.toString().padLeft(2, '0')}/'
                              '${date.month.toString().padLeft(2, '0')}/'
                              '${date.year}',
                            ),
                          ),
                        ],
                      ),
                      const Divider(),

                      // Lignes
                      const Text('Lignes',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      ...lignes.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ligne = entry.value;
                        final debitCtrl = TextEditingController(
                            text: ligne['debit'].toString());
                        final creditCtrl = TextEditingController(
                            text: ligne['credit'].toString());
                        final descCtrl =
                            TextEditingController(text: ligne['description']);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                // Sélecteur de compte
                                DropdownButtonFormField<int>(
                                  value: ligne['compteId'] as int,
                                  decoration: const InputDecoration(
                                      labelText: 'Compte'),
                                  items: comptes
                                      .map((c) => DropdownMenuItem(
                                            value: c.id,
                                            child: Text('${c.code} - ${c.nom}'),
                                          ))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) {
                                      setModalState(
                                          () => lignes[i]['compteId'] = v);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    // Débit
                                    Expanded(
                                      child: TextFormField(
                                        controller: debitCtrl,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            labelText: 'Débit'),
                                        onChanged: (v) => lignes[i]['debit'] =
                                            int.tryParse(v) ?? 0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Crédit
                                    Expanded(
                                      child: TextFormField(
                                        controller: creditCtrl,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            labelText: 'Crédit'),
                                        onChanged: (v) => lignes[i]['credit'] =
                                            int.tryParse(v) ?? 0,
                                      ),
                                    ),
                                    // Supprimer ligne
                                    if (lignes.length > 1)
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () => setModalState(
                                            () => lignes.removeAt(i)),
                                      ),
                                  ],
                                ),
                                // Description
                                TextFormField(
                                  controller: descCtrl,
                                  decoration: const InputDecoration(
                                      labelText: 'Description'),
                                  onChanged: (v) =>
                                      lignes[i]['description'] = v,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // Ajouter ligne
                      TextButton.icon(
                        onPressed: () => setModalState(() => lignes.add({
                              'compteId': comptes.first.id,
                              'debit': 0,
                              'credit': 0,
                              'description': '',
                            })),
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter une ligne'),
                      ),

                      const SizedBox(height: 16),

                      // Bouton valider
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            final lignesCompanion = lignes
                                .map((l) => LigneEcrituresCompanion(
                                      compteId:
                                          drift.Value(l['compteId'] as int),
                                      debit: drift.Value(l['debit'] as int),
                                      credit: drift.Value(l['credit'] as int),
                                      description: drift.Value(
                                          l['description'] as String),
                                    ))
                                .toList();

                            try {
                              if (existing == null) {
                                await _db.createPieceWithLines(
                                  companyId: _companyId,
                                  libelle: libelleCtrl.text.trim(),
                                  reference: referenceCtrl.text.trim().isEmpty
                                      ? null
                                      : referenceCtrl.text.trim(),
                                  date: date,
                                  lines: lignesCompanion,
                                );
                              } else {
                                await _db.updatePieceWithLines(
                                  ecritureId: existing.ecriture.id,
                                  libelle: libelleCtrl.text.trim(),
                                  reference: referenceCtrl.text.trim().isEmpty
                                      ? null
                                      : referenceCtrl.text.trim(),
                                  date: date,
                                  lines: lignesCompanion,
                                );
                              }
                              if (ctx.mounted) Navigator.pop(ctx);
                            } catch (e) {
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text(e
                                        .toString()
                                        .replaceAll('Exception: ', '')),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(existing == null ? 'Créer' : 'Modifier'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _supprimer(Ecriture e) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Supprimer "${e.libelle}" ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child:
                  const Text('Supprimer', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await _db.deletePieceById(e.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écritures'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _ouvrirFormulaire(),
          ),
        ],
      ),
      body: StreamBuilder<List<Ecriture>>(
        stream: _db.watchAllPieces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final ecritures = snapshot.data ?? [];
          if (ecritures.isEmpty) {
            return const Center(child: Text('Aucune écriture'));
          }
          return ListView.builder(
            itemCount: ecritures.length,
            itemBuilder: (context, i) {
              final e = ecritures[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.receipt_long, color: Colors.blue),
                ),
                title: Text(e.libelle),
                subtitle: Text(
                  '${e.reference ?? ''} • '
                  '${e.date != null ? '${e.date!.day.toString().padLeft(2, '0')}/${e.date!.month.toString().padLeft(2, '0')}/${e.date!.year}' : ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () async {
                        final ewl = await _db.fetchPieceWithLines(e.id);
                        if (ewl != null) _ouvrirFormulaire(existing: ewl);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete,
                          size: 20, color: Colors.redAccent),
                      onPressed: () => _supprimer(e),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
