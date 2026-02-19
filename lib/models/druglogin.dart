class Druglogin {
  String? name;
  String? role;
  String? empcode;
  String? circle;
  String? designation;
  String? mobile;

  Druglogin({
    this.name,
    this.role,
    this.empcode,
    this.circle,
    this.designation,
    this.mobile,
  });

  Druglogin.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    role = json['Role'];
    empcode = json['Empcode'];
    circle = json['Circle'];
    designation = json['Designation'];
    mobile = json['Mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Role'] = role;
    data['Empcode'] = empcode;
    data['Circle'] = circle;
    data['Designation'] = designation;
    data['Mobile'] = mobile;
    return data;
  }
}
