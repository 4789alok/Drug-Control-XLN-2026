class CreateInspection {
  String? message;
  String? firmId;
  String? inspectionId;
  String? firmName;
  String? firmApplFor;
  String? inspectionDate;
  String? inspectionTime;
  String? inspectionStatus;

  CreateInspection({
    this.message,
    this.firmId,
    this.inspectionId,
    this.firmName,
    this.firmApplFor,
    this.inspectionDate,
    this.inspectionTime,
    this.inspectionStatus,
  });

  CreateInspection.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    firmId = json['Firm_Id'];
    inspectionId = json['Inspection_Id'];
    firmName = json['Firm_Name'];
    firmApplFor = json['Firm_ApplFor'];
    inspectionDate = json['Inspection_Date'];
    inspectionTime = json['Inspection_Time'];
    inspectionStatus = json['Inspection_Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Firm_Id'] = firmId;
    data['Inspection_Id'] = inspectionId;
    data['Firm_Name'] = firmName;
    data['Firm_ApplFor'] = firmApplFor;
    data['Inspection_Date'] = inspectionDate;
    data['Inspection_Time'] = inspectionTime;
    data['Inspection_Status'] = inspectionStatus;
    return data;
  }
}
