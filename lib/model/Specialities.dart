class Specialities {
  List<Specialitieslist> specialitieslist;

  Specialities({this.specialitieslist});

  Specialities.fromJson(Map<String, dynamic> json) {
    if (json['specialitieslist'] != null) {
      specialitieslist = new List<Specialitieslist>();
      json['specialitieslist'].forEach((v) {
        specialitieslist.add(new Specialitieslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialitieslist != null) {
      data['specialitieslist'] =
          this.specialitieslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Specialitieslist {
  String sId;
  int id;
  String name;
  String treatmentMode;
  String provTypeCode;
  String qualification;

  Specialitieslist(
      {this.sId,
      this.id,
      this.name,
      this.treatmentMode,
      this.provTypeCode,
      this.qualification});

  Specialitieslist.fromJson(Map<String, dynamic> json) {
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
