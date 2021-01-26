class LoginData {
  String message;
  Data data;

  LoginData({this.message, this.data});

  LoginData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String sId;
  int id;
  String name;
  String qualification;
  String specialization;
  int experience;
  String treatmentType;
  String picture;
  String cityId;
  int pincode;
  String redId;
  String email;
  int mobile;
  String fromTime;
  String toTome;
  int otp;
  String updatedAt;
  int loggedintime;
  int otpstatus;

  Data(
      {this.sId,
      this.id,
      this.name,
      this.qualification,
      this.specialization,
      this.experience,
      this.treatmentType,
      this.picture,
      this.cityId,
      this.pincode,
      this.redId,
      this.email,
      this.mobile,
      this.fromTime,
      this.toTome,
      this.otp,
      this.updatedAt,
      this.loggedintime,
      this.otpstatus});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    qualification = json['qualification'];
    specialization = json['specialization'];
    experience = json['experience'];
    treatmentType = json['treatmentType'];
    picture = json['picture'];
    cityId = json['cityId'];
    pincode = json['pincode'];
    redId = json['redId'];
    email = json['email'];
    mobile = json['mobile'];
    fromTime = json['fromTime'];
    toTome = json['toTome'];
    otp = json['otp'];
    updatedAt = json['updatedAt'];
    loggedintime = json['loggedintime'];
    otpstatus = json['otpstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['qualification'] = this.qualification;
    data['specialization'] = this.specialization;
    data['experience'] = this.experience;
    data['treatmentType'] = this.treatmentType;
    data['picture'] = this.picture;
    data['cityId'] = this.cityId;
    data['pincode'] = this.pincode;
    data['redId'] = this.redId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['fromTime'] = this.fromTime;
    data['toTome'] = this.toTome;
    data['otp'] = this.otp;
    data['updatedAt'] = this.updatedAt;
    data['loggedintime'] = this.loggedintime;
    data['otpstatus'] = this.otpstatus;
    return data;
  }
}
