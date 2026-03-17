// lib/balance_provider.dart
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mayelab_project/providers.dart';

class BalanceItem {
  final String compteCode;
  final String compteNom;
  final double totalDebit;
  final double totalCredit;

  BalanceItem({
    required this.compteCode,
    required this.compteNom,
    required this.totalDebit,
    required this.totalCredit,
  });

  double get soldeDebit =>
      totalDebit > totalCredit ? totalDebit - totalCredit : 0;

  double get soldeCredit =>
      totalCredit > totalDebit ? totalCredit - totalDebit : 0;
}

class BalanceFiltreState {
  final int? mois;
  final int? annee;
  const BalanceFiltreState({this.mois, this.annee});
}

final balanceFiltreProvider =
    StateProvider<BalanceFiltreState>((ref) => const BalanceFiltreState());

final balanceProvider = FutureProvider<List<BalanceItem>>((ref) async {
  final db = ref.watch(databaseProvider);
  final filtre = ref.watch(balanceFiltreProvider);

  String whereClause = 'WHERE e.is_deleted = 0';
  List<Variable<Object>> variables = [];

  if (filtre.mois != null && filtre.annee != null) {
    whereClause +=
        " AND strftime('%m', e.date) = ? AND strftime('%Y', e.date) = ?";
    variables = [
      Variable<String>(filtre.mois!.toString().padLeft(2, '0')),
      Variable<String>(filtre.annee.toString()),
    ];
  } else if (filtre.annee != null) {
    whereClause += " AND strftime('%Y', e.date) = ?";
    variables = [
      Variable<String>(filtre.annee.toString()),
    ];
  }

  final result = await db.customSelect('''
    SELECT 
      c.code,
      c.nom,
      COALESCE(SUM(el.debit), 0) as total_debit,
      COALESCE(SUM(el.credit), 0) as total_credit
    FROM comptes c
    INNER JOIN ligne_ecritures el ON c.id = el.compte_id
    INNER JOIN ecritures e ON el.ecriture_id = e.id
    $whereClause
    GROUP BY c.id, c.code, c.nom
    HAVING total_debit > 0 OR total_credit > 0
    ORDER BY c.code
  ''', variables: variables).get();

  return result
      .map((row) => BalanceItem(
            compteCode: row.read<String>('code'),
            compteNom: row.read<String>('nom'),
            totalDebit: row.read<int>('total_debit') / 100.0,
            totalCredit: row.read<int>('total_credit') / 100.0,
          ))
      .toList();
});
