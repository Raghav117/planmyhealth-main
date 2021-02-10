class DoctorsCheckUp {
  String doctorid;
  String doctorname;
  String medicine;
  String test;
  String diagnosis;
  String hospitalised;
  String specialist;
  String wellness;
  String remark;
  List<String> findings;
  String followupdate;

  DoctorsCheckUp(
      {this.doctorid,
      this.doctorname,
      this.medicine,
      this.test,
      this.diagnosis,
      this.hospitalised,
      this.specialist,
      this.wellness,
      this.remark,
      this.findings,
      this.followupdate});

  DoctorsCheckUp.fromJson(Map<String, dynamic> json) {
    doctorid = json['doctorid'];
    doctorname = json['doctorname'];
    medicine = json['medicine'];
    test = json['test'];
    diagnosis = json['diagnosis'].toString();
    hospitalised = json['hospitalised'];
    specialist = json['specialist'];
    wellness = json['wellness'];
    remark = json['remark'];
    findings = json['findings'].cast<String>();
    followupdate = json['followupdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorid'] = this.doctorid;
    data['doctorname'] = this.doctorname;
    data['medicine'] = this.medicine;
    data['test'] = this.test;
    data['diagnosis'] = this.diagnosis;
    data['hospitalised'] = this.hospitalised;
    data['specialist'] = this.specialist;
    data['wellness'] = this.wellness;
    data['remark'] = this.remark;
    data['findings'] = this.findings;
    data['followupdate'] = this.followupdate;
    return data;
  }
}

class UserData {
  String sId;
  String id;
  String name;
  String cityId;
  int pincode;
  String gender;
  int age;
  int mobile;
  String password;
  String dateOfJoining;
  String employeeTag;
  int employeeId;
  String groupId;
  String relation;
  String email;
  String renewalFlag;
  String activeFlag;
  String activePlanId;

  UserData(
      {this.sId,
      this.id,
      this.name,
      this.cityId,
      this.pincode,
      this.gender,
      this.age,
      this.mobile,
      this.password,
      this.dateOfJoining,
      this.employeeTag,
      this.employeeId,
      this.groupId,
      this.relation,
      this.email,
      this.renewalFlag,
      this.activeFlag,
      this.activePlanId});

  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    cityId = json['cityId'];
    pincode = json['pincode'];
    gender = json['gender'];
    age = json['age'];
    mobile = json['mobile'];
    password = json['password'];
    dateOfJoining = json['dateOfJoining'];
    employeeTag = json['employeeTag'];
    employeeId = json['employeeId'];
    groupId = json['groupId'];
    relation = json['relation'];
    email = json['email'];
    renewalFlag = json['renewalFlag'];
    activeFlag = json['activeFlag'];
    activePlanId = json['activePlanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['cityId'] = this.cityId;
    data['pincode'] = this.pincode;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['dateOfJoining'] = this.dateOfJoining;
    data['employeeTag'] = this.employeeTag;
    data['employeeId'] = this.employeeId;
    data['groupId'] = this.groupId;
    data['relation'] = this.relation;
    data['email'] = this.email;
    data['renewalFlag'] = this.renewalFlag;
    data['activeFlag'] = this.activeFlag;
    data['activePlanId'] = this.activePlanId;
    return data;
  }
}
