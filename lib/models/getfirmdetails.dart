class FirmDetailsModel {
  final String firmId;
  final String firmName;
  final String firmIncharge;
  final String shopBuilding;
  final String area;
  final String town;
  final String pincode;
  final String appliedFor;
  final String constitution;
  final String category;
  final String coldStorage;
  final String validityUpto;
  final List<String> licList;

  FirmDetailsModel({
    required this.firmId,
    required this.firmName,
    required this.firmIncharge,
    required this.shopBuilding,
    required this.area,
    required this.town,
    required this.pincode,
    required this.appliedFor,
    required this.constitution,
    required this.category,
    required this.coldStorage,
    required this.validityUpto,
    required this.licList,
  });

  factory FirmDetailsModel.fromJson(Map<String, dynamic> json) {
    return FirmDetailsModel(
      firmId: json['Firm_Id'] ?? '',
      firmName: json['Firm_Name'] ?? '',
      firmIncharge: json['Firm_Incharge'] ?? '',
      shopBuilding: json['ShopNo_building'] ?? '',
      area: json['Area'] ?? '',
      town: json['Town'] ?? '',
      pincode: json['Pincode'] ?? '',
      appliedFor: json['Applied_For'] ?? '',
      constitution: json['Firm_con'] ?? '',
      category: json['Firm_Category'] ?? '',
      coldStorage: json['Cold_Storage'] ?? '',
      validityUpto: json['Validity_Upto'] ?? '',
      licList: List<String>.from(json['Lic_list'] ?? []),
    );
  }
}
