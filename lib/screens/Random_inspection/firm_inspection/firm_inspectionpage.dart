import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:xln2026/screens/Random_inspection/firm_inspection/controller/firm_inspection_controller.dart';
import 'package:xln2026/screens/utils/login_store.dart';

class InspectionPage extends StatelessWidget {
  InspectionPage({super.key});
  final MyPref pref = MyPref();

  final InspectionController controller = Get.put(InspectionController());
  final InspectionController insp = Get.find<InspectionController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firm Inspection"), centerTitle: true),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            /// 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: searchController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: InputDecoration(
                  hintText: "Enter Firm Number",
                  prefixIcon: const Icon(Icons.search),
                  // ────────────────────────────────────────────────
                  //       🔥 Improved prominent arrow button
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors
                          .blueAccent, // You can change to: teal, indigo, deepPurple, deepOrange
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        final query = searchController.text.trim();
                        if (query.isNotEmpty && query.length == 5) {
                          controller.searchFirm(query);
                        }
                      },
                    ),
                  ),
                  // ────────────────────────────────────────────────
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),

                // Clear data when user deletes characters
                onChanged: (value) {
                  if (value.length < 5) {
                    controller.clearFirmData();
                  }
                },

                // Optional: Trigger search on "Enter" / "Done" key
                onSubmitted: (value) {
                  final query = value.trim();
                  if (query.isNotEmpty && query.length == 5) {
                    controller.searchFirm(query);
                  }
                },
              ),
            ),

            /// ---------- FIRM DETAILS / ERROR ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// ❌ ERROR MESSAGE
                if (controller.errorMessage.isNotEmpty) {
                  return Container(
                    // padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                /// 🟡 NO SEARCH YET
                if (controller.firm.isEmpty) {
                  return const Text(
                    "Search firm number to view details",
                    style: TextStyle(color: Colors.grey),
                  );
                }

                /// ✅ FIRM DETAILS
                final f = controller.firm;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     /// 🔵 PRIMARY BUTTON
                        //     Expanded(
                        //       child: SizedBox(
                        //         height: 48,
                        //         child: ElevatedButton(
                        //           onPressed: () {
                        //             // Primary action
                        //           },
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: const Color(
                        //               0xFF1565C0,
                        //             ), // Blue
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(12),
                        //             ),
                        //             elevation: 4,
                        //           ),
                        //           child: const Text(
                        //             "Retail",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),

                        //     const SizedBox(width: 12),

                        //     /// 🔴 SECONDARY BUTTON
                        //     Expanded(
                        //       child: SizedBox(
                        //         height: 48,
                        //         child: ElevatedButton(
                        //           onPressed: () {
                        //             final box = GetStorage();

                        //             final firmId = box.read('firm_id');
                        //             final circleCode = box.read('circle_code');
                        //             final licenseType = box.read(
                        //               'license_type',
                        //             );

                        //             /// 🔍 PRINT LOGS
                        //             log("🟢 OK BUTTON CLICKED");
                        //             log("📦 firm_id      : $firmId");
                        //             log("📦 circle_code  : $circleCode");
                        //             log("📦 license_type : $licenseType");
                        //             if (firmId == null ||
                        //                 circleCode == null ||
                        //                 licenseType == null) {
                        //               log("❌ Missing required data");
                        //               Get.snackbar(
                        //                 "Error",
                        //                 "Required data missing",
                        //               );
                        //               return;
                        //             }
                        //             log("🚀 Navigating to /wholesale");
                        //             Get.toNamed(
                        //               '/wholesale',
                        //               arguments: {
                        //                 "firmId": firmId,
                        //                 "circleCode": circleCode,
                        //                 "licenseType": licenseType,
                        //               },
                        //             );
                        //           },
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: const Color.fromARGB(
                        //               255,
                        //               26,
                        //               116,
                        //               45,
                        //             ), // Red
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(12),
                        //             ),
                        //             elevation: 4,
                        //           ),
                        //           child: const Text(
                        //             "Wholesale",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 15,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 30),
                        const Text(
                          "Firm Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),

                        _row("Firm ID", f['Firm_Id'] ?? ''),
                        _row("Firm Name", f['Firm_Name'] ?? ''),
                        _row("Firm Incharge", f['Firm_Incharge'] ?? ''),
                        _row("Applied For", f['Applied_For'] ?? ''),
                        _row("Shop & Building", f['ShopNo_building'] ?? ''),
                        _row("Area", f['Area'] ?? ''),
                        _row("Town", f['Town'] ?? ''),
                        _row("Pincode", f['Pincode'] ?? ''),
                        _row("Category", f['Firm_Category'] ?? ''),
                        _row(
                          "Cold Storage",
                          f['Cold_Storage'] == "T" ? "Yes" : "No",
                        ),
                        _row("Validity Upto", f['Validity_Upto'] ?? ''),
                        const Divider(),

                        Obx(() {
                          if (!insp.inspectionCreated.value ||
                              insp.inspection.value == null) {
                            return const SizedBox.shrink();
                          }

                          final data = insp.inspection.value!;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _RowCards(
                                  title: "Firm Name",
                                  value: data.firmName ?? "--",
                                ),
                                const SizedBox(height: 12),
                                _RowCards(
                                  title: "Applied For",
                                  value: data.firmApplFor ?? "--",
                                ),
                                const SizedBox(height: 12),

                                /// DATE + TIME MERGED ✅
                                _RowCards(
                                  title: "Inspection On",
                                  value:
                                      "${data.inspectionDate ?? ''}  ${data.inspectionTime ?? ''}",
                                ),
                                const SizedBox(height: 12),
                                _RowCards(
                                  title: "Status",
                                  value: data.inspectionStatus == "N"
                                      ? "Pending"
                                      : "Completed",
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            /// ---------- OTHER SECTIONS (STATIC FOR NOW) ----------
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //   child: LicenseDetailsCard(),
            // ),
            // const SizedBox(height: 10),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //   child: PharmacistListCard(),
            // ),
            // const SizedBox(height: 10),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 12),
            //   child: InspectionListCard(),
            // ),
            const SizedBox(height: 30),

            const SizedBox(height: 30),
          ],
        ),
      ),

      floatingActionButton: Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.firm.isNotEmpty
              ? FloatingActionButton.extended(
                  key: const ValueKey("fab"),
                  onPressed: () {
                    _showInspectionDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create New Inspection"),
                )
              : const SizedBox.shrink(),
        );
      }),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(title)),
          const Text(": "),
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}

class _RowCards extends StatelessWidget {
  final String title;
  final String value;

  const _RowCards({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120, // ⭐ fixed width = perfect alignment
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Times New Roman",
              fontSize: 14,
            ),
          ),
        ),
        const Text(":", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : "--",
            textAlign: TextAlign.right,
            style: const TextStyle(fontFamily: "Times New Roman", fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class InspectionPage extends StatelessWidget {
//   const InspectionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Firm Inspection"), centerTitle: true),
//       body: SingleChildScrollView(
//         child: Column(
//           children: const [
//             SizedBox(height: 8),

//             /// 🔍 SEARCH BAR (TOP CENTER)
//             Align(
//               alignment: Alignment.center,
//               child: SizedBox(width: 500, child: SimpleSearchBar()),
//             ),

//             SizedBox(height: 8),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: FirmDetailsCard(),
//             ),

//             SizedBox(height: 10),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: LicenseDetailsCard(),
//             ),

//             SizedBox(height: 10),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: PharmacistListCard(),
//             ),

//             SizedBox(height: 10),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: InspectionListCard(),
//             ),

//             SizedBox(height: 80),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           _showInspectionDialog(context);
//         },
//         icon: const Icon(Icons.add),
//         label: const Text("Create New Inspection"),
//       ),
//     );
//   }
// }

// /* ===================== SEARCH BAR ===================== */

// class SimpleSearchBar extends StatefulWidget {
//   const SimpleSearchBar({super.key});

//   @override
//   State<SimpleSearchBar> createState() => _SimpleSearchBarState();
// }

// class _SimpleSearchBarState extends State<SimpleSearchBar> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: TextField(
//         controller: _controller,
//         decoration: InputDecoration(
//           hintText: "Search Firm No / Name",
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon: _controller.text.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     _controller.clear();
//                     setState(() {});
//                   },
//                 )
//               : null,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         onChanged: (value) => setState(() {}),
//       ),
//     );
//   }
// }

// /* ===================== FIRM DETAILS (13 FIELDS) ===================== */

// class FirmDetailsCard extends StatelessWidget {
//   const FirmDetailsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Firm Details",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const Divider(),

//             _row("Firm ID", "FIRM123"),
//             _row("Firm Name", "ABC Pharma"),
//             _row("Firm Incharge", "Ramesh Kumar"),
//             _row("District / Taluk", "Bengaluru Urban"),
//             _row("Applied For", "Retail License"),
//             _row("Shop No & Building", "12/A, Main Road"),
//             _row("Constitution", "Proprietorship"),
//             _row("Area", "BTM Layout"),
//             _row("Town", "Bengaluru"),
//             _row("Pincode", "560076"),
//             _row("Category", "Retail"),
//             _row("Cold Storage", "Yes"),
//             _row("Validity Upto", "31-12-2026"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 4,
//             child: Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           const Text(": "),
//           Expanded(
//             flex: 6,
//             child: Text(value, style: const TextStyle(color: Colors.black54)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ===================== LICENSE DETAILS ===================== */

// class LicenseDetailsCard extends StatelessWidget {
//   const LicenseDetailsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ExpansionTile(
//         title: const Text(
//           "License Details",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: const [
//           ListTile(
//             title: Text("License No: LIC-001"),
//             subtitle: Text(
//               "Type: Retail\nIssued: 01-01-2023\nRenew: 01-01-2024\nValidity: 31-12-2026\nStatus: Active",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ===================== PHARMACIST LIST ===================== */

// class PharmacistListCard extends StatelessWidget {
//   const PharmacistListCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ExpansionTile(
//         title: const Text(
//           "List of Registered Pharmacists",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         children: const [
//           ListTile(
//             title: Text("License No: LIC-001"),
//             subtitle: Text(
//               "Type: Retail\nIssued: 01-01-2023\nRenew: 01-01-2024\nValidity: 31-12-2026\nStatus: Active",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ===================== INSPECTION LIST ===================== */

// class InspectionListCard extends StatelessWidget {
//   const InspectionListCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [
//           const ListTile(
//             title: Text(
//               "Inspection List",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             title: const Text("Inspection ID: INSP001"),
//             subtitle: const Text(
//               "Firm: ABC Pharma\nApplied For: Renewal\nDate: 10-12-2025\nTime: 11:30 AM\nStatus: Pending",
//             ),
//             trailing: ElevatedButton(
//               onPressed: () {},
//               child: const Text("View"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
////***************************************************************************************** */
///
void _showInspectionDialog(BuildContext context) {
  final InspectionController c = Get.find<InspectionController>();
  final GetStorage box = GetStorage();

  /// SAFE LICENSE READ
  final dynamic storedLicense = box.read('license_type');
  final List<String> licenses = storedLicense is List
      ? storedLicense.map((e) => e.toString()).toList()
      : storedLicense is String
      ? [storedLicense]
      : [];

  /// AUTO CREATE INSPECTION (ONCE)
  Future.microtask(() async {
    if (!c.isLoading.value && !c.inspectionCreated.value) {
      final String licenseType = licenses.isNotEmpty
          ? licenses.first
          : 'Retail';

      await c.createInspection(licenseType);
      if (Get.isDialogOpen ?? false) {
        Get.back(); // ⭐ ADD THIS
      }
    }
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Obx(() {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                height: 200,
                width: 200,
                child: Lottie.network(
                  "https://lottie.host/095ddc56-62e1-45c7-b059-a689fe785a9e/jnoGEwCOE7.json",
                ),
              ),

              if (c.isLoading.value) const CircularProgressIndicator(),
              if (!c.isLoading.value && c.message.isNotEmpty)
                Text(c.message.value, textAlign: TextAlign.center),
              if (c.inspection.value?.inspectionId != null)
                SizedBox(height: 10),
              if (c.inspection.value?.inspectionId != null) ...[
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Text(
                    "Inspection ID: ${c.inspection.value?.inspectionId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),

          actions: [
            if (c.hideLicenseButtons.value)
              const SizedBox.shrink()
            else
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: licenses.map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        type.toLowerCase() == 'wholesale'
                            ? '/wholesale'
                            : '/retail',
                        arguments: {
                          "firmId": box.read('firm_id'),
                          "circleCode": box.read('circle_code'),
                          "licenseType": type,
                        },
                      );
                    },
                    child: Text(type),
                  );
                }).toList(),
              ),
            TextButton(onPressed: () => Get.back(), child: const Text("Close")),
          ],
        );
      });
    },
  );
}

