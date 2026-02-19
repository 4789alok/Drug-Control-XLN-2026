import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xln2026/screens/auth/controller/login_controller.dart';
 
class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final LoginController controller = Get.find<LoginController>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      body: SafeArea(
        child: Column(  
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          './images/dcdl.png',
                          height: screenHeight * 0.2,
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        const Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        const Text(
                          "Enter the 6-digit OTP sent to you",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        /// OTP FIELD
                        TextField(
                          controller: otpController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: "OTP",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF457B9D),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        /// VERIFY BUTTON
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : () {
                                    if (otpController.text.length != 6) {
                                      Get.snackbar(
                                        "Invalid OTP",
                                        "Please enter 6-digit OTP",
                                        backgroundColor: Colors.red.shade400,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                    controller.verifyOtp(
                                      otpController.text.trim(),
                                    );
                                  },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1D3557),
                                    Color(0xFFE63946),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Verify OTP',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// FOOTER (Same as Login)
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Powered by NIC, Karnataka",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('./images/nic.png', width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xlninspection2026/screens/auth/controller/login_controller.dart';

// class OtpPage extends StatelessWidget {
//   OtpPage({super.key});

//   final LoginController controller = Get.find<LoginController>();
//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("OTP Verification")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: otpController,
//               maxLength: 6,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter OTP",
//                 counterText: "",
//               ),
//             ),
//             const SizedBox(height: 20),
//             Obx(
//               () => ElevatedButton(
//                 onPressed: controller.isLoading.value
//                     ? null
//                     : () => controller.verifyOtp(otpController.text),
//                 child: controller.isLoading.value
//                     ? const CircularProgressIndicator()
//                     : const Text("VERIFY OTP"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
