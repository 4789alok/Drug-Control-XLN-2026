import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xln2026/screens/App_url/appurl.dart';
import 'package:xln2026/screens/utils/login_store.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  /// ---------------- LOGIN API ----------------
  ///
  Future<bool> postLoginApi({
    required String userName,
    required String password,
  }) async {
    bool isSuccess = false;
    isLoading(true);

    final url = Uri.parse(AppUrls.requestotpApi);
    final body = {"username": userName, "password": password};

    log("➡️ LOGIN REQUEST: $body");

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      log("⬅️ LOGIN RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Message'] == 'Success') {
          isSuccess = true;
        } else {
          Get.snackbar('Login Failed', data['Message']);
        }
      }
    } catch (e) {
      log("❌ LOGIN ERROR: $e");
      Get.snackbar('Error', 'Server not responding');
    } finally {
      isLoading(false);
    }

    return isSuccess;
  }

  /// ---------------- VERIFY OTP ----------------
  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      Get.snackbar("Error", "Enter 6 digit OTP");
      return;
    }

    isLoading(true);

    try {
      final response = await http.post(
        Uri.parse(AppUrls.drugloginApi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": "899",
          "password": "Abcd@123",
          "loginotp": otp,
        }),
      );

      log("⬅️ OTP RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        /// 🔥 SAVE LOGIN STATE
        MyPref().saveUserData(
          name: data['Name'] ?? '',
          role: data['Role'] ?? '',
          empCode: data['Empcode'] ?? '',
          circle: data['Circle'] ?? '',
          designation: data['Designation'] ?? '',
          mobile: data['Mobile'] ?? '',
        );

        Get.snackbar("Success", "Welcome ${data['Name']}");

        /// 🔥 CLEAR LOGIN + OTP AND GO HOME
        Get.offAllNamed('/home');
      } else {
        Get.snackbar("Error", "Invalid OTP");
      }
    } catch (e) {
      log("❌ OTP ERROR: $e");
      Get.snackbar("Error", "OTP verification failed");
    } finally {
      isLoading(false);
    }
  }
}
