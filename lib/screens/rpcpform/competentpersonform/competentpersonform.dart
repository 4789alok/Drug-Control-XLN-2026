import 'package:flutter/material.dart';

class CompetentPersonForm extends StatefulWidget {
  const CompetentPersonForm({super.key});

  @override
  State<CompetentPersonForm> createState() => _CompetentPersonFormState();
}

class _CompetentPersonFormState extends State<CompetentPersonForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController dirNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // Dropdowns
  String? selectedGender;
  String? selectedStatus;

  // Date
  DateTime? selectedDate;

  // Qualification checkboxes
  Map<String, bool> qualifications = {
    "B.Com": false,
    "B.Sc": false,
    "M.Com": false,
    "M.Sc": false,
    "Post Graduate": false,
    "B.A": false,
    "Graduate": false,
    "M.A": false,
    "Others": false,
    "SSC": false,
  };

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2023, 5, 10),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Collect all data here and send to API if needed
      print('Form Saved Successfully');
      print('Reg No: ${regNoController.text}');
      print('Dir Name: ${dirNameController.text}');
      print('Address: ${addressController.text}');
      print('Mobile: ${mobileController.text}');
      print('Gender: $selectedGender');
      print('Status: $selectedStatus');
      print('Date of Joining: ${selectedDate?.toIso8601String()}');
      print(
        'Qualifications: ${qualifications.entries.where((e) => e.value).map((e) => e.key).join(", ")}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Competent Person Form"),
        backgroundColor: const Color.fromARGB(255, 11, 54, 90),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Competent Person",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: regNoController,
                decoration: const InputDecoration(
                  labelText: 'REG NO',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter Reg No' : null,
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: dirNameController,
                decoration: const InputDecoration(
                  labelText: 'RP/CP/Dir Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city, color: Colors.blue),
                ),
                validator: (value) => value!.isEmpty ? 'Enter Address' : null,
              ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _pickDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date of Joining',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                      hintText: selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (value) => setState(() => selectedGender = value),
                validator: (value) => value == null ? 'Select Gender' : null,
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Mobile Number' : null,
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (value) => setState(() => selectedStatus = value),
                validator: (value) => value == null ? 'Select Status' : null,
              ),

              const SizedBox(height: 20),
              const Text(
                "Qualification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: qualifications.keys.map((key) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: qualifications[key],
                          onChanged: (bool? value) {
                            setState(
                              () => qualifications[key] = value ?? false,
                            );
                          },
                        ),
                        Text(key, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 11, 54, 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

// class Competentpersonform extends StatefulWidget {
//   const Competentpersonform({super.key});

//   @override
//   State<Competentpersonform> createState() => _CompetentpersonformState();
// }

// class _CompetentpersonformState extends State<Competentpersonform> {
//   late GSForm competentpersonform;
//   // Competentpersoncontroller competentpersoncontroller =
//   //     Get.put(Competentpersoncontroller());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         // Removed Expanded and adjusted layout
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: competentpersonform = GSForm.multiSection(
//             context,
//             sections: [
//               GSSection(
//                 sectionTitle: "Competent Person ",
//                 fields: [
//                   GSField.text(
//                     value: '',
//                     tag: 'regno',
//                     title: 'REG NO',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.text(
//                     value: '',
//                     tag: 'dirname',
//                     title: 'RP/CP/Dir Name',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.textPlain(
//                     hint: 'address',
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
//                   const Text(
//                     "Qualification",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11.5,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Column(
//                         children: [
//                           const SizedBox(height: 5),
//                           // Row(
//                           //   children: [
//                           //     Padding(
//                           //       padding: const EdgeInsets.all(10.0),
//                           //       child: Row(
//                           //         children: [
//                           //           _checkbox(
//                           //             "B. Com",
//                           //             competentpersoncontroller.bcom,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "BSC",
//                           //             competentpersoncontroller.bsc,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "M.Com",
//                           //             competentpersoncontroller.mcom,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "MSC",
//                           //             competentpersoncontroller.msc,
//                           //           ),
//                           //           _checkbox(
//                           //             "Posr Graduate",
//                           //             competentpersoncontroller.postgraduate,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //           _checkbox(
//                           //             "BA",
//                           //             competentpersoncontroller.ba,
//                           //           ),
//                           //           _checkbox(
//                           //             "Graduates",
//                           //             competentpersoncontroller.graduate,
//                           //           ),
//                           //           _checkbox(
//                           //             "MA",
//                           //             competentpersoncontroller.ma,
//                           //           ),
//                           //           _checkbox(
//                           //             "Others",
//                           //             competentpersoncontroller.others,
//                           //           ),
//                           //           _checkbox(
//                           //             "SSC",
//                           //             competentpersoncontroller.ssc,
//                           //           ),
//                           //           const SizedBox(width: 20),
//                           //         ],
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           const SizedBox(height: 10),
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
