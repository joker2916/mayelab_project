import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/providers.dart';
import 'package:mayelab_project/services/grand_livre_pdf_service.dart';

class GrandLivreScreen extends ConsumerStatefulWidget {
  const GrandLivreScreen({super.key});

  @override
  ConsumerState<GrandLivreScreen> createState() => _GrandLivreScreenState();
}

class _GrandLivreScreenState extends ConsumerState<GrandLivreScreen> {
  Compte? _selectedCompte;

  @override
  Widget build(BuildContext context) {
    final comptesAsync = ref.watch(comptesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grand Livre'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedCompte != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Exporter PDF',
              onPressed: () {
                final lignesAsync = ref.read(
                  grandLivreProvider(_selectedCompte!.id),
                );
                lignesAsync.whenData((lignes) {
                  GrandLivrePdfService.exportAndPrint(
                    compte: _selectedCompte!,
                    lignes: lignes,
                  );
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // -- Dropdown sélection compte --
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: comptesAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Erreur: $e'),
              data: (comptes) => DropdownButtonFormField<Compte>(
                value: _selectedCompte,
                decoration: InputDecoration(
                  labelText: 'Sélectionner un compte',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.account_balance),
                ),
                items: comptes.map((c) {
                  return DropdownMenuItem<Compte>(
                    value: c,
                    child: Text('${c.code} — ${c.nom}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCompte = val),
              ),
            ),
          ),

          // -- Contenu grand livre --
          Expanded(
            child: _selectedCompte == null
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Sélectionnez un compte\npour voir ses mouvements',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : _GrandLivreTable(compte: _selectedCompte!),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Widget tableau grand livre
// ─────────────────────────────────────────

class _GrandLivreTable extends ConsumerWidget {
  final Compte compte;
  const _GrandLivreTable({required this.compte});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grandLivreAsync = ref.watch(grandLivreProvider(compte.id));

    return grandLivreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (lignes) {
        if (lignes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'Aucun mouvement pour\n${compte.code} — ${compte.nom}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // Calcul totaux et solde cumulé
        int totalDebit = 0;
        int totalCredit = 0;
        int solde = 0;
        final rows = <_RowData>[];

        for (final gl in lignes) {
          totalDebit += gl.ligne.debit;
          totalCredit += gl.ligne.credit;
          solde += gl.ligne.debit - gl.ligne.credit;
          rows.add(_RowData(gl: gl, soldeCumule: solde));
        }

        return Column(
          children: [
            // En-tête compte
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.indigo.shade100,
              child: Text(
                '${compte.code} — ${compte.nom}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.indigo,
                ),
              ),
            ),

            // Tableau
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      Colors.indigo.shade50,
                    ),
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Référence')),
                      DataColumn(label: Text('Libellé')),
                      DataColumn(label: Text('Débit'), numeric: true),
                      DataColumn(label: Text('Crédit'), numeric: true),
                      DataColumn(label: Text('Solde'), numeric: true),
                    ],
                    rows: rows.map((r) {
                      final date = r.gl.ecriture.date;
                      final dateStr = date != null
                          ? '${date.day.toString().padLeft(2, '0')}/'
                              '${date.month.toString().padLeft(2, '0')}/'
                              '${date.year}'
                          : '—';
                      final debit = r.gl.ligne.debit / 100;
                      final credit = r.gl.ligne.credit / 100;
                      final soldeVal = r.soldeCumule / 100;

                      return DataRow(cells: [
                        DataCell(Text(dateStr)),
                        DataCell(Text(r.gl.ecriture.reference ?? '—')),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              r.gl.ecriture.libelle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(
                          debit > 0 ? debit.toStringAsFixed(2) : '',
                          style: const TextStyle(color: Colors.green),
                        )),
                        DataCell(Text(
                          credit > 0 ? credit.toStringAsFixed(2) : '',
                          style: const TextStyle(color: Colors.red),
                        )),
                        DataCell(Text(
                          soldeVal.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: soldeVal >= 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Barre totaux
            Container(
              color: Colors.indigo.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _TotalChip(
                    label: 'Total Débit',
                    value: totalDebit / 100,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _TotalChip(
                    label: 'Total Crédit',
                    value: totalCredit / 100,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 16),
                  _TotalChip(
                    label: 'Solde Net',
                    value: (totalDebit - totalCredit) / 100,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────

class _RowData {
  final GrandLivreLigne gl;
  final int soldeCumule;
  _RowData({required this.gl, required this.soldeCumule});
}

class _TotalChip extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _TotalChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: color, fontSize: 13),
          children: [
            TextSpan(
                text: '$label : ',
                style: const TextStyle(fontWeight: FontWeight.normal)),
            TextSpan(
                text: value.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
