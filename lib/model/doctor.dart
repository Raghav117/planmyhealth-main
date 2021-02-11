import 'package:flutter/material.dart';

class Data {
  String sId;
  String name;
  String email;
  int mobile;
  String dob;
  String gender;
  String specialization;
  String practice;
  String qualification;
  int experience;
  String clinicname;
  String cityId;
  String address;
  String workinghour;
  String registrationno;
  String picture;
  String signature;
  String documentfiles;
  String latitude;
  String longitude;
  String modeofservices;
  String createdAt;
  String updatedAt;
  int iV;
  String workingfrom;
  String workingto;

  Data(
      {this.sId,
      this.name,
      this.email,
      this.mobile,
      this.dob,
      this.gender,
      this.specialization,
      this.practice,
      this.qualification,
      this.experience,
      this.clinicname,
      this.cityId,
      this.address,
      this.workinghour,
      this.registrationno,
      this.picture,
      this.signature,
      this.documentfiles,
      this.latitude,
      this.longitude,
      this.modeofservices,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    dob = json['dob'];
    gender = json['gender'];
    specialization = json['specialization'];
    practice = json['practice'];
    qualification = json['qualification'];
    experience = json['experience'];
    clinicname = json['clinicname'];
    cityId = json['cityId'];
    address = json['address'];
    workinghour = json['workinghour'];
    registrationno = json['registrationno'];
    picture = json['picture'];
    signature = json['signature'];
    documentfiles = json['documentfiles'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    modeofservices = json['modeofservices'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    workingfrom = json['workingfrom'];
    workingto = json['workingto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['specialization'] = this.specialization;
    data['practice'] = this.practice;
    data['qualification'] = this.qualification;
    data['experience'] = this.experience;
    data['clinicname'] = this.clinicname;
    data['cityId'] = this.cityId;
    data['address'] = this.address;
    data['workinghour'] = this.workinghour;
    data['registrationno'] = this.registrationno;
    data['picture'] = this.picture;
    data['signature'] = this.signature;
    data['documentfiles'] = this.documentfiles;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['modeofservices'] = this.modeofservices;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
