import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xln2026/models/wholesale_questionpage.dart';
import 'package:xln2026/screens/Random_inspection/wholesale_question/controller/wholesalecontroller.dart';

enum Answer { yes, no, na }

class WholesaleQuespage extends StatefulWidget {
  const WholesaleQuespage({super.key});

  @override
  State<WholesaleQuespage> createState() => _WholesaleQuespageState();
}

class _WholesaleQuespageState extends State<WholesaleQuespage> {
  final controller = Get.put(WholesaleQuestionController());
  final GetStorage box = GetStorage();
  final Map<String, Answer?> answers = {};
  final Map<String, TextEditingController> remarks = {};

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;

    controller.fetchChecklist(
      firmId: args['firmId'],
      circleCode: args['circleCode'],
      licenseType: args['licenseType'],
    );
  }

  @override
  void dispose() {
    for (final c in remarks.values) {
      c.dispose();
    }
    super.dispose();
  }

  // ================= VALIDATION =================
  //
  bool validateAllFields(List<LicenseQuestion> data) {
    for (final q in data.where((q) => shouldShowQuestion(q))) {
      if (answers[q.qNo] == null) {
        Get.snackbar(
          "Validation Error",
          "Please select Yes / No / NA for Question ${q.qNo}",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      final remarkText = remarks[q.qNo]?.text.trim() ?? "";
      if (remarkText.isEmpty) {
        Get.snackbar(
          "Validation Error",
          "Please enter remarks for Question ${q.qNo}",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return true;
  }

  // ================= PDF DATA =================

  List<Map<String, String>> buildFinalSubmissionData(
    List<LicenseQuestion> data,
  ) {
    return data
        .where((q) => shouldShowQuestion(q))
        .map(
          (q) => {
            "qNo": q.qNo,
            "question": q.question,
            "answer": answers[q.qNo]!.name.toUpperCase(),
            "remarks": remarks[q.qNo]!.text.trim(),
            "rule": remarks[q.qNo]!.text.trim(),
          },
        )
        .toList();
  }

  //
  // ================= DRAFT PAYLOAD =================
  List<Map<String, dynamic>> buildDraftPayload(List<LicenseQuestion> data) {
    final args = Get.arguments ?? {};
    // final inspectionId = args['inspectionId']?.toString() ?? "";
    // final inspectionId = "3853"; // 🔥 HARD CODE FOR TESTING
    final inspectionId = box.read('inspection_id')?.toString() ?? "";
    log("📦 Inspection ID: ${box.read('inspection_id')}");

    if (inspectionId.isEmpty) {
      throw Exception("Inspection ID missing");
    }

    return data
        .where((q) => shouldShowQuestion(q))
        .map(
          (q) => {
            "Inspec_id": inspectionId,
            "Inspec_type": args['licenseType'] ?? "Wholesale",
            "Inspec_qno": q.qNo,
            "Inspec_question": q.question,
            "Inspec_result": answers[q.qNo]?.name.toUpperCase() ?? "",
            "Inspec_remarks": remarks[q.qNo]?.text.trim() ?? "",
          },
        )
        .toList();
  }

  bool shouldShowQuestion(LicenseQuestion q) {
    if (!q.qNo.contains("(")) return true;
    final parentKey = q.qNo.split("(").first;
    return answers[parentKey] == Answer.yes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wholesale Inspection"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.grey.shade100),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: buildInspectionTable(controller.questions),
              ),
            ),
          ),
        );
      }),

      // ================= FOOTER =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            /// SAVE AS DRAFT (LOGIC ONLY)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final pdfData = buildFinalSubmissionData(
                        controller.questions,
                      );
                      final draftData = buildDraftPayload(controller.questions);
                      await controller.saveDraft(
                        qaDetails: draftData,
                        onSuccess: () {
                          Get.toNamed(
                            '/pdfpreview',
                            arguments: {"inspectionData": pdfData},
                          );
                        },
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Inspection ID not found. Please create inspection first.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save as Draft",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            /// FINAL SUBMISSION (UNCHANGED)
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!validateAllFields(controller.questions)) return;

                    final pdfData = buildFinalSubmissionData(
                      controller.questions,
                    );

                    final finalPayload = buildDraftPayload(
                      controller.questions,
                    );

                    await controller.saveFinal(
                      qaDetails: finalPayload,
                      onSuccess: () {
                        Get.toNamed(
                          '/pdfpreview',
                          arguments: {"inspectionData": pdfData},
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Final Submition",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TABLE =================
  Widget buildInspectionTable(List<LicenseQuestion> data) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 900),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: const {
          0: FixedColumnWidth(70),
          1: FixedColumnWidth(420),
          2: FixedColumnWidth(180),
          3: FixedColumnWidth(260),
        },
        children: [
          headerRow(),
          ...data
              .where((q) => shouldShowQuestion(q))
              .map((q) => questionRow(q)),
        ],
      ),
    );
  }

  TableRow headerRow() {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      children: const [
        _HeaderCell("Q No"),
        _HeaderCell("Inspection Question"),
        _HeaderCell("Yes / No / NA"),
        _HeaderCell("Remarks"),
      ],
    );
  }

  TableRow questionRow(LicenseQuestion q) {
    remarks.putIfAbsent(
      q.qNo,
      () => TextEditingController(text: q.remarks ?? ""),
    );

    final isChild = q.qNo.contains("(");

    return TableRow(
      decoration: BoxDecoration(
        color: isChild ? Colors.grey.shade100 : Colors.blue.shade50,
      ),
      children: [
        _TextCell(q.qNo, bold: !isChild),
        _TextCell(q.question, bold: !isChild),
        radioCell(q.qNo),
        remarkCell(q.qNo),
      ],
    );
  }

  Widget radioCell(String key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildRadio(key, Answer.yes, "Yes"),
        buildRadio(key, Answer.no, "No"),
        buildRadio(key, Answer.na, "NA"),
      ],
    );
  }

  Widget buildRadio(String key, Answer value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Answer>(
          value: value,
          groupValue: answers[key],
          onChanged: (val) {
            setState(() {
              answers[key] = val;
              if (val != Answer.yes) {
                answers.removeWhere((k, v) => k.startsWith("$key("));
              }
            });
          },
        ),
        Text(label),
      ],
    );
  }

  Widget remarkCell(String key) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: TextField(
        controller: remarks[key],
        maxLines: 2,
        decoration: const InputDecoration(hintText: "Enter remarks"),
      ),
    );
  }
}

