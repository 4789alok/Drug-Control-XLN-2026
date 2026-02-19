class LicenseQuestion {
  final String qNo;
  final String question;
  final String remarks;

  LicenseQuestion({
    required this.qNo,
    required this.question,
    required this.remarks,
  });

  factory LicenseQuestion.fromJson(Map<String, dynamic> json) {
    return LicenseQuestion(
      qNo: json['IR_Qno'],
      question: json['IR_Question'],
      remarks: json['IR_Remarks'] ?? '',
    );
  }
}
