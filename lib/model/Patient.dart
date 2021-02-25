class Patient {
  String sId;
  String id;
  String name;
  String cityId;
  int pincode;
  String gender;
  int age;
  int mobile;
  String password;
  String employeeTag;
  int employeeId;
  String groupId;
  String relation;
  String email;
  String renewalFlag;
  String activeFlag;
  String activePlanId;
  String height;
  String weight;
  List symptoms, services;

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

  Patient.fromJson(Map<String, dynamic> json) {
    Map json2 = json;
    json = json["userdata"][0];
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
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
    email = json['email'];
    renewalFlag = json['renewalFlag'];
    activeFlag = json['activeFlag'];
    activePlanId = json['activePlanId'];
    height = json['height'];
    weight = json['weight'];
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
