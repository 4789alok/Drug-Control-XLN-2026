import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:xln2026/data/pdf/pdf_service.dart';
import 'package:xln2026/screens/utils/getlocation/getlocation.dart';

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

  String latitude = "";
  String longitude = "";
  String dateTime = "";

  bool isLoading = true;

  late final List<Map<String, String>> inspectionData =
      List<Map<String, String>>.from(Get.arguments['inspectionData']);

  // ======================================================
  // INIT
  // ======================================================
  @override
  void initState() {
    super.initState();

    firmData = Map<String, dynamic>.from(box.read('firm_data') ?? {});
    firmId = box.read('firm_id')?.toString() ?? "NA";

    fetchLocationAndGeneratePdf();
  }

  // ======================================================
  // FETCH LOCATION + GENERATE PDF
  // ======================================================
  Future<void> fetchLocationAndGeneratePdf() async {
    try {
      final position = await LatLong().getCurrentLocation();

      latitude = position.latitude.toStringAsFixed(6);
      longitude = position.longitude.toStringAsFixed(6);

      final now = DateTime.now();
      dateTime =
          "${now.day.toString().padLeft(2, '0')}-"
          "${now.month.toString().padLeft(2, '0')}-"
          "${now.year} "
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";
    } catch (e) {
      latitude = "Permission Denied";
      longitude = "Permission Denied";
      dateTime = DateTime.now().toString();
    }

    await generatePreviewPdf();

    setState(() {
      isLoading = false;
    });
  }

  // ======================================================
  // GENERATE PREVIEW PDF
  // ======================================================
  Future<void> generatePreviewPdf() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = "${tempDir.path}/preview.pdf";
    final file = File(filePath);

    final bytes = await PdfService.generatePdf(
      inspectionData: inspectionData,
      firmData: firmData,
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
    );

    await file.writeAsBytes(bytes);

    setState(() {
      path = filePath;
    });
  }

  // ======================================================
  // SAVE PDF
  // ======================================================
  Future<void> savePdf() async {
    try {
      final bytes = await PdfService.generatePdf(
        inspectionData: inspectionData,
        firmData: firmData,
        latitude: latitude,
        longitude: longitude,
        dateTime: dateTime,
      );

      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (directory == null) {
        Get.snackbar(
          "Error",
          "Storage directory not found",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final now = DateTime.now();
      final formattedTime =
          "${now.year}${_two(now.month)}${_two(now.day)}_"
          "${_two(now.hour)}${_two(now.minute)}${_two(now.second)}";

      final fileName = "Inspection_${firmId}_$formattedTime.pdf";
      final file = File("${directory.path}/$fileName");

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
          onPressed: () async {
            final result = await OpenFilex.open(file.path);

            if (result.type != ResultType.done) {
              Get.snackbar(
                "Error",
                "Unable to open file",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
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

  String _two(int n) => n.toString().padLeft(2, '0');

  // ======================================================
  // UI
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : path == null
          ? const Center(child: Text("PDF failed to load"))
          : PDFView(filePath: path),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: isLoading ? null : savePdf,
          child: const Text("Save PDF"),
        ),
      ),
    );
  }
}
