import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xln2026/screens/auth/controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  /// ✅ Use Get.find (controller already put elsewhere)
  final LoginController controller = Get.find<LoginController>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            './images/dcdl.png',
                            height: screenHeight * 0.2,
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          const Text(
                            "Welcome Back!",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Text(
                            "Log in to continue",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          /// USERNAME
                          TextFormField(
                            controller: usernameController,
                            validator: (v) =>
                                v!.isEmpty ? "Enter User ID" : null,
                            decoration: InputDecoration(
                              labelText: 'User ID',
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF457B9D),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          /// PASSWORD
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (v) =>
                                v!.isEmpty ? "Enter Password" : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
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

                          /// LOGIN BUTTON
                          Obx(
                            () => GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await controller
                                            .postLoginApi(
                                              userName: usernameController.text
                                                  .trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            );

                                        log("LOGIN RESULT: $success");

                                        if (success) {
                                          Get.offNamed('/otp');
                                        }
                                      }
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
                                          'Log In',
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
            ),

            /// FOOTER
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

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xlninspection2026/screens/auth/controller/login_controller.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();

//   /// ✅ FIND controller (DO NOT PUT)
//   final LoginController controller = Get.find<LoginController>();

//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: usernameController,
//                 validator: (v) => v!.isEmpty ? "Enter username" : null,
//                 decoration: const InputDecoration(labelText: "Username"),
//               ),
//               const SizedBox(height: 10),
//               TextFormField(
//                 controller: passwordController,
//                 obscureText: true,
//                 validator: (v) => v!.isEmpty ? "Enter password" : null,
//                 decoration: const InputDecoration(labelText: "Password"),
//               ),
//               const SizedBox(height: 20),
//               Obx(
//                 () => ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () async {
//                           if (_formKey.currentState!.validate()) {
//                             bool success = await controller.postLoginApi(
//                               userName: usernameController.text.trim(),
//                               password: passwordController.text.trim(),
//                             );

//                             log("LOGIN RESULT: $success");

//                             if (success) {
//                               /// 🔥 REMOVE LOGIN FROM STACK
//                               Get.offNamed('/otp');
//                             }
//                           }
//                         },
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator()
//                       : const Text("LOGIN"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
