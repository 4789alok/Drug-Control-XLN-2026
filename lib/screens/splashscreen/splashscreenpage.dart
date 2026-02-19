import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:xln2026/screens/utils/login_store.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final MyPref pref = MyPref();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (pref.isLoggedIn()) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('./images/dcdl.png', width: screenWidth * 0.6),
      ),
    );
  }
}
