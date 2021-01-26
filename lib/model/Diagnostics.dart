class Diagnostics {
  List<Diagnosticslist> diagnosticslist;

  Diagnostics({this.diagnosticslist});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    if (json['diagnosticslist'] != null) {
      diagnosticslist = new List<Diagnosticslist>();
      json['diagnosticslist'].forEach((v) {
        diagnosticslist.add(new Diagnosticslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.diagnosticslist != null) {
      data['diagnosticslist'] =
          this.diagnosticslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diagnosticslist {
  String sId;
  int id;
  String name;
  String code;
  int rate;
  String pmhRate;
  String homeTestFlag;
  String fastingFlag;
  String bloodQuantityRequired;
  String testResults;
  String detailedDescription;
  String diseaseListForWhichTheseTestIsConducted;
  Null minAge;
  Null maxAge;
  String needDocPrescriptionFlag;
  String testType;

  Diagnosticslist(
      {this.sId,
      this.id,
      this.name,
      this.code,
      this.rate,
      this.pmhRate,
      this.homeTestFlag,
      this.fastingFlag,
      this.bloodQuantityRequired,
      this.testResults,
      this.detailedDescription,
      this.diseaseListForWhichTheseTestIsConducted,
      this.minAge,
      this.maxAge,
      this.needDocPrescriptionFlag,
      this.testType});

  Diagnosticslist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    code = json['code'];
    rate = json['rate'];
    pmhRate = json['pmhRate'];
    homeTestFlag = json['homeTestFlag'];
    fastingFlag = json['fastingFlag'];
    bloodQuantityRequired = json['bloodQuantityRequired'];
    testResults = json['testResults'];
    detailedDescription = json['detailedDescription '];
    diseaseListForWhichTheseTestIsConducted =
        json['diseaseListForWhichTheseTestIsConducted'];
    minAge = json['minAge'];
    maxAge = json['maxAge'];
    needDocPrescriptionFlag = json['needDocPrescriptionFlag'];
    testType = json['testType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['rate'] = this.rate;
    data['pmhRate'] = this.pmhRate;
    data['homeTestFlag'] = this.homeTestFlag;
    data['fastingFlag'] = this.fastingFlag;
    data['bloodQuantityRequired'] = this.bloodQuantityRequired;
    data['testResults'] = this.testResults;
    data['detailedDescription '] = this.detailedDescription;
    data['diseaseListForWhichTheseTestIsConducted'] =
        this.diseaseListForWhichTheseTestIsConducted;
    data['minAge'] = this.minAge;
    data['maxAge'] = this.maxAge;
    data['needDocPrescriptionFlag'] = this.needDocPrescriptionFlag;
    data['testType'] = this.testType;
    return data;
  }
}
