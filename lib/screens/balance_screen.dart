// lib/screens/balance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../balance_provider.dart';

class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  String _formatMontant(double montant) {
    final format = NumberFormat('#,##0.00', 'fr_FR');
    return format.format(montant);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    final filtre = ref.watch(balanceFiltreProvider);

    // Années disponibles pour le filtre
    final currentYear = DateTime.now().year;
    final availableYears = List.generate(5, (i) => currentYear - i);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance des Comptes'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          // Filtre année + mois
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF16213E),
            child: Row(
              children: [
                const Text('Année : ',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int?>(
                    value: filtre.annee,
                    dropdownColor: const Color(0xFF0F3460),
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    hint: const Text('Toutes',
                        style: TextStyle(color: Colors.white70)),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Toutes')),
                      ...availableYears.map(
                          (y) => DropdownMenuItem(value: y, child: Text('$y'))),
                    ],
                    onChanged: (val) {
                      ref.read(balanceFiltreProvider.notifier).state =
                          BalanceFiltreState(annee: val, mois: filtre.mois);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Mois : ',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int?>(
                    value: filtre.mois,
                    dropdownColor: const Color(0xFF0F3460),
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    hint: const Text('Tous',
                        style: TextStyle(color: Colors.white70)),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Tous')),
                      ...List.generate(
                          12,
                          (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text(DateFormat.MMMM('fr_FR')
                                  .format(DateTime(2024, i + 1))))),
                    ],
                    onChanged: (val) {
                      ref.read(balanceFiltreProvider.notifier).state =
                          BalanceFiltreState(annee: filtre.annee, mois: val);
                    },
                  ),
                ),
              ],
            ),
          ),

          // En-tête
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: const Color(0xFF0F3460),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Compte',
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                Expanded(
                    flex: 2,
                    child: Text('Débit',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                Expanded(
                    flex: 2,
                    child: Text('Crédit',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                Expanded(
                    flex: 2,
                    child: Text('S. Déb.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                Expanded(
                    flex: 2,
                    child: Text('S. Créd.',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.tealAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
              ],
            ),
          ),

          // Liste
          Expanded(
            child: balanceAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Erreur : $e',
                    style: const TextStyle(color: Colors.red)),
              ),
              data: (balanceList) {
                if (balanceList.isEmpty) {
                  return const Center(
                    child: Text('Aucune donnée',
                        style: TextStyle(color: Colors.white54)),
                  );
                }

                double totalDebit = 0, totalCredit = 0;
                double totalSoldeDebiteur = 0, totalSoldeCrediteur = 0;
                for (var item in balanceList) {
                  totalDebit += item.totalDebit;
                  totalCredit += item.totalCredit;
                  totalSoldeDebiteur += item.soldeDebit;
                  totalSoldeCrediteur += item.soldeCredit;
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: balanceList.length,
                        itemBuilder: (context, index) {
                          final item = balanceList[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: index.isEven
                                  ? const Color(0xFF1A1A2E)
                                  : const Color(0xFF16213E),
                              border: const Border(
                                  bottom: BorderSide(
                                      color: Colors.white12, width: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.compteCode,
                                            style: const TextStyle(
                                                color: Colors.tealAccent,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold)),
                                        Text(item.compteNom,
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 9)),
                                      ],
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(_formatMontant(item.totalDebit),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11))),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        _formatMontant(item.totalCredit),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11))),
                                Expanded(
                                    flex: 2,
                                    child: Text(_formatMontant(item.soldeDebit),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: Colors.blue, fontSize: 11))),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        _formatMontant(item.soldeCredit),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 11))),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Totaux
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      color: const Color(0xFF0F3460),
                      child: Row(
                        children: [
                          const Expanded(
                              flex: 2,
                              child: Text('TOTAUX',
                                  style: TextStyle(
                                      color: Colors.tealAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))),
                          Expanded(
                              flex: 2,
                              child: Text(_formatMontant(totalDebit),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))),
                          Expanded(
                              flex: 2,
                              child: Text(_formatMontant(totalCredit),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))),
                          Expanded(
                              flex: 2,
                              child: Text(_formatMontant(totalSoldeDebiteur),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))),
                          Expanded(
                              flex: 2,
                              child: Text(_formatMontant(totalSoldeCrediteur),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
