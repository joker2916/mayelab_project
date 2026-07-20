import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/db/app_database.dart';
import 'package:mayelab_project/providers.dart';
import 'package:mayelab_project/services/grand_livre_pdf_service.dart';
import 'package:mayelab_project/theme/app_theme.dart';
import 'package:mayelab_project/widgets/ui_panels.dart';

class GrandLivrePage extends ConsumerStatefulWidget {
  const GrandLivrePage({super.key});

  @override
  ConsumerState<GrandLivrePage> createState() => _GrandLivrePageState();
}

class _GrandLivrePageState extends ConsumerState<GrandLivrePage> {
  Compte? _selectedCompte;

  String _formatMoney(int cents) {
    return NumberFormat('#,##0.00', 'fr_FR').format(cents / 100);
  }

  @override
  Widget build(BuildContext context) {
    final comptesAsync = ref.watch(comptesStreamProvider);
    final lignesAsync = _selectedCompte == null
        ? null
        : ref.watch(grandLivreProvider(_selectedCompte!.id));

    int totalDebit = 0;
    int totalCredit = 0;
    if (lignesAsync != null) {
      lignesAsync.whenData((lignes) {
        for (final ligne in lignes) {
          totalDebit += ligne.ligne.debit;
          totalCredit += ligne.ligne.credit;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grand Livre'),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          children: [
            SectionCard(
              title: 'Compte',
              trailing: _selectedCompte == null
                  ? null
                  : IconButton(
                      onPressed: () => setState(() => _selectedCompte = null),
                      icon: const Icon(Icons.close),
                      tooltip: 'Réinitialiser',
                    ),
              child: comptesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
                error: (e, _) => Text('Erreur: $e'),
                data: (comptes) => DropdownButtonFormField<Compte>(
                  initialValue: _selectedCompte,
                  decoration: const InputDecoration(
                    labelText: 'Sélectionner un compte',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  items: comptes
                      .map((c) => DropdownMenuItem<Compte>(
                            value: c,
                            child: Text('${c.code} — ${c.nom}'),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCompte = val),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedCompte != null)
              SectionCard(
                title: 'Synthèse',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    MetricChip(
                      label: 'Total débit',
                      value: _formatMoney(totalDebit),
                      color: AppTheme.primaryColor,
                    ),
                    MetricChip(
                      label: 'Total crédit',
                      value: _formatMoney(totalCredit),
                      color: AppTheme.secondaryColor,
                    ),
                    MetricChip(
                      label: 'Solde net',
                      value: _formatMoney(totalDebit - totalCredit),
                      color: (totalDebit - totalCredit) >= 0
                          ? Colors.blue.shade700
                          : Colors.red.shade700,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: _selectedCompte == null
                  ? const EmptyStatePanel(
                      icon: Icons.menu_book_outlined,
                      title: 'Aucun compte sélectionné',
                      message:
                          'Choisis un compte pour afficher le grand livre.',
                    )
                  : _GrandLivreTable(compte: _selectedCompte!),
            ),
          ],
        ),
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

  String _formatMoney(int cents) {
    return NumberFormat('#,##0.00', 'fr_FR').format(cents / 100);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grandLivreAsync = ref.watch(grandLivreProvider(compte.id));

    return grandLivreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur: $e')),
      data: (lignes) {
        if (lignes.isEmpty) {
          return EmptyStatePanel(
            icon: Icons.inbox_outlined,
            title: 'Aucun mouvement',
            message: 'Aucun mouvement pour ${compte.code} — ${compte.nom}.',
          );
        }

        int solde = 0;
        final rows = <_RowData>[];

        for (final gl in lignes) {
          solde += gl.ligne.debit - gl.ligne.credit;
          rows.add(_RowData(gl: gl, soldeCumule: solde));
        }

        return SectionCard(
          title: '${compte.code} — ${compte.nom}',
          child: ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = rows[i];
              final date = r.gl.ecriture.date;
              final dateStr =
                  date == null ? '—' : DateFormat('dd/MM/yyyy').format(date);
              final debit = r.gl.ligne.debit;
              final credit = r.gl.ligne.credit;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.gl.ecriture.libelle,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateStr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Réf: ${r.gl.ecriture.reference ?? '—'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MetricChip(
                          label: 'Débit',
                          value: _formatMoney(debit),
                          color: AppTheme.primaryColor,
                        ),
                        MetricChip(
                          label: 'Crédit',
                          value: _formatMoney(credit),
                          color: AppTheme.secondaryColor,
                        ),
                        MetricChip(
                          label: 'Solde cumulé',
                          value: _formatMoney(r.soldeCumule),
                          color: r.soldeCumule >= 0
                              ? Colors.blue.shade700
                              : Colors.red.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
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
