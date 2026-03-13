import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:xln2026/models/createinspection.dart';
import 'package:xln2026/screens/App_url/appurl.dart';

class InspectionController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hideLicenseButtons = false.obs;

  RxMap<String, dynamic> firm = <String, dynamic>{}.obs;

  Rx<CreateInspection?> inspection = Rx<CreateInspection?>(null);
  RxBool inspectionCreated = false.obs;

  RxString message = ''.obs;
  RxString errorMessage = ''.obs;

  final GetStorage box = GetStorage();

  // ======================================================
  // SEARCH FIRM
  // ======================================================
  void resetInspectionState() {
    inspection.value = null;
    inspectionCreated.value = false;
    message.value = '';
  }

  void clearFirmData() {
    firm.clear();
    resetInspectionState();
    errorMessage.value = '';
  }

  Future<void> searchFirm(String firmId) async {
    resetInspectionState();
    if (firmId.length != 5) {
      errorMessage.value = "Firm number must be 5 digits";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    firm.clear();

    final circleCode = box.read('circle') ?? '';

    try {
      final response = await http.post(
        Uri.parse(AppUrls.getfirmdetailsApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"FirmId": firmId, "Circlecode": circleCode}),
      );

      final data = jsonDecode(response.body);

      if (data.containsKey('Message')) {
        errorMessage.value = data['Message'];
        return;
      }

      /// ================= SUCCESS =================
      firm.value = data;

      // ⭐⭐⭐ VERY IMPORTANT FOR PDF ⭐⭐⭐
      box.write('firm_data', data);

      // old keys (keep)
      box.write('firm_id', data['Firm_Id']);
      box.write('circle_code', circleCode);

      final licList = data['Lic_list'] ?? [];
      if (licList.isNotEmpty) {
        box.write('license_type', licList.first);
      }

      log("✅ firm_data stored: ${box.read('firm_data')}");
    } catch (e) {
      log("Error: $e");
      errorMessage.value = "Something went wrong";
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  ///***************************_CREATE_Inspection_ID_***********************************/
  ///
  Future<void> createInspection(String licenseType) async {
    isLoading.value = true;
    inspectionCreated.value = false;
    message.value = '';
    hideLicenseButtons.value = false; // reset

    final firmId = box.read('firm_id');
    final circleCode = box.read('circle_code');

    if (firmId == null || circleCode == null) {
      message.value = "Required data missing";
      isLoading.value = false;
      return;
    }

    final body = {
      "FirmId": firmId.toString(),
      "Circlecode": circleCode.toString(),
      "LicenseType": licenseType,
    };

    log("➡️ CREATE INSPECTION REQUEST: $body");

    try {
      final response = await http.post(
        Uri.parse(AppUrls.createinspectionApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      log("⬅️ CREATE INSPECTION RESPONSE: ${response.body}");

      final json = jsonDecode(response.body);
      if (json['Message'] == "Inspection Already Updated or Expired") {
        message.value = json['Message'];
        hideLicenseButtons.value = true;
        inspectionCreated.value = true;
        return;
      }
      final result = CreateInspection.fromJson(json);

      inspection.value = result;
      message.value = result.message ?? '';
      inspectionCreated.value = true;

      box.write('inspection_id', result.inspectionId);
    } catch (e) {
      log("❌ Create Inspection Error: $e");
      message.value = "Something went wrong";
    } finally {
      isLoading.value = false;
    }
  }
}
// import 'dart:convert';
// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:xln2026/models/createinspection.dart';
// import 'package:xln2026/screens/App_url/appurl.dart';

// class InspectionController extends GetxController {
//   RxBool isLoading = false.obs;
//   RxBool hideLicenseButtons = false.obs;

//   RxMap<String, dynamic> firm = <String, dynamic>{}.obs;

//   Rx<CreateInspection?> inspection = Rx<CreateInspection?>(null);
//   RxBool inspectionCreated = false.obs;

//   RxString message = ''.obs;
//   RxString errorMessage = ''.obs;

//   final GetStorage box = GetStorage();

//   // ======================================================
//   // SEARCH FIRM
//   // ======================================================
//   void resetInspectionState() {
//     inspection.value = null;
//     inspectionCreated.value = false;
//     message.value = '';
//   }

//   void clearFirmData() {
//     firm.clear();
//     resetInspectionState();
//     errorMessage.value = '';
//   }

//   Future<void> searchFirm(String firmId) async {
//     resetInspectionState();
//     if (firmId.length != 5) {
//       errorMessage.value = "Firm number must be 5 digits";
//       return;
//     }

//     isLoading.value = true;
//     errorMessage.value = '';
//     firm.clear();

//     final circleCode = box.read('circle') ?? '';

//     try {
//       final response = await http.post(
//         Uri.parse(AppUrls.getfirmdetailsApi),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({"FirmId": firmId, "Circlecode": circleCode}),
//       );

//       final data = jsonDecode(response.body);

//       if (data.containsKey('Message')) {
//         errorMessage.value = data['Message'];
//         return;
//       }

//       /// ================= SUCCESS =================
//       firm.value = data;

//       // ⭐⭐⭐ VERY IMPORTANT FOR PDF ⭐⭐⭐
//       box.write('firm_data', data);

//       // old keys (keep)
//       box.write('firm_id', data['Firm_Id']);
//       box.write('circle_code', circleCode);

//       final licList = data['Lic_list'] ?? [];
//       if (licList.isNotEmpty) {
//         box.write('license_type', licList.first);
//       }

//       log("✅ firm_data stored: ${box.read('firm_data')}");
//     } catch (e) {
//       log("Error: $e");
//       errorMessage.value = "Something went wrong";
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ======================================================
//   ///***************************_CREATE_Inspection_ID_***********************************/
//   ///
//   Future<void> createInspection(String licenseType) async {
//     isLoading.value = true;
//     inspectionCreated.value = false;
//     message.value = '';
//     hideLicenseButtons.value = false;

//     final firmId = box.read('firm_id');
//     final circleCode = box.read('circle_code');

//     if (firmId == null || circleCode == null) {
//       message.value = "Required data missing";
//       isLoading.value = false;
//       return;
//     }

//     final body = {
//       "FirmId": firmId.toString(),
//       "Circlecode": circleCode.toString(),
//       "LicenseType": licenseType,
//     };

//     log("➡️ CREATE INSPECTION REQUEST: $body");

//     try {
//       final response = await http.post(
//         Uri.parse(AppUrls.createinspectionApi),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(body),
//       );

//       log("⬅️ CREATE INSPECTION RESPONSE: ${response.body}");

//       final json = jsonDecode(response.body);

//       /// 🔥 ALWAYS PARSE OBJECT (IMPORTANT)
//       inspection.value = CreateInspection.fromJson(json);
//       message.value = json['Message'] ?? '';
//       inspectionCreated.value = true;

//       /// store id
//       if (inspection.value?.inspectionId != null) {
//         box.write('inspection_id', inspection.value!.inspectionId);
//       }

//       /// hide buttons only for this message
//       if (message.value.contains("pending") ||
//           message.value.contains("Updated") ||
//           message.value.contains("Expired")) {
//         hideLicenseButtons.value = true;
//       }
//     } catch (e) {
//       log("❌ Create Inspection Error: $e");
//       message.value = "Something went wrong";
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
