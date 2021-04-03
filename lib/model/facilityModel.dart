class Facility {
  String sId;
  String id;
  String code;
  String type;
  String facility;

  Facility({this.sId, this.id, this.code, this.type, this.facility});

  Facility.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    code = json['code'];
    type = json['type'];
    facility = json['facility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['code'] = this.code;
    data['type'] = this.type;
    data['facility'] = this.facility;
    return data;
  }
}
