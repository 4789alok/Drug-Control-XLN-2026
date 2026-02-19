import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyPref {
  final GetStorage box = GetStorage();

  // ---------- SAVE ----------
  void saveUserData({
    required String name,
    required String role,
    required String empCode,
    required String circle,
    required String designation,
    required String mobile,
  }) {
    box.write('isLoggedIn', true);
    box.write('name', name);
    box.write('role', role);
    box.write('empCode', empCode);
    box.write('circle', circle);
    box.write('designation', designation);
    box.write('mobile', mobile);
  }

  // ---------- GETTERS (THIS IS REQUIRED) ----------
  String get name => box.read('name') ?? '';
  String get role => box.read('role') ?? '';
  String get empCode => box.read('empCode') ?? '';
  String get circle => box.read('circle') ?? '';
  String get designation => box.read('designation') ?? '';
  String get mobile => box.read('mobile') ?? '';

  // ---------- LOGIN CHECK ----------
  bool isLoggedIn() => box.read('isLoggedIn') == true;

  // ---------- LOGOUT ----------
  void logout() {
    box.erase();
    Get.offAllNamed('/login');
  }
}

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class MyPref {
//   final GetStorage box = GetStorage();

//   /// 🔐 Save user after OTP success
//   void saveUserData({
//     required String name,
//     required String role,
//     required String empCode,
//     required String circle,
//     required String designation,
//     required String mobile,
//   }) {
//     box.write('isLoggedIn', true);

//     box.write('name', name);
//     box.write('role', role);
//     box.write('empCode', empCode);
//     box.write('circle', circle);
//     box.write('designation', designation);
//     box.write('mobile', mobile);
//   }

//   /// ✅ Check login state
//   bool isLoggedIn() {
//     return box.read('isLoggedIn') == true;
//   }

//   /// 🚪 Logout
//   void logout() {
//     box.erase();
//     Get.offAllNamed('/login');
//   }
// }