// ================= CELLS =================

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _TextCell extends StatelessWidget {
  final String text;
  final bool bold;
  const _TextCell(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xlninspection2026/models/wholesale_questionpage.dart';
// import 'package:xlninspection2026/screens/Random_inspection/wholesale_question/controller/wholesalecontroller.dart';

// enum Answer { yes, no, na }

// class WholesaleQuespage extends StatefulWidget {
//   const WholesaleQuespage({super.key});

//   @override
//   State<WholesaleQuespage> createState() => _WholesaleQuespageState();
// }

// class _WholesaleQuespageState extends State<WholesaleQuespage> {
//   final controller = Get.put(WholesaleQuestionController());

//   final Map<String, Answer?> answers = {};
//   final Map<String, TextEditingController> remarks = {};

//   @override
//   void initState() {
//     super.initState();

//     final args = Get.arguments;
//     controller.fetchChecklist(
//       firmId: args['firmId'],
//       circleCode: args['circleCode'],
//       licenseType: args['licenseType'],
//     );
//   }

//   @override
//   void dispose() {
//     for (final c in remarks.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   // =========================================================
//   // 🔐 VALIDATION — ALL FIELDS MANDATORY
//   // =========================================================
//   bool validateAllFields(List<LicenseQuestion> data) {
//     for (final q in data.where((q) => shouldShowQuestion(q))) {
//       // Answer mandatory
//       if (answers[q.qNo] == null) {
//         Get.snackbar(
//           "Validation Error",
//           "Please select Yes / No / NA for Question ${q.qNo}",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return false;
//       }
//       // Remarks mandatory
//       final remarkText = remarks[q.qNo]?.text.trim() ?? "";
//       if (remarkText.isEmpty) {
//         Get.snackbar(
//           "Validation Error",
//           "Please enter remarks for Question ${q.qNo}",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return false;
//       }
//     }
//     return true;
//   }

//   // =========================================================
//   // 📦 FINAL DATA → PDF (RULE = REMARKS)
//   // =========================================================

//   List<Map<String, String>> buildFinalSubmissionData(
//     List<LicenseQuestion> data,
//   ) {
//     return data
//         .where((q) => shouldShowQuestion(q))
//         .map(
//           (q) => {
//             "qNo": q.qNo,
//             "question": q.question,
//             "answer": answers[q.qNo]!.name.toUpperCase(),
//             "remarks": remarks[q.qNo]!.text.trim(),
//             "rule": remarks[q.qNo]!.text.trim(), // rule == remarks
//           },
//         )
//         .toList();
//   }

//   // =========================================================
//   // 🔑 SHOW CHILD ONLY IF PARENT == YES
//   // =========================================================
//   bool shouldShowQuestion(LicenseQuestion q) {
//     if (!q.qNo.contains("(")) return true;
//     final parentKey = q.qNo.split("(").first;
//     return answers[parentKey] == Answer.yes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wholesale Inspection"),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.black, Colors.blue],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ),

//       // ================= BODY =================
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Scrollbar(
//           thumbVisibility: true,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: buildInspectionTable(controller.questions),
//               ),
//             ),
//           ),
//         );
//       }),

//       // ================= FOOTER =================
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             /// 🔵 SAVE DRAFT
//             Expanded(
//               child: SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     log("🟦 Save as Draft clicked");
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1565C0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Save as Draft",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: SizedBox(
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (!validateAllFields(controller.questions)) return;
//                     final finalData = buildFinalSubmissionData(
//                       controller.questions,
//                     );
//                     log("✅ FINAL SUBMISSION DATA");
//                     for (final row in finalData) {
//                       log(row.toString());
//                     }
//                     Get.toNamed(
//                       '/pdfpreview',
//                       arguments: {"inspectionData": finalData},
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD32F2F),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Final Submition",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= TABLE =================
//   Widget buildInspectionTable(List<LicenseQuestion> data) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(minWidth: 900),
//       child: Table(
//         border: TableBorder.all(color: Colors.black, width: 0.8),
//         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//         columnWidths: const {
//           0: FixedColumnWidth(70),
//           1: FixedColumnWidth(420),
//           2: FixedColumnWidth(180),
//           3: FixedColumnWidth(260),
//         },
//         children: [
//           headerRow(),
//           ...data
//               .where((q) => shouldShowQuestion(q))
//               .map((q) => questionRow(q)),
//         ],
//       ),
//     );
//   }

//   TableRow headerRow() {
//     return TableRow(
//       decoration: BoxDecoration(color: Colors.grey.shade300),
//       children: const [
//         _HeaderCell("Q No"),
//         _HeaderCell("Inspection Question"),
//         _HeaderCell("Yes / No / NA"),
//         _HeaderCell("Remarks"),
//       ],
//     );
//   }

//   TableRow questionRow(LicenseQuestion q) {
//     // Prefill remarks from API if available
//     remarks.putIfAbsent(
//       q.qNo,
//       () => TextEditingController(text: q.remarks ?? ""),
//     );

//     final isChild = q.qNo.contains("(");

//     return TableRow(
//       decoration: BoxDecoration(
//         color: isChild ? Colors.grey.shade100 : Colors.blue.shade50,
//       ),
//       children: [
//         _TextCell(q.qNo, bold: !isChild),
//         _TextCell(q.question, bold: !isChild),
//         radioCell(q.qNo),
//         remarkCell(q.qNo),
//       ],
//     );
//   }

//   // ================= RADIO =================
//   Widget radioCell(String key) {
//     return Padding(
//       padding: const EdgeInsets.all(6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           buildRadio(key, Answer.yes, "Yes"),
//           const SizedBox(width: 12),
//           buildRadio(key, Answer.no, "No"),
//           const SizedBox(width: 12),
//           buildRadio(key, Answer.na, "NA"),
//         ],
//       ),
//     );
//   }

//   Widget buildRadio(String key, Answer value, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Radio<Answer>(
//           value: value,
//           groupValue: answers[key],
//           visualDensity: VisualDensity.compact,
//           onChanged: (val) {
//             setState(() {
//               answers[key] = val;

//               // Remove child answers if parent != YES
//               if (val != Answer.yes) {
//                 answers.removeWhere((k, v) => k.startsWith("$key("));
//               }
//             });
//           },
//         ),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   // ================= REMARK =================
//   Widget remarkCell(String key) {
//     return Padding(
//       padding: const EdgeInsets.all(6),
//       child: TextField(
//         controller: remarks[key],
//         maxLines: 2,
//         decoration: InputDecoration(
//           hintText: "Enter remarks",
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//       ),
//     );
//   }
// }

// // ================= CELLS =================

// class _HeaderCell extends StatelessWidget {
//   final String text;
//   const _HeaderCell(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
// }

// class _TextCell extends StatelessWidget {
//   final String text;
//   final bool bold;
//   const _TextCell(this.text, {this.bold = false});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }

// ///**********************************_OLD_*************************************/
// // import 'dart:developer';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:xlninspection2026/models/wholesale_questionpage.dart';
// // import 'package:xlninspection2026/screens/Random_inspection/wholesale_question/controller/wholesalecontroller.dart';

// // enum Answer { yes, no, na }

// // class WholesaleQuespage extends StatefulWidget {
// //   const WholesaleQuespage({super.key});

// //   @override
// //   State<WholesaleQuespage> createState() => _WholesaleQuespageState();
// // }

// // class _WholesaleQuespageState extends State<WholesaleQuespage> {
// //   final controller = Get.put(WholesaleQuestionController());

// //   final Map<String, Answer?> answers = {};
// //   final Map<String, TextEditingController> remarks = {};

// //   @override
// //   void initState() {
// //     super.initState();

// //     final args = Get.arguments;

// //     controller.fetchChecklist(
// //       firmId: args['firmId'],
// //       circleCode: args['circleCode'],
// //       licenseType: args['licenseType'],
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     for (final c in remarks.values) {
// //       c.dispose();
// //     }
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Wholesale Inspection"),
// //         centerTitle: true,
// //         flexibleSpace: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Colors.black, Colors.blue],
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //             ),
// //           ),
// //         ),
// //       ),

// //       // ================= BODY =================
// //       body: Obx(() {
// //         if (controller.isLoading.value) {
// //           return const Center(child: CircularProgressIndicator());
// //         }

// //         return Scrollbar(
// //           thumbVisibility: true,
// //           child: SingleChildScrollView(
// //             scrollDirection: Axis.vertical,
// //             child: SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: buildInspectionTable(controller.questions),
// //               ),
// //             ),
// //           ),
// //         );
// //       }),

// //       // ================= SAVE =================
// //       bottomNavigationBar: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Row(
// //           children: [
// //             /// 🔵 RETAIL BUTTON
// //             Expanded(
// //               child: SizedBox(
// //                 height: 48,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // 👉 Retail action (add later if needed)
// //                     log("🟦 Retail button clicked");
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF1565C0), // Blue
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     elevation: 4,
// //                   ),
// //                   child: const Text(
// //                     "Save as Draft",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             const SizedBox(width: 12),

// //             /// 🔴 WHOLESALE → PDF PREVIEW
// //             Expanded(
// //               child: SizedBox(
// //                 height: 48,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     log("🔴 Wholesale → PDF Preview");

// //                     Get.toNamed('/pdfpreview');
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFFD32F2F), // Red
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     elevation: 4,
// //                   ),
// //                   child: const Text(
// //                     "Final Submition",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),

// //       // bottomNavigationBar: Padding(
// //       //   padding: const EdgeInsets.all(12),
// //       //   child: SizedBox(
// //       //     height: 48,
// //       //     child: ElevatedButton(
// //       //       onPressed: () {
// //       //         Get.toNamed('/pdfpreview');
// //       //       },
// //       //       style: ElevatedButton.styleFrom(
// //       //         backgroundColor: Colors.blue.shade900,
// //       //         shape: RoundedRectangleBorder(
// //       //           borderRadius: BorderRadius.circular(24),
// //       //         ),
// //       //       ),
// //       //       child: const Text(
// //       //         "Save Inspection",
// //       //         style: TextStyle(color: Colors.white, fontSize: 15),
// //       //       ),
// //       //     ),
// //       //   ),
// //       // ),
// //     );
// //   }

// //   // =========================================================
// //   // 🔑 CORE LOGIC — SHOW CHILD ONLY IF PARENT == YES
// //   // =========================================================
// //   bool shouldShowQuestion(LicenseQuestion q) {
// //     // Parent question → always visible
// //     if (!q.qNo.contains("(")) {
// //       return true;
// //     }

// //     // Child question → show only if parent is YES
// //     final parentKey = q.qNo.split("(").first;
// //     return answers[parentKey] == Answer.yes;
// //   }

// //   // ================= TABLE =================
// //   Widget buildInspectionTable(List<LicenseQuestion> data) {
// //     return ConstrainedBox(
// //       constraints: const BoxConstraints(minWidth: 900),
// //       child: Table(
// //         border: TableBorder.all(color: Colors.black, width: 0.8),
// //         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
// //         columnWidths: const {
// //           0: FixedColumnWidth(70),
// //           1: FixedColumnWidth(420),
// //           2: FixedColumnWidth(180),
// //           3: FixedColumnWidth(260),
// //         },
// //         children: [
// //           headerRow(),

// //           // 🔑 FILTER QUESTIONS HERE
// //           ...data
// //               .where((q) => shouldShowQuestion(q))
// //               .map((q) => questionRow(q)),
// //         ],
// //       ),
// //     );
// //   }

// //   TableRow headerRow() {
// //     return TableRow(
// //       decoration: BoxDecoration(color: Colors.grey.shade300),
// //       children: const [
// //         _HeaderCell("Q No"),
// //         _HeaderCell("Inspection Question"),
// //         _HeaderCell("Yes / No / NA"),
// //         _HeaderCell("Remarks"),
// //       ],
// //     );
// //   }

// //   TableRow questionRow(LicenseQuestion q) {
// //     remarks.putIfAbsent(q.qNo, () => TextEditingController(text: q.remarks));

// //     final isChild = q.qNo.contains("(");

// //     return TableRow(
// //       decoration: BoxDecoration(
// //         color: isChild ? Colors.grey.shade100 : Colors.blue.shade50,
// //       ),
// //       children: [
// //         _TextCell(q.qNo, bold: !isChild),
// //         _TextCell(q.question, bold: !isChild),
// //         radioCell(q.qNo),
// //         remarkCell(q.qNo),
// //       ],
// //     );
// //   }

// //   // ================= RADIO =================
// //   Widget radioCell(String key) {
// //     return Padding(
// //       padding: const EdgeInsets.all(6),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           buildRadio(key, Answer.yes, "Yes"),
// //           const SizedBox(width: 12),
// //           buildRadio(key, Answer.no, "No"),
// //           const SizedBox(width: 12),
// //           buildRadio(key, Answer.na, "NA"),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildRadio(String key, Answer value, String label) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Radio<Answer>(
// //           value: value,
// //           groupValue: answers[key],
// //           visualDensity: VisualDensity.compact,
// //           onChanged: (val) {
// //             setState(() {
// //               answers[key] = val;

// //               // 🔴 KEEP LOGIC SAME
// //               if (val != Answer.yes) {
// //                 answers.removeWhere((k, v) => k.startsWith("$key("));
// //               }
// //             });
// //           },
// //         ),
// //         Text(label, style: const TextStyle(fontSize: 12)),
// //       ],
// //     );
// //   }

// //   // ================= REMARK =================

// //   Widget remarkCell(String key) {
// //     return Padding(
// //       padding: const EdgeInsets.all(6),
// //       child: TextField(
// //         controller: remarks[key],
// //         maxLines: 2,
// //         decoration: InputDecoration(
// //           hintText: "Enter remarks",
// //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
// //         ),
// //       ),
// //     );
// //   }

// //   // ================= SAVE =================
// //   void saveInspection() {
// //     for (final key in answers.keys) {
// //       log("Q:$key | Ans:${answers[key]?.name} | Remark:${remarks[key]?.text}");
// //     }

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text("Inspection saved successfully")),
// //     );
// //   }
// // }

// // // ================= CELLS =================

// // class _HeaderCell extends StatelessWidget {
// //   final String text;
// //   const _HeaderCell(this.text);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(10),
// //       child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
// //     );
// //   }
// // }

// // class _TextCell extends StatelessWidget {
// //   final String text;
// //   final bool bold;
// //   const _TextCell(this.text, {this.bold = false});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(10),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           fontSize: 12,
// //           fontWeight: bold ? FontWeight.bold : FontWeight.normal,
// //         ),
// //       ),
// //     );
// //   }
// // }
