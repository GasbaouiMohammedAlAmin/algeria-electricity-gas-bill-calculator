// pdFService.dart
import 'package:gas_electric_invoice/models/BillData';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFService {
  static Future<void> generateBillPDF(BillData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(10),
              ),
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                children: [
                  pw.Text(
                    'FACTURE D\'ÉLECTRICITÉ ET DE GAZ',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),

            // Input Data Section
            _buildPDFSection(
              'DONNÉES D\'ENTRÉE',
              [
                ['Région', data.selectedRegion == 'north' ? 'Nord' : 'Sud'],
                ['', ''],
                ['ÉLECTRICITÉ', ''],
                ['Dernier indice électricité', data.lastIndex],
                ['Indice actuel électricité', data.currentIndex],
                ['Redevances Fixes HT', '${data.redevanceFix} DA'],
                ['Droit Fixe sur consommation', '${data.droitFix} DA'],
                ['Taxe d\'habitation', '${data.taxHabitation} DA'],
                ['Timbre', '${data.timbre} DA'],
                ['', ''],
                ['GAZ', ''],
                ['Dernier indice gaz', data.lastIndexGaz],
                ['Indice actuel gaz', data.currentIndexGaz],
              ],
            ),

            pw.SizedBox(height: 30),

            // Results Section
            _buildPDFSection(
              'RÉSULTATS DE CALCUL',
              [
                ['ÉLECTRICITÉ', ''],
                ['Consommation', '${data.consommationE.toStringAsFixed(2)} kWh'],
                ['Montant HT (9%)', '${data.t1ElectrityHT.toStringAsFixed(2)} DA'],
                ['Montant HT (19%)', '${data.t2ElectrityHT.toStringAsFixed(2)} DA'],
                ['Montant HT Total Électricité', '${data.priceE.toStringAsFixed(2)} DA'],
                ['', ''],
                ['GAZ', ''],
                ['Consommation', '${data.consommationG.toStringAsFixed(2)} Th'],
                ['Montant HT (9%)', '${data.t1GazHT.toStringAsFixed(2)} DA'],
                ['Montant HT (19%)', '${data.t2GazHT.toStringAsFixed(2)} DA'],
                ['Montant HT Total Gaz', '${data.priceG.toStringAsFixed(2)} DA'],
                ['', ''],
                ['RÉCAPITULATIF', ''],
                ['Contribution', '${data.contribution.toStringAsFixed(2)} DA'],
              ],
            ),

            pw.SizedBox(height: 20),

            // Total Section
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                border: pw.Border.all(color: PdfColors.green300, width: 2),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              padding: const pw.EdgeInsets.all(20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL À PAYER',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.Text(
                    '${data.totalPrice.toStringAsFixed(2)} DA',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 40),

            // Footer
            pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Document généré automatiquement par l\'application de calcul des factures d\'électricité et de gaz en Algérie.',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildPDFSection(String title, List<List<String>> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
          },
          children: data.map((row) {
            bool isHeader = row[0].toUpperCase() == row[0] && row[1].isEmpty;
            bool isEmpty = row[0].isEmpty && row[1].isEmpty;
            
            if (isEmpty) {
              return pw.TableRow(
                children: [
                  pw.Container(height: 10),
                  pw.Container(height: 10),
                ],
              );
            }
            
            return pw.TableRow(
              decoration: isHeader
                  ? pw.BoxDecoration(color: PdfColors.blue50)
                  : null,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    row[0],
                    style: pw.TextStyle(
                      fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
                      fontSize: isHeader ? 12 : 10,
                      color: isHeader ? PdfColors.blue800 : PdfColors.black,
                    ),
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    row[1],
                    style: pw.TextStyle(
                      fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
                      fontSize: isHeader ? 12 : 10,
                      color: isHeader ? PdfColors.blue800 : PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}