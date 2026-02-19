import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xln2026/pdf/pdf_preview_page.dart';
import 'package:xln2026/screens/Random_inspection/firm_inspection/firm_inspectionpage.dart';
import 'package:xln2026/screens/Random_inspection/firm_inspection/inspection_binding/inspection_binding.dart';
import 'package:xln2026/screens/Random_inspection/wholesale_question/wholesale_quespage.dart';
import 'package:xln2026/screens/auth/otpbinding/otpbinding.dart';
import 'package:xln2026/screens/auth/view/loginpage.dart';
import 'package:xln2026/screens/auth/view/otppage.dart';
import 'package:xln2026/screens/home/homepage.dart';
import 'package:xln2026/screens/splashscreen/splashscreenpage.dart';
import 'package:xln2026/services/navigationservices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreenPage()),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
          binding: AuthBinding(),
        ),

        GetPage(name: '/otp', page: () => OtpPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(
          name: '/inspection',
          page: () => InspectionPage(),
          binding: InspectionBinding(),
        ),
        GetPage(name: '/wholesale', page: () => WholesaleQuespage()),
        GetPage(name: '/pdfpreview', page: () => PdfPreviewPage()),
      ],
    );
  }
}
