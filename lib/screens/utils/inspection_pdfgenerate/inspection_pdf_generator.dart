import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:xln2026/models/wholesale_questionpage.dart';
import 'package:xln2026/screens/Random_inspection/wholesale_question/wholesale_quespage.dart';

class InspectionPdfGenerator {
  static Future<File> generatePdf({
    required List<LicenseQuestion> questions,
    required Map<String, Answer?> answers,
    required Map<String, String> remarks,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (context) => [
          _buildHeader(),
          pw.SizedBox(height: 10),
          _buildTable(questions, answers, remarks),
        ],
      ),
    );

    // final directory = await getExternalStorageDirectory();
    final directory = await getApplicationDocumentsDirectory();

    final filePath = "${directory.path}/Wholesale_Inspection_Report.pdf";
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ================= HEADER =================

  static pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          "Drugs Control Department",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          "Wholesale Inspection Report",
          style: const pw.TextStyle(fontSize: 11),
        ),
        pw.Divider(),
      ],
    );
  }

  // ================= TABLE =================
  static pw.Widget _buildTable(
    List<LicenseQuestion> data,
    Map<String, Answer?> answers,
    Map<String, String> remarks,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(40),
        1: const pw.FlexColumnWidth(),
        2: const pw.FixedColumnWidth(60),
        3: const pw.FixedColumnWidth(120),
      },
      children: [
        _headerRow(),
        ...data.map(
          (q) => pw.TableRow(
            children: [
              _cell(q.qNo),
              _cell(q.question),
              _cell(answers[q.qNo]?.name.toUpperCase() ?? ""),
              _cell(remarks[q.qNo] ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  static pw.TableRow _headerRow() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        _cell("Q.No", bold: true),
        _cell("Inspection Question", bold: true),
        _cell("Answer", bold: true),
        _cell("Remarks", bold: true),
      ],
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
