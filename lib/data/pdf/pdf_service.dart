import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<Uint8List> generatePdf({
    required List<Map<String, String>> inspectionData,
    required Map<String, dynamic> firmData,
  }) async {
    final pdf = pw.Document();

    /// ================= FONT =================
    ///
    final fontData = await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
    final pw.Font font = pw.Font.ttf(fontData);

    /// ================= LOGO =================
    ///
    final logoData = await rootBundle.load('images/karnataka.png');
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    /// ================= DYNAMIC VALUES =================
    ///
    final firmName = firmData['Firm_Name'] ?? '';
    final address = firmData['ShopNo_building'] ?? '';
    final area = firmData['Area'] ?? '';
    final town = firmData['Town'] ?? '';
    final pin = firmData['Pincode'] ?? '';
    final incharge = firmData['Firm_Incharge'] ?? '';
    final firmId = firmData['Firm_Id'] ?? '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(24, 20, 24, 30),

        /// ================= FOOTER =================
        ///
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(font: font, fontSize: 9),
          ),
        ),

        build: (context) => [
          /// ================= HEADER =================
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Image(logo, height: 45),
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Center(
                  child: pw.Text(
                    "Drugs Control Department",
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    "Bangalore Circle 1-ADC",
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          pw.Divider(),

          /// ================= FIRM SECTION =================
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// LEFT BOX
              pw.Expanded(
                flex: 3,
                child: _box(
                  font,
                  children: [
                    _bold("1. Firm Details:", font),
                    _t(firmName, font),
                    _t(address, font),
                    _t(area, font),
                    _t("City: $town  , Pin: $pin", font),
                    _t("Taluka: $town ,  District: $town", font),
                    _t("I/C Person: $incharge", font),
                  ],
                ),
              ),

              pw.SizedBox(width: 8),

              /// RIGHT BOX
              pw.Expanded(
                flex: 2,
                child: _box(
                  font,
                  shaded: true,
                  children: [
                    _bold("Firm No : $firmId", font),
                    _t("Inspection Type : Random Inspection", font),
                    _t(
                      "Inspection Date : ${DateTime.now().toString().split(' ')[0]}",
                      font,
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 6),

          _bold("2. Type / Catg / Con : FRM / R / PRO", font),
          _bold("3. Previous Licenses :", font),

          pw.SizedBox(height: 6),

          /// ================= CHECKLIST TABLE =================
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: const {
              0: pw.FixedColumnWidth(30),
              1: pw.FlexColumnWidth(6),
              2: pw.FixedColumnWidth(50),
              3: pw.FlexColumnWidth(4),
            },
            children: [
              _header(font),
              ...inspectionData.map((e) => _row(font, e)).toList(),
            ],
          ),

          pw.SizedBox(height: 20),

          /// ================= REMARKS =================
          _bold("Remarks :", font),
          pw.Container(
            height: 60,
            decoration: pw.BoxDecoration(border: pw.Border.all()),
          ),
          pw.SizedBox(height: 8),

          /// ================= ATTACHMENTS =================
          _bold("Attached Documents :", font),
          _t(
            "Application Form, Fees Challan, Forwarding Letter, ID Proofs, "
            "Plan Layout Copy, RP Registration Documents",
            font,
          ),
          pw.SizedBox(height: 30),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "(ONKARESHWARA B.B.A.C)",
              style: pw.TextStyle(font: font, fontSize: 10),
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  // ================= TABLE HEADER =================
  static pw.TableRow _header(pw.Font f) => pw.TableRow(
    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
    children: [
      _cell("Sl", f, true),
      _cell("Question", f, true),
      _cell("Ans", f, true),
      _cell("Rule", f, true),
    ],
  );

  // ================= TABLE ROW =================
  static pw.TableRow _row(pw.Font f, Map<String, String> e) => pw.TableRow(
    children: [
      _cell(e["qNo"] ?? "", f),
      _cell(e["question"] ?? "", f),
      _cell(e["answer"] ?? "", f),
      _cell(e["rule"] ?? "", f),
    ],
  );

  // ================= HELPERS =================
  static pw.Widget _box(
    pw.Font f, {
    required List<pw.Widget> children,
    bool shaded = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        color: shaded ? PdfColors.grey300 : null,
        border: pw.Border.all(),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static pw.Widget _t(String s, pw.Font f) =>
      pw.Text(s, style: pw.TextStyle(font: f, fontSize: 9));

  static pw.Widget _bold(String s, pw.Font f) => pw.Text(
    s,
    style: pw.TextStyle(font: f, fontSize: 9, fontWeight: pw.FontWeight.bold),
  );

  static pw.Widget _cell(String t, pw.Font f, [bool head = false]) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          t,
          style: pw.TextStyle(
            font: f,
            fontSize: 8.5,
            fontWeight: head ? pw.FontWeight.bold : null,
          ),
        ),
      );
}