// void _showInspectionDialog(BuildContext context) {
//   final InspectionController c = Get.put(InspectionController());

//   showDialog(
//     context: context,
//     builder: (_) {
//       return Obx(() {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Lottie.network(
//                 "https://lottie.host/095ddc56-62e1-45c7-b059-a689fe785a9e/jnoGEwCOE7.json",
//                 height: 160,
//               ),

//               const SizedBox(height: 10),

//               /// MESSAGE
//               Text(
//                 c.message.value,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 12),

//               /// INSPECTION ID
//               if (c.inspection.value?.inspectionId != null)
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     children: [
//                       const Text("Inspection ID"),
//                       const SizedBox(height: 4),
//                       Text(
//                         c.inspection.value!.inspectionId!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => c.createInspection("Retail"),
//                   child: const Text("Retail"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final box = GetStorage();
//                     final firmId = box.read('firm_id');
//                     final circleCode = box.read('circle_code');
//                     final licenseType = box.read('license_type');

//                     log("🟢 WHOLESALE BUTTON CLICKED");
//                     log("📦 firm_id      : $firmId");
//                     log("📦 circle_code  : $circleCode");
//                     log("📦 license_type : $licenseType");

//                     if (firmId == null ||
//                         circleCode == null ||
//                         licenseType == null) {
//                       Get.snackbar("Error", "Required data missing");
//                       return;
//                     }
//                     Get.toNamed(
//                       '/wholesale',
//                       arguments: {
//                         "firmId": firmId,
//                         "circleCode": circleCode,
//                         "licenseType": licenseType,
//                       },
//                     );
//                   },
//                   child: const Text("Wholesale"),
//                 ),
//               ],
//             ),
//           ],
//         );
//       });
//     },
//   );
// }
