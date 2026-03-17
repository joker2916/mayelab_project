// lib/screens/balance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mayelab_project/balance_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BalanceScreen extends ConsumerStatefulWidget {
  const BalanceScreen({super.key});

  @override
  ConsumerState<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends ConsumerState<BalanceScreen> {
  final formatMontant = NumberFormat('#,##0.00', 'fr_FR');

  int? _moisSelectionne;
  int? _anneeSelectionnee;

  final List<String> _mois = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  final List<int> _annees = List.generate(10, (i) => 2022 + i);

  void _appliquerFiltre() {
    ref.read(balanceFiltreProvider.notifier).state = BalanceFiltreState(
      mois: _moisSelectionne,
      annee: _anneeSelectionnee,
    );
  }

  void _reinitialiserFiltre() {
    setState(() {
      _moisSelectionne = null;
      _anneeSelectionnee = null;
    });
    ref.read(balanceFiltreProvider.notifier).state = const BalanceFiltreState();
  }

  // ══════════════════════════════════════════════════════════
  //  EXPORT PDF
  // ══════════════════════════════════════════════════════════
  Future<void> _exporterPdf(List<BalanceItem> items) async {
    final pdf = pw.Document();
    final fmt = NumberFormat('#,##0.00', 'fr_FR');

    // Totaux
    double totD = 0, totC = 0, totSD = 0, totSC = 0;
    for (final i in items) {
      totD += i.totalDebit;
      totC += i.totalCredit;
      totSD += i.soldeDebit;
      totSC += i.soldeCredit;
    }

    // Période affichée
    String periode = 'Toutes périodes';
    if (_moisSelectionne != null && _anneeSelectionnee != null) {
      periode = '${_mois[_moisSelectionne! - 1]} $_anneeSelectionnee';
    } else if (_anneeSelectionnee != null) {
      periode = 'Année $_anneeSelectionnee';
    } else if (_moisSelectionne != null) {
      periode = _mois[_moisSelectionne! - 1];
    }

    final headers = [
      'Code',
      'Compte',
      'Débit',
      'Crédit',
      'S.Débit',
      'S.Crédit'
    ];

    final dataRows = items
        .map((e) => [
              e.compteCode,
              e.compteNom,
              e.totalDebit == 0 ? '—' : fmt.format(e.totalDebit),
              e.totalCredit == 0 ? '—' : fmt.format(e.totalCredit),
              e.soldeDebit == 0 ? '—' : fmt.format(e.soldeDebit),
              e.soldeCredit == 0 ? '—' : fmt.format(e.soldeCredit),
            ])
        .toList();

    // Ligne totaux
    dataRows.add([
      '',
      'TOTAUX',
      fmt.format(totD),
      fmt.format(totC),
      fmt.format(totSD),
      fmt.format(totSC),
    ]);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('BALANCE DES COMPTES',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Période : $periode',
                style: const pw.TextStyle(fontSize: 11)),
            pw.Text(
                'Édité le : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 10),
          ],
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            headerStyle:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo50),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellAlignment: pw.Alignment.centerRight,
            columnWidths: {
              0: const pw.FixedColumnWidth(60),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(80),
              3: const pw.FixedColumnWidth(80),
              4: const pw.FixedColumnWidth(80),
              5: const pw.FixedColumnWidth(80),
            },
            headers: headers,
            data: dataRows,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
          ),
        ],
      ),
    );

    // Aperçu / Impression / Partage
    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'Balance_$periode.pdf',
    );
  }

  // ══════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final balanceAsync = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance des comptes'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // ✅ BOUTON EXPORT PDF
          balanceAsync.maybeWhen(
            data: (items) => IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Exporter PDF',
              onPressed: items.isEmpty ? null : () => _exporterPdf(items),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: 'Réinitialiser',
            onPressed: _reinitialiserFiltre,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltre(),
          _buildEnTete(),
          Expanded(
            child: balanceAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (items) => items.isEmpty
                  ? const Center(child: Text('Aucune donnée'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildLigne(item, index);
                      },
                    ),
            ),
          ),
          balanceAsync.maybeWhen(
            data: (items) => _buildTotaux(items),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ─── FILTRE ───────────────────────────────────────────────
  Widget _buildFiltre() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.indigo.shade50,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _moisSelectionne,
              decoration: const InputDecoration(
                labelText: 'Mois',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                12,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text(_mois[i], style: const TextStyle(fontSize: 12)),
                ),
              ),
              onChanged: (v) {
                setState(() => _moisSelectionne = v);
                _appliquerFiltre();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _anneeSelectionnee,
              decoration: const InputDecoration(
                labelText: 'Année',
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: _annees
                  .map((a) => DropdownMenuItem(
                        value: a,
                        child: Text(a.toString(),
                            style: const TextStyle(fontSize: 12)),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() => _anneeSelectionnee = v);
                _appliquerFiltre();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── EN-TÊTE ──────────────────────────────────────────────
  Widget _buildEnTete() {
    return Container(
      color: Colors.indigo,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          _celluleHeader('Code', flex: 2),
          _celluleHeader('Compte', flex: 4, alignLeft: true),
          _celluleHeader('Débit', flex: 3),
          _celluleHeader('Crédit', flex: 3),
          _celluleHeader('S.Débit', flex: 3),
          _celluleHeader('S.Crédit', flex: 3),
        ],
      ),
    );
  }

  // ─── LIGNE ────────────────────────────────────────────────
  Widget _buildLigne(BalanceItem item, int index) {
    final couleur = index.isEven ? Colors.white : Colors.grey.shade100;
    return Container(
      color: couleur,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Row(
        children: [
          _celluleTexte(item.compteCode, flex: 2),
          _celluleTexte(item.compteNom, flex: 4, alignLeft: true),
          _celluleMontant(item.totalDebit, flex: 3),
          _celluleMontant(item.totalCredit, flex: 3),
          _celluleMontant(item.soldeDebit,
              flex: 3, couleur: Colors.blue.shade700),
          _celluleMontant(item.soldeCredit,
              flex: 3, couleur: Colors.orange.shade700),
        ],
      ),
    );
  }

  // ─── TOTAUX ───────────────────────────────────────────────
  Widget _buildTotaux(List<BalanceItem> items) {
    double totD = 0, totC = 0, totSD = 0, totSC = 0;
    for (final i in items) {
      totD += i.totalDebit;
      totC += i.totalCredit;
      totSD += i.soldeDebit;
      totSC += i.soldeCredit;
    }
    return Container(
      color: Colors.indigo.shade800,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 4,
            child: Text('TOTAUX',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11)),
          ),
          _celluleTotalMontant(totD, flex: 3),
          _celluleTotalMontant(totC, flex: 3),
          _celluleTotalMontant(totSD, flex: 3, couleur: Colors.lightBlueAccent),
          _celluleTotalMontant(totSC, flex: 3, couleur: Colors.orangeAccent),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────
  Widget _celluleHeader(String texte, {int flex = 1, bool alignLeft = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        texte,
        textAlign: alignLeft ? TextAlign.left : TextAlign.right,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _celluleTexte(String texte, {int flex = 1, bool alignLeft = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        texte,
        textAlign: alignLeft ? TextAlign.left : TextAlign.right,
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _celluleMontant(double montant, {int flex = 1, Color? couleur}) {
    return Expanded(
      flex: flex,
      child: Text(
        montant == 0 ? '—' : formatMontant.format(montant),
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 11, color: couleur ?? Colors.black87),
      ),
    );
  }

  Widget _celluleTotalMontant(double montant, {int flex = 1, Color? couleur}) {
    return Expanded(
      flex: flex,
      child: Text(
        montant == 0 ? '—' : formatMontant.format(montant),
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: couleur ?? Colors.white,
        ),
      ),
    );
  }
}
