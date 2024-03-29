class PatientList {
  List<Doctorlist> doctorlist;

  PatientList({this.doctorlist});

  PatientList.fromJson(Map<String, dynamic> json) {
    if (json['doctorlist'] != null) {
      doctorlist = [];
      json['doctorlist'].forEach((v) {
        doctorlist.add(new Doctorlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorlist != null) {
      data['doctorlist'] = this.doctorlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctorlist {
  String sId;
  List<Userdata> userdata;

  Doctorlist({this.sId, this.userdata});

  Doctorlist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    print(json['userdata'].length);
    userdata = [];
    if (json['userdata'].length > 0) {
      json['userdata'].forEach((v) {
        userdata.add(new Userdata.fromJson(v, sId, json));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userdata != null) {
      data['userdata'] = this.userdata.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userdata {
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
  List symptoms = [];
  List services = [];

  Userdata(
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

  Userdata.fromJson(Map<String, dynamic> json, String sId, Map json2) {
    sId = sId;
    id = json['id'];
    name = json['name'];
    cityId = json['cityId'];
    pincode = json['pincode'];
    gender = json['gender'];
    age = json['age'];
    mobile = json['mobile'];
    password = json['password'];
    dateOfJoining = json['dateOfJoining'].toString();
    employeeTag = json['employeeTag'];
    employeeId = json['employeeId'];
    groupId = json['groupId'];
    relation = json['relation'];
    email = json['email'];
    renewalFlag = json['renewalFlag'];
    activeFlag = json['activeFlag'];
    activePlanId = json['activePlanId'];
    symptoms = json2["symptoms"];
    services = json2["services"];
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
    if (this.dateOfJoining != null) {
      data['dateOfJoining'] = this.dateOfJoining;
    }
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

class DateOfJoining {
  String date;

  DateOfJoining({this.date});

  DateOfJoining.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
