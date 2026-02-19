import 'package:flutter/material.dart';

class ConstitutionForm extends StatefulWidget {
  const ConstitutionForm({super.key});

  @override
  State<ConstitutionForm> createState() => _ConstitutionFormState();
}

class _ConstitutionFormState extends State<ConstitutionForm> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController dirNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  // Dropdown selections
  String? selectedGender;
  String? selectedStatus;

  // Dates
  DateTime? joiningDate;
  DateTime? validityDate;

  // Function to pick a date
  Future<void> _pickDate(BuildContext context, bool isJoiningDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2023, 5, 10),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (isJoiningDate) {
          joiningDate = picked;
        } else {
          validityDate = picked;
        }
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Here you can collect and send the data to API or controller
      print('--- Form Submitted ---');
      print('Reg No: ${regNoController.text}');
      print('Dir Name: ${dirNameController.text}');
      print('Address: ${addressController.text}');
      print('Mobile: ${mobileController.text}');
      print('Qualification: ${qualificationController.text}');
      print('Gender: $selectedGender');
      print('Status: $selectedStatus');
      print('Date of Joining: $joiningDate');
      print('Validity Upto: $validityDate');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Constitution Details'),
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
                "Constitution Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // REG NO
              TextFormField(
                controller: regNoController,
                decoration: const InputDecoration(
                  labelText: 'REG NO',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter REG NO' : null,
              ),
              const SizedBox(height: 10),

              // RP/CP/Dir Name
              TextFormField(
                controller: dirNameController,
                decoration: const InputDecoration(
                  labelText: 'RP/CP/Dir Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Director Name' : null,
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
                validator: (value) => value!.isEmpty ? 'Enter Address' : null,
              ),
              const SizedBox(height: 10),

              // Date of Joining
              GestureDetector(
                onTap: () => _pickDate(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date of Joining',
                      hintText: joiningDate == null
                          ? 'Select Date'
                          : '${joiningDate!.day}/${joiningDate!.month}/${joiningDate!.year}',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Gender
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

              // Mobile Number
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

              // Qualification
              TextFormField(
                controller: qualificationController,
                decoration: const InputDecoration(
                  labelText: 'Qualification',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter Qualification' : null,
              ),
              const SizedBox(height: 10),

              // Date of Joining (again)
              GestureDetector(
                onTap: () => _pickDate(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date of Joining',
                      hintText: joiningDate == null
                          ? 'Select Date'
                          : '${joiningDate!.day}/${joiningDate!.month}/${joiningDate!.year}',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Validity Upto
              GestureDetector(
                onTap: () => _pickDate(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Validity Upto',
                      hintText: validityDate == null
                          ? 'Select Date'
                          : '${validityDate!.day}/${validityDate!.month}/${validityDate!.year}',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Status
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'Employee', child: Text('Employee')),
                  DropdownMenuItem(value: 'Data 2', child: Text('Data 2')),
                  DropdownMenuItem(value: 'Data 3', child: Text('Data 3')),
                ],
                onChanged: (value) => setState(() => selectedStatus = value),
                validator: (value) => value == null ? 'Select Status' : null,
              ),
              const SizedBox(height: 20),

              // Save Button
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
// import 'package:gsform/gs_form/model/data_model/date_data_model.dart';
// import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
// import 'package:gsform/gs_form/widget/field.dart';
// import 'package:gsform/gs_form/widget/form.dart';
// import 'package:gsform/gs_form/widget/section.dart';

// class Constitutionform extends StatefulWidget {
//   const Constitutionform({super.key});

//   @override
//   State<Constitutionform> createState() => _ConstitutionformState();
// }

// class _ConstitutionformState extends State<Constitutionform> {
//   late GSForm constitutionform;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: constitutionform = GSForm.multiSection(
//             context,
//             sections: [
//               GSSection(
//                 sectionTitle: "Constitution Details",
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
//                     tag: 'gender',
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
//                   GSField.text(
//                     value: '',
//                     tag: 'qualification',
//                     title: 'Qualification ',
//                     minLine: 1,
//                     maxLine: 1,
//                     weight: 6,
//                   ),
//                   GSField.datePicker(
//                     calendarType: GSCalendarType.gregorian,
//                     tag: 'doj',
//                     title: 'Date of Joining',
//                     weight: 6,
//                     required: true,
//                     initialDate: GSDate(day: 10, month: 5, year: 2023),
//                     errorMessage: 'please enter a valid date',
//                   ),
//                   GSField.datePicker(
//                     calendarType: GSCalendarType.gregorian,
//                     tag: 'validityupto',
//                     title: 'Validity Upto',
//                     weight: 6,
//                     required: false,
//                     initialDate: GSDate(day: 10, month: 5, year: 2023),
//                     errorMessage: 'please enter a valid date',
//                   ),
//                   GSField.spinner(
//                     tag: 'status',
//                     required: false,
//                     weight: 6,
//                     title: 'Status',
//                     value: SpinnerDataModel(name: 'Employee', id: 2),
//                     onChange: (model) {},
//                     items: [
//                       SpinnerDataModel(name: 'employee', id: 1),
//                       SpinnerDataModel(name: 'data 2', id: 2),
//                       SpinnerDataModel(name: 'data 3', id: 3),
//                     ],
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
