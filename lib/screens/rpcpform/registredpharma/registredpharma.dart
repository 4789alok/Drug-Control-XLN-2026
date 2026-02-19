import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Registrationpharmacistform extends StatefulWidget {
  const Registrationpharmacistform({super.key});

  @override
  State<Registrationpharmacistform> createState() =>
      _RegistrationpharmacistformState();
}

class _RegistrationpharmacistformState
    extends State<Registrationpharmacistform> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final regNoController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();

  // Dropdown values
  String? gender;
  String? status;

  // Date values
  DateTime? dateOfJoining;

  // Qualification Checkboxes (using GetX observables)
  var bPharm = false.obs;
  var mPharm = false.obs;
  var experienced = false.obs;
  var qualified = false.obs;
  var phd = false.obs;
  var dPharm = false.obs;

  @override
  void dispose() {
    regNoController.dispose();
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfJoining ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dateOfJoining) {
      setState(() {
        dateOfJoining = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Pharmacist Form"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Registered Pharmacist Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              // REG NO
              TextFormField(
                controller: regNoController,
                decoration: const InputDecoration(
                  labelText: 'REG. No',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // RP/CP/Dir Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'RP/CP/Dir Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Address
              TextFormField(
                controller: addressController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Date of Joining
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Joining',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    dateOfJoining == null
                        ? 'Select Date'
                        : "${dateOfJoining!.day}-${dateOfJoining!.month}-${dateOfJoining!.year}",
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'others', child: Text('Others')),
                ],
                onChanged: (value) => setState(() => gender = value),
              ),
              const SizedBox(height: 10),

              // Mobile Number
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // Status Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: status,
                items: const [
                  DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                ],
                onChanged: (value) => setState(() => status = value),
              ),
              const SizedBox(height: 20),

              // Qualification Section
              const Text(
                "Qualification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _checkbox("B.Pharm", bPharm),
                    _checkbox("M.Pharm", mPharm),
                    _checkbox("Experienced", experienced),
                    _checkbox("Qualified", qualified),
                    _checkbox("Ph.D", phd),
                    _checkbox("D.Pharm", dPharm),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.snackbar(
                        "Form Submitted",
                        "Your data has been successfully recorded!",
                        backgroundColor: Colors.green.shade200,
                        colorText: Colors.black,
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkbox(String title, RxBool val) {
    return Row(
      children: [
        Obx(
          () => Checkbox(
            activeColor: Colors.teal,
            value: val.value,
            onChanged: (bool? newval) => val.value = newval ?? false,
          ),
        ),
        Text(title, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 10),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gsform/gs_form/model/data_model/date_data_model.dart';
// import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
// import 'package:gsform/gs_form/widget/field.dart';
// import 'package:gsform/gs_form/widget/form.dart';
// import 'package:gsform/gs_form/widget/section.dart';

// class Registrationpharmacistform extends StatefulWidget {
//   const Registrationpharmacistform({super.key});

//   @override
//   State<Registrationpharmacistform> createState() =>
//       _RegistrationpharmacistformState();
// }

// class _RegistrationpharmacistformState
//     extends State<Registrationpharmacistform> {
//   late GSForm registrationpharmacistform;
//   // RegistredPharmacistcontroller registredPharmacistcontroller =
//   //     Get.put(RegistredPharmacistcontroller());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         // Removed Expanded and adjusted layout
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: registrationpharmacistform = GSForm.multiSection(
//             context,
//             sections: [
//               GSSection(
//                 sectionTitle: "Registered Pharmacist",
//                 fields: [
//                   GSField.text(
//                     value: '',
//                     tag: 'regno',
//                     title: 'REG. No',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.text(
//                     value: '',
//                     tag: 'regno',
//                     title: 'RP/CP/Dir Name',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.textPlain(
//                     hint: 'sds',
//                     tag: 'address',
//                     title: 'Address',
//                     maxLine: 4,
//                     maxLength: 233,
//                     showCounter: false,
//                     weight: 12,
//                     prefixWidget: const Icon(
//                       Icons.location_city,
//                       color: Colors.blue,
//                     ),
//                     required: true,
//                   ),
//                   GSField.datePicker(
//                     calendarType: GSCalendarType.gregorian,
//                     tag: 'doj',
//                     title: 'Date of Joining',
//                     weight: 6,
//                     required: false,
//                     initialDate: GSDate(day: 10, month: 5, year: 2023),
//                     errorMessage: 'please enter a valid date',
//                   ),
//                   GSField.spinner(
//                     tag: 'customer_type',
//                     required: false,
//                     weight: 6,
//                     title: 'Gender',
//                     value: SpinnerDataModel(name: 'female', id: 2),
//                     onChange: (model) {},
//                     items: [
//                       SpinnerDataModel(name: 'male', id: 1),
//                       SpinnerDataModel(name: 'female', id: 2),
//                       SpinnerDataModel(name: 'others', id: 3),
//                     ],
//                   ),
//                   GSField.text(
//                     value: '',
//                     tag: 'mobileno',
//                     title: 'Mobile Number',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.spinner(
//                     tag: 'status',
//                     required: false,
//                     weight: 6,
//                     title: 'Status',
//                     value: SpinnerDataModel(name: 'female', id: 2),
//                     onChange: (model) {},
//                     items: [
//                       SpinnerDataModel(name: 'Employee', id: 1),
//                       SpinnerDataModel(name: 'female', id: 2),
//                       SpinnerDataModel(name: 'others', id: 3),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   const Text(
//                     "Qualification",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11.5,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.all(2.0),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Column(
//                         children: [
//                           SizedBox(height: 5),
//                           // Row(
//                           //   children: [
//                           //     Padding(
//                           //       padding: const EdgeInsets.all(10.0),
//                           //       child: Row(
//                           //         children: [
//                           //           _checkbox(
//                           //             "B.Pharm",
//                           //             registredPharmacistcontroller.bpharm,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "Experienced",
//                           //             registredPharmacistcontroller.experienced,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "M.Pharm",
//                           //             registredPharmacistcontroller.mpharm,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "Qualified",
//                           //             registredPharmacistcontroller.qualified,
//                           //           ),
//                           //           _checkbox(
//                           //             "Ph.D",
//                           //             registredPharmacistcontroller.phd,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "Racks",
//                           //             registredPharmacistcontroller.dpharm,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _checkbox(String title, RxBool val) {
//   return Row(
//     children: [
//       Obx(
//         () => Checkbox(
//           activeColor: const Color.fromARGB(255, 11, 54, 90),
//           value: val.value,
//           onChanged: (bool? newval) {
//             val.value = newval ?? false;
//           },
//         ),
//       ),
//       Text(
//         title,
//         style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
//       ),
//     ],
//   );
// }
