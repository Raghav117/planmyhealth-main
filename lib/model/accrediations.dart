class Accrediation {
  String sId;
  String aid;
  String accrediationCode;
  String accrediationName;
  String status;

  Accrediation(
      {this.sId,
      this.aid,
      this.accrediationCode,
      this.accrediationName,
      this.status});

  Accrediation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    aid = json['aid'];
    accrediationCode = json['accrediation_code'];
    accrediationName = json['accrediation_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['aid'] = this.aid;
    data['accrediation_code'] = this.accrediationCode;
    data['accrediation_name'] = this.accrediationName;
    data['status'] = this.status;
    return data;
  }
}
