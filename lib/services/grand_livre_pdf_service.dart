import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:mayelab_project/db/app_database.dart';

class GrandLivrePdfService {
  static Future<void> exportAndPrint({
    required Compte compte,
    required List<GrandLivreLigne> lignes,
    String? periode,
  }) async {
    final pdf = pw.Document();

    int totalDebit = 0;
    int totalCredit = 0;
    int soldeCumule = 0;

    final rows = <_RowData>[];
    for (final gl in lignes) {
      totalDebit += gl.ligne.debit;
      totalCredit += gl.ligne.credit;
      soldeCumule += gl.ligne.debit - gl.ligne.credit;
      rows.add(_RowData(gl: gl, soldeCumule: soldeCumule));
    }

    const headerBg = PdfColor.fromInt(0xFF3F51B5);
    const totalBg = PdfColor.fromInt(0xFFE8EAF6);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16 * PdfPageFormat.mm),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Grand Livre',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Compte : ${compte.code} — ${compte.nom}'
              '${periode != null ? '  |  Période : $periode' : ''}',
              style: pw.TextStyle(
                fontSize: 9,
                color: PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 10),
          ],
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: [
              'Date',
              'Référence',
              'Libellé',
              'Débit',
              'Crédit',
              'Solde',
            ],
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
            headerDecoration: const pw.BoxDecoration(color: headerBg),
            headerHeight: 24,
            cellHeight: 20,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
            cellStyle: const pw.TextStyle(fontSize: 8),
            oddRowDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFF5F5F5),
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(22),
              1: const pw.FixedColumnWidth(30),
              2: const pw.FlexColumnWidth(),
              3: const pw.FixedColumnWidth(24),
              4: const pw.FixedColumnWidth(24),
              5: const pw.FixedColumnWidth(24),
            },
            data: rows.map((r) {
              final date = r.gl.ecriture.date;
              final dateStr = date != null
                  ? '${date.day.toString().padLeft(2, '0')}/'
                      '${date.month.toString().padLeft(2, '0')}/'
                      '${date.year}'
                  : '—';
              return [
                dateStr,
                r.gl.ecriture.reference ?? '—',
                r.gl.ecriture.libelle,
                r.gl.ligne.debit > 0
                    ? (r.gl.ligne.debit / 100).toStringAsFixed(2)
                    : '',
                r.gl.ligne.credit > 0
                    ? (r.gl.ligne.credit / 100).toStringAsFixed(2)
                    : '',
                (r.soldeCumule / 100).toStringAsFixed(2),
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            decoration: const pw.BoxDecoration(color: totalBg),
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                _totalChip(
                    'Total Débit', (totalDebit / 100).toStringAsFixed(2)),
                pw.SizedBox(width: 16),
                _totalChip(
                    'Total Crédit', (totalCredit / 100).toStringAsFixed(2)),
                pw.SizedBox(width: 16),
                _totalChip('Solde Net',
                    ((totalDebit - totalCredit) / 100).toStringAsFixed(2)),
              ],
            ),
          ),
        ],
      ),
    );

    // ── Sauvegarde locale au lieu de Printing.layoutPdf ──
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/grand_livre_${compte.code}.pdf');
    await file.writeAsBytes(bytes);

    debugPrint('✅ PDF sauvegardé: ${file.path}');

    await OpenFile.open(file.path);
  }

  static pw.Widget _totalChip(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: 9),
        children: [
          pw.TextSpan(
            text: '$label : ',
            style: const pw.TextStyle(color: PdfColors.grey700),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _RowData {
  final GrandLivreLigne gl;
  final int soldeCumule;
  _RowData({required this.gl, required this.soldeCumule});
}
