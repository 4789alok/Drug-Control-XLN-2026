// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../Random_inspection/controller/firm_inspectioncontroller.dart';
// import 'competentpersonform/competentpersonform.dart';
// import 'constitutionform/constitutionform.dart';
// import 'registredpharma/registredpharma.dart';

// class RPCPform extends StatefulWidget {
//   const RPCPform({super.key});

//   @override
//   State<RPCPform> createState() => _RPCPformState();
// }

// class _RPCPformState extends State<RPCPform> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for text fields
//   final nameController = TextEditingController(text: "Sree Pharmacy");
//   final contactController = TextEditingController(text: "Sree Kumar");
//   final shopController = TextEditingController(text: "Address 1");
//   final areaController = TextEditingController(text: "Address2");
//   final townController = TextEditingController(text: "tirunalveli");
//   final pincodeController = TextEditingController(text: "580010");
//   final phoneController = TextEditingController();
//   final phone2Controller = TextEditingController(text: "Some text");
//   final districtController = TextEditingController(text: "B11");

//   // Dropdown values
//   String? constitutionType;
//   String? categoryType;
//   String? talukaType;

//   // Date fields
//   DateTime? issueDate;
//   DateTime? renewalFrom;
//   DateTime? lastInspection;
//   DateTime? licenceExpireDate;

//   // Checkbox controllers
//   CheckboxController checkboxController = Get.put(CheckboxController());

