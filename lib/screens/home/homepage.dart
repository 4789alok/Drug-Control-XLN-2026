import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xln2026/screens/utils/login_store.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final MyPref pref = MyPref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Drugs Control Department',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffF08000),
                fontFamily: "Times New Roman",
              ),
            ),
            SizedBox(height: 3),
            Text(
              '( Government of Karnataka )',
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Times New Roman",
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Color.fromARGB(255, 203, 23, 10),
            ),
            onPressed: () {
              Get.dialog(
                WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEEFBC7),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF08000),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEEFBC7),
                        ),
                        onPressed: () => pref.logout(),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xffF08000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      /// ---------------- BODY ----------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    /// ---------- USER INFO CARD ----------
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          _RowCard(
                            title: "UserID",
                            value: pref.empCode.isNotEmpty
                                ? pref.empCode
                                : "--",
                          ),
                          SizedBox(height: 8),
                          _RowCard(
                            title: "Name",
                            value: pref.name.isNotEmpty ? pref.name : "--",
                          ),
                          SizedBox(height: 8),
                          _RowCard(
                            title: "Designation",
                            value: pref.designation.isNotEmpty
                                ? pref.designation
                                : "--",
                          ),
                          SizedBox(height: 8),
                          _RowCard(
                            title: "Circle",
                            value: pref.circle.isNotEmpty ? pref.circle : "--",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// ---------- ACTION CARDS ----------
                    // _ActionCard(
                    //   title: "Profile Account",
                    //   image: Icons.account_circle,
                    //   onTap: () => Get.toNamed(''),
                    // ),
                    const SizedBox(height: 10),
                    _ActionCard(
                      title: "Random Inspection",
                      image: Icons.assignment,
                      onTap: () => Get.toNamed('/inspection'),
                    ),
                    const SizedBox(height: 10),
                    _ActionCard(
                      title: "Routien Inspection",
                      image: Icons.history,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),

                    _ActionCard(
                      title: "Reports Details",
                      image: Icons.picture_as_pdf,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ---------- FOOTER ----------
          Container(
            height: 50,
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Powered by NIC, Karnataka"),
                SizedBox(width: 3),
                Image(image: AssetImage("./images/nic.png"), width: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= REUSABLE ROW CARD =================
class _RowCard extends StatelessWidget {
  final String title;
  final String value;

  const _RowCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Times New Roman",
          ),
        ),
        Text(value, style: const TextStyle(fontFamily: "Times New Roman")),
      ],
    );
  }
}

/// ================= ACTION CARD =================
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData image;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(image, size: 60, color: Colors.blueGrey),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
