class Health {
  String sId;
  String speciality;
  String subject;
  String description;
  String doctorid;
  String createdAt;
  String updatedAt;
  int iV;

  Health(
      {this.sId,
      this.speciality,
      this.subject,
      this.description,
      this.doctorid,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Health.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    speciality = json['speciality'];
    subject = json['subject'];
    description = json['description'];
    doctorid = json['doctorid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['speciality'] = this.speciality;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['doctorid'] = this.doctorid;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
