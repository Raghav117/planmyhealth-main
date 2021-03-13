import 'dart:convert';

import 'package:plan_my_health/model/equipments.dart';

class HomeVisit {
  List<Recomandation> furtherrecommendation = [];
  List<Treatment> treatment = [];
  List<Issue> issues = [];
  List<Equip> equipments = [];
  String sId;
  String intime;
  String outtime;
  String doctorid;
  String date;
  String remark;
  String charges;
  String status;
  String createdAt;
  String updatedAt;
  int iV;

  HomeVisit(
      {this.furtherrecommendation,
      this.treatment,
      this.issues,
      this.equipments,
      this.sId,
      this.intime,
      this.outtime,
      this.doctorid,
      this.date,
      this.remark,
      this.charges,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  HomeVisit.fromJson(Map<String, dynamic> json) {
    List response = json['furtherrecommendation'];
    print(response);
    List res = jsonDecode(response[0]);
    // print(response[0]);
    res.forEach((element) {
      furtherrecommendation.add(Recomandation.fromJson(element));
    });
    print(furtherrecommendation);

    response = json['treatment'];
    print(response);
    res = jsonDecode(response[0]);
    // print(response[0]);
    res.forEach((element) {
      treatment.add(Treatment.fromJson(element));
    });
    print(treatment);

    response = json['issues'];
    print(response);
    res = jsonDecode(response[0]);
    // print(response[0]);
    res.forEach((element) {
      issues.add(Issue.fromJson(element));
    });
    print(treatment);

    response = json['equipments'];
    print(response);
    res = jsonDecode(response[0]);
    // print(response[0]);
    res.forEach((element) {
      equipments.add(Equip.fromJson(element));
    });
    print(treatment);
    // furtherrecommendation = json['furtherrecommendation'].cast<String>();
    // treatment = json['treatment'].cast<String>();
    // issues = json['issues'].cast<String>();
    // equipments = json['equipments'].cast<String>();
    sId = json['_id'];
    intime = json['intime'];
    outtime = json['outtime'];
    doctorid = json['doctorid'];
    date = json['date'];
    remark = json['remark'];
    charges = json['charges'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['furtherrecommendation'] = this.furtherrecommendation;
    data['treatment'] = this.treatment;
    data['issues'] = this.issues;
    data['equipments'] = this.equipments;
    data['_id'] = this.sId;
    data['intime'] = this.intime;
    data['outtime'] = this.outtime;
    data['doctorid'] = this.doctorid;
    data['date'] = this.date;
    data['remark'] = this.remark;
    data['charges'] = this.charges;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
