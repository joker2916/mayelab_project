// lib/screens/balancePage.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'balance_provider.dart';
import 'package:mayelab_project/theme/app_theme.dart';
import 'package:mayelab_project/widgets/ui_panels.dart';

class BalancePage extends ConsumerWidget {
  const BalancePage({super.key});

  String _formatMontant(double montant) {
    final format = NumberFormat('#,##0.00', 'fr_FR');
    return format.format(montant);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    final filtre = ref.watch(balanceFiltreProvider);

    final currentYear = DateTime.now().year;
    final availableYears = List.generate(8, (i) => currentYear - i);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: balanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (balanceList) {
          double totalDebit = 0;
          double totalCredit = 0;
          double totalSoldeDebiteur = 0;
          double totalSoldeCrediteur = 0;
          for (final item in balanceList) {
            totalDebit += item.totalDebit;
            totalCredit += item.totalCredit;
            totalSoldeDebiteur += item.soldeDebit;
            totalSoldeCrediteur += item.soldeCredit;
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                SectionCard(
                  title: 'Filtres',
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: filtre.annee,
                          decoration: const InputDecoration(
                            labelText: 'Année',
                          ),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('Toutes')),
                            ...availableYears.map((y) => DropdownMenuItem(
                                  value: y,
                                  child: Text('$y'),
                                )),
                          ],
                          onChanged: (val) {
                            ref.read(balanceFiltreProvider.notifier).state =
                                BalanceFiltreState(
                              annee: val,
                              mois: filtre.mois,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          initialValue: filtre.mois,
                          decoration: const InputDecoration(
                            labelText: 'Mois',
                          ),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('Tous')),
                            ...List.generate(
                              12,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text(DateFormat.MMMM('fr_FR')
                                    .format(DateTime(2024, i + 1))),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            ref.read(balanceFiltreProvider.notifier).state =
                                BalanceFiltreState(
                              annee: filtre.annee,
                              mois: val,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SectionCard(
                  title: 'Synthèse',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MetricChip(
                        label: 'Débit total',
                        value: _formatMontant(totalDebit),
                        color: AppTheme.primaryColor,
                      ),
                      MetricChip(
                        label: 'Crédit total',
                        value: _formatMontant(totalCredit),
                        color: AppTheme.secondaryColor,
                      ),
                      MetricChip(
                        label: 'Solde débiteur',
                        value: _formatMontant(totalSoldeDebiteur),
                        color: Colors.blue.shade700,
                      ),
                      MetricChip(
                        label: 'Solde créditeur',
                        value: _formatMontant(totalSoldeCrediteur),
                        color: Colors.red.shade700,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SectionCard(
                    title: 'Détail des comptes',
                    child: balanceList.isEmpty
                        ? const EmptyStatePanel(
                            icon: Icons.table_chart_outlined,
                            title: 'Aucune donnée de balance',
                            message:
                                'Modifie les filtres ou ajoute des écritures.',
                          )
                        : ListView.separated(
                            itemCount: balanceList.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = balanceList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.compteCode} - ${item.compteNom}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ValueLine(
                                            label: 'Débit',
                                            value:
                                                _formatMontant(item.totalDebit),
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: _ValueLine(
                                            label: 'Crédit',
                                            value: _formatMontant(
                                                item.totalCredit),
                                            color: AppTheme.secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ValueLine(
                                            label: 'S. déb.',
                                            value:
                                                _formatMontant(item.soldeDebit),
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Expanded(
                                          child: _ValueLine(
                                            label: 'S. créd.',
                                            value: _formatMontant(
                                                item.soldeCredit),
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ValueLine extends StatelessWidget {
  const _ValueLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
