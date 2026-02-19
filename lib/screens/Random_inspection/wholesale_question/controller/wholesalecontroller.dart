import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xln2026/models/wholesale_questionpage.dart';
import 'package:xln2026/screens/App_url/appurl.dart';

class WholesaleQuestionController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<LicenseQuestion> questions = <LicenseQuestion>[].obs;

  // =========================================================
  // ================= FETCH CHECKLIST =======================
  // =========================================================
  Future<void> fetchChecklist({
    required String firmId,
    required String circleCode,
    required String licenseType,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(AppUrls.licenseChecklistApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "FirmId": firmId,
          "Circlecode": circleCode,
          "LicenseType": licenseType,
        }),
      );

      final List data = jsonDecode(response.body);
      questions.value = data.map((e) => LicenseQuestion.fromJson(e)).toList();
    } catch (e) {
      log("Checklist API Error: $e");
      Get.snackbar("Error", "Checklist loading failed");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // ================= SAVE DRAFT ============================
  // =========================================================
  Future<void> saveDraft({
    required List<Map<String, dynamic>> qaDetails,
    required VoidCallback onSuccess,
  }) async {
    await _saveToApi(
      url: AppUrls.licenseQADraftSaveApi,
      qaDetails: qaDetails,
      onSuccess: onSuccess,
    );
  }

  // =========================================================
  // ================= FINAL SUBMIT ==========================
  // =========================================================
  Future<void> saveFinal({
    required List<Map<String, dynamic>> qaDetails,
    required VoidCallback onSuccess,
  }) async {
    await _saveToApi(
      url: AppUrls.licenseQASaveApi,
      qaDetails: qaDetails,
      onSuccess: onSuccess,
    );
  }

  // =========================================================
  // ============== COMMON SAFE API METHOD ===================
  // =========================================================
  Future<void> _saveToApi({
    required String url,
    required List<Map<String, dynamic>> qaDetails,
    required VoidCallback onSuccess,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"qadetail": qaDetails}),
      );

      log("API Response => ${response.body}");
      String message = "Operation completed";

      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map) {
          message = decoded["Message"]?.toString() ?? message;
        } else if (decoded is String) {
          message = decoded;
        }
      } catch (_) {
        message = response.body.toString();
      }
      final bool isSuccess =
          response.statusCode == 200 &&
          !message.toLowerCase().contains("not") &&
          !message.toLowerCase().contains("fail") &&
          !message.toLowerCase().contains("error");

      Get.dialog(
        AlertDialog(
          title: Text(isSuccess ? "Success" : "Info"),
          content: Text(message),
          actions: [
            if (!isSuccess)
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog
                  Get.back(); // back page
                },
                child: const Text("Cancel"),
              ),

            TextButton(
              onPressed: () {
                Get.back();
                if (isSuccess) onSuccess();
              },
              child: const Text("OK"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      log("Save Error: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}

///
///*******************************_OLD_****************************************/
///
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:xln2026/models/wholesale_questionpage.dart';
// import 'package:xln2026/screens/App_url/appurl.dart';

// class WholesaleQuestionController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxList<LicenseQuestion> questions = <LicenseQuestion>[].obs;

//   Future<void> fetchChecklist({
//     required String firmId,
//     required String circleCode,
//     required String licenseType,
//   }) async {
//     isLoading.value = true;

//     try {
//       final response = await http.post(
//         Uri.parse(AppUrls.licenseChecklistApi),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "FirmId": firmId,
//           "Circlecode": circleCode,
//           "LicenseType": licenseType,
//         }),
//       );

//       final List data = jsonDecode(response.body);
//       questions.value = data.map((e) => LicenseQuestion.fromJson(e)).toList();
//     } catch (e) {
//       log("API Error: $e");
//       Get.snackbar("Error", "Checklist loading failed");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   ///
//   // ================= SAVE DRAFT =================
//   Future<void> saveDraft({
//     required List<Map<String, dynamic>> qaDetails,
//     required VoidCallback onSuccess,
//   }) async {
//     isLoading.value = true;

//     try {
//       final response = await http.post(
//         Uri.parse(AppUrls.licenseQADraftSaveApi),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"qadetail": qaDetails}),
//       );

//       log("Draft Save Response => ${response.body}");

//       if (response.statusCode == 200) {
//         Get.dialog(
//           Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: 60,
//                     ),
//                   ),

//                   const SizedBox(height: 16),
//                   const Text(
//                     "Success",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Inspection draft details saved successfully",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 15, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Get.back(),
//                           style: OutlinedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: const Text("Cancel"),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Get.back();
//                             onSuccess();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: const Text("OK"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           barrierDismissible: false,
//         );
//       } else {
//         Get.snackbar("Error", "Draft save failed");
//       }
//     } catch (e) {
//       log("Draft Error: $e");
//       Get.snackbar("Error", "Something went wrong");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
