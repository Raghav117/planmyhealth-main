class Speciality {
  String sId;
  int id;
  String name;
  String treatmentMode;
  String provTypeCode;
  String qualification;

  Speciality(
      {this.sId,
      this.id,
      this.name,
      this.treatmentMode,
      this.provTypeCode,
      this.qualification});

  Speciality.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    treatmentMode = json['treatmentMode'];
    provTypeCode = json['provTypeCode'];
    qualification = json['qualification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['treatmentMode'] = this.treatmentMode;
    data['provTypeCode'] = this.provTypeCode;
    data['qualification'] = this.qualification;
    return data;
  }
}
