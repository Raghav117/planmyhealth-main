import 'dart:convert';

class Patient {
  String sId;
  String id;
  String name;
  String cityId, address;
  int pincode;
  String gender;
  int age;
  int mobile;
  String password;
  String employeeTag,
      // ignore: non_constant_identifier_names
      blood_group,
      occupation,
      // ignore: non_constant_identifier_names
      exercise_flag,
      // ignore: non_constant_identifier_names
      sick_frequently,
      // ignore: non_constant_identifier_names
      meals_per_day,
      relation;
  int employeeId;
  String groupId, pdffile;
  String email;
  String renewalFlag;
  String activeFlag;
  String activePlanId, dateOfJoining;
  String height;
  String weight,
      picture,
      // ignore: non_constant_identifier_names
      Primary_Health_Issue,
      // ignore: non_constant_identifier_names
      Treatment_Consultant,
      remarks,
      preferredlanguage;
  List symptoms, diagnosis;
  String services;
  String preferred_mode_of_treatment,
      medical_history,
      lifestyle,
      food_habit,
      water_intake_daily;

  Patient({
    this.sId,
    this.id,
    this.name,
    this.cityId,
    this.pincode,
    this.gender,
    this.age,
    this.mobile,
    this.password,
    this.employeeTag,
    this.employeeId,
    this.groupId,
    this.relation,
    this.email,
    this.renewalFlag,
    this.activeFlag,
    this.activePlanId,
    this.height,
    this.weight,
  });

  Patient.fromJson(Map<String, dynamic> json, Map<String, dynamic> json3) {
    json = json["userdata"][0];
    sId = json3['_id'];
    id = json['_id'].toString();
    name = json['name'].toString();
    cityId = json['cityId'];
    pincode = json['pincode'];
    gender = json['gender'];
    age = json['age'];
    mobile = json['mobile'];
    password = json['password'];
    employeeTag = json['employeeTag'];
    employeeId = json['employeeId'];
    groupId = json['groupId'];
    relation = json['relation'];
    address = json['address'];
    picture = json['picture'].toString();
    blood_group = json['blood_group'];
    occupation = json['occupation'];
    exercise_flag = json['exercise_flag'];
    sick_frequently = json['sick_frequently'];
    meals_per_day = json['meals_per_day'];
    email = json['email'];
    renewalFlag = json['renewalFlag'];
    activeFlag = json['activeFlag'];
    activePlanId = json['activePlanId'];
    height = json['height'];
    weight = json['weight'];
    dateOfJoining = json['dateOfJoining'];
    symptoms = json3["symptoms"];
    preferred_mode_of_treatment = json['preferred_mode_of_treatment'];
    medical_history = json['medical_history'];
    water_intake_daily = json['water_intake_daily'];
    food_habit = json['food_habit'];
    lifestyle = json['lifestyle'];
    services = json3["modeofservice"];
    Primary_Health_Issue = json3["primaryhealthissue"];
    pdffile = json3["pdffile"];
    preferredlanguage = json3["preferredlanguage"];
    diagnosis = jsonDecode(json3["diagnosis"].toString());
    // Treatment_Consultant = json2["usercheckup"][2]["Treatment_Consultant"];
    remarks = json3["remarks"];
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
