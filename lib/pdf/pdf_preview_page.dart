import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:xln2026/data/pdf/pdf_service.dart';

class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({super.key});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  final box = GetStorage();

  late Map<String, dynamic> firmData;
  String firmId = "";
  String? path;

  /// receive inspection data
  late final List<Map<String, String>> inspectionData =
      List<Map<String, String>>.from(Get.arguments['inspectionData']);

  // ======================================================
  // INIT
  // ======================================================
  @override
  void initState() {
    super.initState();

    firmData = Map<String, dynamic>.from(box.read('firm_data') ?? {});

    /// firm id (saved earlier using box.write('firm_id', data['Firm_Id']))
    firmId = box.read('firm_id')?.toString() ?? "NA";
    generatePreviewPdf();
  }

  // ======================================================
  // SAFE STORAGE PATH (Android 11+ compatible)
  // ======================================================
  Future<String?> getDownloadPath() async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      return directory?.path;
    } else {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  // ======================================================
  // PREVIEW PDF
  // ======================================================
  Future<void> generatePreviewPdf() async {
    final tempDir = await getTemporaryDirectory();

    final filePath = "${tempDir.path}/preview.pdf";
    final file = File(filePath);

    final bytes = await PdfService.generatePdf(
      inspectionData: inspectionData,
      firmData: firmData,
    );

    await file.writeAsBytes(bytes);
    setState(() {
      path = filePath;
    });
  }

  // ======================================================
  // SAVE PDF WITH DATE + TIME + FIRM ID
  // ======================================================
  Future<void> savePdf() async {
    try {
      final bytes = await PdfService.generatePdf(
        inspectionData: inspectionData,
        firmData: firmData,
      );

      final dir = await getDownloadPath();
      final now = DateTime.now();
      final formattedTime =
          "${now.year}${_two(now.month)}${_two(now.day)}_${_two(now.hour)}${_two(now.minute)}${_two(now.second)}";
      final fileName = "Inspection_${firmId}_$formattedTime.pdf";

      final file = File("$dir/$fileName");

      await file.writeAsBytes(bytes, flush: true);
      Get.closeAllSnackbars();

      Get.snackbar(
        "PDF Saved",
        fileName,
        duration: const Duration(seconds: 10),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        mainButton: TextButton(
          onPressed: () => OpenFilex.open(file.path),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "OPEN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Save failed: $e",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // helper for 2 digit numbers
  String _two(int n) => n.toString().padLeft(2, '0');

  // ======================================================
  // UI
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),

      body: path == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: path),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: savePdf,
          child: const Text("Save PDF"),
        ),
      ),
    );
  }
}
