import 'package:get/get.dart';
import 'package:xln2026/screens/auth/controller/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