//   // Radio selections
//   String? coldStorage = "No";
//   String? open24Hrs = "No";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(color: Colors.white),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.black, Colors.blue],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Drugs Control Department',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               '( Government of Karnataka )',
//               style: TextStyle(fontSize: 10, color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const Text(
//                   'RPCP',
//                   style: TextStyle(
//                     fontFamily: "Times New Roman",
//                     color: Color(0xffF08000),
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Divider(
//                   thickness: 1,
//                   color: Colors.black,
//                   indent: 70,
//                   endIndent: 70,
//                 ),
//                 const SizedBox(height: 10),

//                 // Firm details
//                 _buildTextField('Firm Name', nameController),
//                 _buildTextField('Prop/Contact', contactController),
//                 _buildTextField('Shop No. and Building', shopController),
//                 _buildTextField('Area', areaController),
//                 _buildTextField('Town', townController),
//                 _buildTextField(
//                   'Pincode',
//                   pincodeController,
//                   keyboard: TextInputType.number,
//                 ),

//                 // Dropdown fields
//                 _buildDropdown(
//                   title: 'Constitution',
//                   value: constitutionType,
//                   items: ['-select-', 'Proprietorship', 'Partnership', 'LLP'],
//                   onChanged: (val) => setState(() => constitutionType = val),
//                 ),
//                 _buildDropdown(
//                   title: 'Category',
//                   value: categoryType,
//                   items: ['-select-', 'Firm', 'Company', 'Distributor'],
//                   onChanged: (val) => setState(() => categoryType = val),
//                 ),
//                 _buildTextField(
//                   'Phone',
//                   phoneController,
//                   keyboard: TextInputType.phone,
//                 ),
//                 _buildTextField(
//                   'Phone No.',
//                   phone2Controller,
//                   keyboard: TextInputType.phone,
//                 ),
//                 _buildTextField('District', districtController),
//                 _buildDropdown(
//                   title: 'Taluka',
//                   value: talukaType,
//                   items: ['-select-', '560001', '560002', '560003'],
//                   onChanged: (val) => setState(() => talukaType = val),
//                 ),

//                 // Date Pickers
//                 _buildDateField(
//                   'LST Issue Date',
//                   issueDate,
//                   (date) => setState(() => issueDate = date),
//                 ),
//                 _buildDateField(
//                   'Renewal From',
//                   renewalFrom,
//                   (date) => setState(() => renewalFrom = date),
//                 ),
//                 _buildDateField(
//                   'Last Inspection',
//                   lastInspection,
//                   (date) => setState(() => lastInspection = date),
//                 ),
//                 _buildDateField(
//                   'Licence Expiry Date',
//                   licenceExpireDate,
//                   (date) => setState(() => licenceExpireDate = date),
//                 ),

//                 const SizedBox(height: 10),
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Applied For",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//                   ),
//                 ),
//                 _buildCheckboxRow(),

//                 // Radio Groups
//                 const SizedBox(height: 10),
//                 _buildRadioGroup(
//                   'Cold Storage',
//                   coldStorage,
//                   ['Yes', 'No'],
//                   (val) => setState(() => coldStorage = val),
//                 ),
//                 _buildRadioGroup('24 Hr Open', open24Hrs, [
//                   'Yes',
//                   'No',
//                 ], (val) => setState(() => open24Hrs = val)),

//                 const SizedBox(height: 20),
//                 // Tabs
//                 DefaultTabController(
//                   length: 3,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: const [
//                       TabBar(
//                         labelColor: Colors.black,
//                         indicatorColor: Colors.blue,
//                         tabs: [
//                           Tab(text: "Registered Pharmacist"),
//                           Tab(text: "Competent Person"),
//                           Tab(text: "Constitution Details"),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 600,
//                         child: TabBarView(
//                           children: [
//                             Registrationpharmacistform(),
//                             CompetentPersonForm(),
//                             ConstitutionForm(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: 150,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _onSubmit,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 11, 54, 90),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text('Submit'),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------- Helper Widgets ----------

//   Widget _buildTextField(
//     String title,
//     TextEditingController controller, {
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           labelText: title,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (val) =>
//             val == null || val.isEmpty ? 'Required field' : null,
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String title,
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           labelText: title,
//           border: const OutlineInputBorder(),
//         ),
//         value: value,
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: onChanged,
//         validator: (val) =>
//             val == null || val == '-select-' ? 'Please select' : null,
//       ),
//     );
//   }

//   Widget _buildDateField(
//     String title,
//     DateTime? selectedDate,
//     Function(DateTime) onDatePicked,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: InkWell(
//         onTap: () async {
//           final picked = await showDatePicker(
//             context: context,
//             initialDate: selectedDate ?? DateTime.now(),
//             firstDate: DateTime(1970),
//             lastDate: DateTime(2100),
//           );
//           if (picked != null) onDatePicked(picked);
//         },
//         child: InputDecorator(
//           decoration: InputDecoration(
//             labelText: title,
//             border: const OutlineInputBorder(),
//           ),
//           child: Text(
//             selectedDate == null
//                 ? 'Select Date'
//                 : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCheckboxRow() {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 5,
//       children: [
//         _checkbox("Aluminum Section", checkboxController.alumiumSection),
//         _checkbox("Drawers", checkboxController.drawers),
//         _checkbox("Pellets", checkboxController.pellets),
//         _checkbox("Wooden Furniture", checkboxController.woodenFurniture),
//         _checkbox("Glass Section", checkboxController.glassSection),
//         _checkbox("Racks", checkboxController.racks),
//         _checkbox("Any Other", checkboxController.anyOther),
//       ],
//     );
//   }

//   Widget _checkbox(String title, RxBool val) {
//     return Obx(
//       () => Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Checkbox(
//             value: val.value,
//             onChanged: (bool? newVal) => val.value = newVal ?? false,
//             activeColor: const Color.fromARGB(255, 11, 54, 90),
//           ),
//           Text(title, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _buildRadioGroup(
//     String title,
//     String? groupValue,
//     List<String> options,
//     ValueChanged<String?> onChanged,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//         ),
//         Row(
//           children: options
//               .map(
//                 (opt) => Row(
//                   children: [
//                     Radio<String>(
//                       value: opt,
//                       groupValue: groupValue,
//                       onChanged: onChanged,
//                       activeColor: Colors.blue,
//                     ),
//                     Text(opt),
//                   ],
//                 ),
//               )
//               .toList(),
//         ),
//       ],
//     );
//   }

//   void _onSubmit() {
//     if (_formKey.currentState!.validate()) {
//       Get.snackbar(
//         "Success",
//         "Form submitted successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green[100],
//       );
//       Get.toNamed('/firmform');
//     } else {
//       Get.snackbar(
//         "Error",
//         "Please fill all required fields",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red[100],
//       );
//     }
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:gsform/gs_form/model/data_model/date_data_model.dart';
// // import 'package:gsform/gs_form/model/data_model/radio_data_model.dart';
// // import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
// // import 'package:gsform/gs_form/widget/field.dart';
// // import 'package:gsform/gs_form/widget/form.dart';
// // import 'package:gsform/gs_form/widget/section.dart';
// // import '../inspectionentrypage/controller/inspectioncontroller.dart';
// // import 'competentpersonform/competentpersonform.dart';
// // import 'constitutionform/constitutionform.dart';
// // import 'registredpharma/registredpharma.dart';

// // class RPCPform extends StatefulWidget {
// //   const RPCPform({super.key});

// //   @override
// //   State<RPCPform> createState() => _MainformState();
// // }

// // class _MainformState extends State<RPCPform> {
// //   late GSForm form;
// //   late GSForm registrationForm;
// //   late GSForm competentPersonForm;
// //   late GSForm constitutionDetailsForm;
// //   int id = 0;
// //   CheckboxController checkboxController = Get.put(CheckboxController());
// //   Formsection2Controller formsection2controller = Get.put(
// //     Formsection2Controller(),
// //   );
// //   // RegistredPharmacistcontroller registredPharmacistcontroller =
// //   //     Get.put(RegistredPharmacistcontroller());

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: const BackButton(color: Colors.white),
// //         flexibleSpace: Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: <Color>[Colors.black, Colors.blue],
// //             ),
// //           ),
// //         ),
// //         title: const Row(
// //           children: [
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 Text(
// //                   'Drugs Control Department',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 SizedBox(height: 5),
// //                 Text(
// //                   '( Government of Karnataka )',
// //                   style: TextStyle(fontSize: 10.0, color: Colors.black),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //         elevation: 0.5,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 20),
// //             const Text(
// //               'RPCP',
// //               style: TextStyle(
// //                 fontFamily: "Times New Roman",
// //                 color: Color(0xffF08000),
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             const Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
// //               child: Divider(height: 1, color: Colors.black),
// //             ),
// //             const SizedBox(height: 10),
// //             // TabBar(
// //             //   isScrollable: true,
// //             //   labelColor: Colors.green.shade900,
// //             //   unselectedLabelColor: Colors.black,
// //             //   indicator: BoxDecoration(
// //             //     color: Colors.blue.shade100,
// //             //     borderRadius: BorderRadius.circular(15.0),
// //             //     border: Border.all(color: Colors.grey.shade700),
// //             //   ),
// //             //   tabs: const [
// //             //     Tab(text: "Connection Details"),
// //             //     Tab(text: "Bill Details"),
// //             //     Tab(text: "Other Details"),
// //             //     Tab(text: "sample Details"),
// //             //   ],
// //             // ),
// //             Expanded(
// //               child: SingleChildScrollView(
// //                 child: form = GSForm.multiSection(
// //                   context,
// //                   sections: [
// //                     GSSection(
// //                       sectionTitle: '',
// //                       fields: [
// //                         GSField.text(
// //                           value: 'Sree Pharmacy',
// //                           tag: 'nameofclinic',
// //                           title: 'Firm Name',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.text(
// //                           value: 'Sree Kumar',
// //                           tag: 'Prop/Contact',
// //                           title: 'Prop/Contact',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.text(
// //                           value: 'Address 1',
// //                           tag: 'shopno_building',
// //                           title: 'Shop No. and Building',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 12,
// //                         ),
// //                         GSField.text(
// //                           value: 'Address2',
// //                           tag: 'Address_2',
// //                           title: 'Area',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 12,
// //                         ),
// //                         GSField.text(
// //                           value: 'tirunalveli',
// //                           tag: 'Town',
// //                           title: 'Town',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.text(
// //                           value: '580010',
// //                           tag: 'name',
// //                           title: 'Pincode',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.spinner(
// //                           tag: 'constitution_type',
// //                           required: false,
// //                           weight: 6,
// //                           title: 'Constitution',
// //                           value: SpinnerDataModel(name: '', id: 2),
// //                           onChange: (model) {},
// //                           items: [
// //                             SpinnerDataModel(name: '-select-', id: 1),
// //                             SpinnerDataModel(name: 'Propritetorship', id: 2),
// //                             SpinnerDataModel(name: 'data 2', id: 2),
// //                             SpinnerDataModel(name: 'data 3', id: 1),
// //                           ],
// //                         ),
// //                         GSField.spinner(
// //                           tag: 'customer_type',
// //                           required: false,
// //                           weight: 6,
// //                           title: 'Category',
// //                           value: SpinnerDataModel(name: '', id: 2),
// //                           onChange: (model) {},
// //                           items: [
// //                             SpinnerDataModel(name: '-select-', id: 1),
// //                             SpinnerDataModel(name: 'Firm', id: 2),
// //                             SpinnerDataModel(name: 'data 2', id: 2),
// //                             SpinnerDataModel(name: 'data 3', id: 1),
// //                           ],
// //                         ),
// //                         GSField.text(
// //                           value: '',
// //                           tag: 'name',
// //                           title: 'Phone',
// //                           hint: 'Enter mobile no.',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.text(
// //                           value: 'Some text',
// //                           tag: 'Prop/Contact',
// //                           title: 'Phone No.',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.text(
// //                           value: 'B11',
// //                           tag: 'name',
// //                           title: 'District',
// //                           minLine: 1,
// //                           maxLine: 1,
// //                           weight: 6,
// //                         ),
// //                         GSField.spinner(
// //                           tag: 'customer_type',
// //                           required: false,
// //                           weight: 6,
// //                           title: 'Taluka',
// //                           value: SpinnerDataModel(name: '', id: 2),
// //                           onChange: (model) {},
// //                           items: [
// //                             SpinnerDataModel(name: '-select-', id: 1),
// //                             SpinnerDataModel(name: '560001', id: 2),
// //                             SpinnerDataModel(name: 'data 2', id: 2),
// //                             SpinnerDataModel(name: 'data 3', id: 1),
// //                           ],
// //                         ),
// //                         GSField.datePicker(
// //                           calendarType: GSCalendarType.gregorian,
// //                           tag: 'issuedata',
// //                           title: 'Lst Issue date',
// //                           weight: 6,
// //                           required: false,
// //                           initialDate: GSDate(day: 10, month: 5, year: 1970),
// //                           errorMessage: 'please enter valid date',
// //                         ),
// //                         GSField.datePicker(
// //                           calendarType: GSCalendarType.gregorian,
// //                           tag: 'renew_from',
// //                           title: 'Renewal From',
// //                           weight: 6,
// //                           required: false,
// //                           initialDate: GSDate(day: 10, month: 5, year: 1970),
// //                           errorMessage: 'please enter valid date',
// //                         ),
// //                         GSField.datePicker(
// //                           calendarType: GSCalendarType.gregorian,
// //                           tag: 'lastinspection',
// //                           title: 'last Inspection',
// //                           weight: 6,
// //                           required: false,
// //                           initialDate: GSDate(day: 10, month: 5, year: 1970),
// //                           errorMessage: 'please enter valid date',
// //                         ),
// //                         // GSField.radioGroup(
// //                         //   hint: 'Radio Group',
// //                         //   tag: 'radio',
// //                         //   showScrollBar: true,
// //                         //   scrollBarColor: Colors.red,
// //                         //   scrollDirection: Axis.horizontal,
// //                         //   height: 50,
// //                         //   scrollable: true,
// //                         //   required: true,
// //                         //   weight: 12,
// //                         //   title: 'Size number',
// //                         //   searchable: false,
// //                         //   searchHint: 'Search...',
// //                         //   searchIcon: const Icon(Icons.search),
// //                         //   searchBoxDecoration: BoxDecoration(
// //                         //     border: Border.all(
// //                         //       color: Colors.blue,
// //                         //       width: 1,
// //                         //     ),
// //                         //     borderRadius: BorderRadius.circular(8),
// //                         //   ),
// //                         //   items: [
// //                         //     RadioDataModel(title: 'lorem', isSelected: false),
// //                         //     RadioDataModel(title: 'ipsum', isSelected: false),
// //                         //   ],
// //                         //   callBack: (data) {},
// //                         // ),
// //                         GSField.datePicker(
// //                           calendarType: GSCalendarType.gregorian,
// //                           tag: 'licenceExpireDate',
// //                           title: 'DatePicker',
// //                           weight: 12,
// //                           required: false,
// //                           initialDate: GSDate(day: 10, month: 5, year: 2023),
// //                           errorMessage: 'please enter a valid date',
// //                         ),
// //                         const Text(
// //                           "Applied For",
// //                           style: TextStyle(
// //                             color: Colors.black,
// //                             fontWeight: FontWeight.w700,
// //                             fontSize: 12,
// //                           ),
// //                           textAlign: TextAlign.start,
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(2.0),
// //                           child: SingleChildScrollView(
// //                             scrollDirection: Axis.horizontal,
// //                             child: Column(
// //                               children: [
// //                                 const SizedBox(height: 5),
// //                                 Row(
// //                                   children: [
// //                                     Padding(
// //                                       padding: const EdgeInsets.all(10.0),
// //                                       child: Row(
// //                                         children: [
// //                                           _checkbox(
// //                                             "Aluminum Section",
// //                                             checkboxController.alumiumSection,
// //                                           ),
// //                                           const SizedBox(width: 20),
// //                                           _checkbox(
// //                                             "Drawers",
// //                                             checkboxController.drawers,
// //                                           ),
// //                                           const SizedBox(width: 20),
// //                                           _checkbox(
// //                                             "Pellets",
// //                                             checkboxController.pellets,
// //                                           ),
// //                                           const SizedBox(width: 20),
// //                                           _checkbox(
// //                                             "Wooden Furniture",
// //                                             checkboxController.woodenFurniture,
// //                                           ),
// //                                           _checkbox(
// //                                             "Glass Section",
// //                                             checkboxController.glassSection,
// //                                           ),
// //                                           const SizedBox(width: 20),
// //                                           _checkbox(
// //                                             "Racks",
// //                                             checkboxController.racks,
// //                                           ),
// //                                           const SizedBox(width: 20),
// //                                           _checkbox(
// //                                             "Any Other",
// //                                             checkboxController.anyOther,
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 const SizedBox(height: 10),
// //                               ],
// //                             ),
// //                           ),
// //                         ),

// //                         GSField.radioGroup(
// //                           hint: 'Radio Group',
// //                           tag: 'radio',

// //                           // showScrollBar: true,
// //                           // // scrollBarColor: Colors.red,
// //                           scrollDirection: Axis.horizontal,
// //                           height: 50,
// //                           scrollable: true,
// //                           required: true,
// //                           weight: 6,

// //                           title: 'Cold Storage',
// //                           searchable: false,
// //                           searchHint: 'Search...',
// //                           searchIcon: const Icon(Icons.search),
// //                           searchBoxDecoration: BoxDecoration(
// //                             border: Border.all(color: Colors.red, width: 1),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           items: [
// //                             RadioDataModel(title: 'Yes', isSelected: false),
// //                             RadioDataModel(title: 'No', isSelected: false),
// //                           ],
// //                           callBack: (data) {},
// //                         ),
// //                         GSField.radioGroup(
// //                           hint: 'Radio Group',
// //                           tag: 'radio',
// //                           // showScrollBar: true,
// //                           // scrollBarColor: Colors.red,
// //                           scrollDirection: Axis.horizontal,
// //                           height: 50,
// //                           scrollable: true,
// //                           required: true,
// //                           weight: 6,
// //                           title: '24 Hr Open',
// //                           searchable: false,
// //                           searchHint: 'Search...',
// //                           searchIcon: const Icon(Icons.search),
// //                           searchBoxDecoration: BoxDecoration(
// //                             border: Border.all(color: Colors.blue, width: 1),
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           items: [
// //                             RadioDataModel(title: 'Yes', isSelected: false),
// //                             RadioDataModel(title: 'No', isSelected: false),
// //                           ],
// //                           callBack: (data) {},
// //                         ),
// //                         const SizedBox(height: 10),
// //                         DefaultTabController(
// //                           length: 3,
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.stretch,
// //                             children: [
// //                               const TabBar(
// //                                 labelColor: Colors.black,
// //                                 indicatorColor: Colors.blue,
// //                                 tabs: [
// //                                   Tab(text: "Registered Pharmacist"),
// //                                   Tab(text: "Competent Person"),
// //                                   Tab(text: "Constitution Details"),
// //                                 ],
// //                               ),
// //                               SizedBox(
// //                                 height: 600,
// //                                 child: TabBarView(
// //                                   children: [
// //                                     Container(
// //                                       alignment: Alignment.center,
// //                                       child: const Registrationpharmacistform(),
// //                                     ),
// //                                     Container(
// //                                       alignment: Alignment.center,
// //                                       child: const Competentpersonform(),
// //                                     ),
// //                                     Container(
// //                                       alignment: Alignment.center,
// //                                       child: const Constitutionform(),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             SizedBox(
// //               width: 150,
// //               height: 50,
// //               child: ElevatedButton(
// //                 onPressed: () {
// //                   bool isValid = form.isValid();
// //                   Map<String, dynamic> map = form.onSubmit();
// //                   debugPrint(isValid.toString());
// //                   debugPrint(map.toString());
// //                   Get.toNamed('/firmform');
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   shape: const RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.all(Radius.circular(20)),
// //                   ),
// //                   backgroundColor: const Color.fromARGB(255, 11, 54, 90),
// //                 ),
// //                 child: const Text('Submit'),
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Widget _checkbox(String title, RxBool val) {
// //   return Column(
// //     children: [
// //       Obx(
// //         () => Checkbox(
// //           activeColor: const Color.fromARGB(255, 11, 54, 90),
// //           value: val.value,
// //           onChanged: (bool? newval) {
// //             val.value = newval ?? false;
// //           },
// //         ),
// //       ),
// //       Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
// //     ],
// //   );
// // }

// // Widget _buildHeaderCell(String text) {
// //   return Container(
// //     color: Colors.blueAccent,
// //     padding: const EdgeInsets.all(8.0),
// //     constraints: const BoxConstraints(minHeight: 35.0, minWidth: 100.0),
// //     alignment: Alignment.center,
// //     child: Center(
// //       child: Text(
// //         text,
// //         textAlign: TextAlign.center,
// //         style: const TextStyle(
// //           fontSize: 9.5,
// //           fontWeight: FontWeight.bold,
// //           fontFamily: "Times New Roman",
// //         ),
// //       ),
// //     ),
// //   );
// // }

// // Widget _buildDataCell(String title, RxBool val) {
// //   return Container(
// //     padding: const EdgeInsets.all(8.0),
// //     color: Colors.white,
// //     constraints: const BoxConstraints(minWidth: 35.0, minHeight: 30.0),
// //     alignment: Alignment.center,
// //     child: Row(
// //       children: [
// //         Text(
// //           title,
// //           style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
// //           textAlign: TextAlign.center,
// //         ),
// //         Obx(
// //           () => Checkbox(
// //             activeColor: const Color.fromARGB(255, 11, 54, 90),
// //             value: val.value,
// //             onChanged: (bool? newval) {
// //               val.value = newval ?? false;
// //             },
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }
