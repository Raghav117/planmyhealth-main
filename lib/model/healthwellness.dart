class Wellness {
  String sId;
  String category;
  String servicemode;
  String clientname;
  String mobilenumber;
  String doctorid;
  String createdAt;
  String updatedAt;
  int iV;

  Wellness(
      {this.sId,
      this.category,
      this.servicemode,
      this.clientname,
      this.mobilenumber,
      this.doctorid,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Wellness.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
    servicemode = json['servicemode'];
    clientname = json['clientname'];
    mobilenumber = json['mobilenumber'];
    doctorid = json['doctorid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['category'] = this.category;
    data['servicemode'] = this.servicemode;
    data['clientname'] = this.clientname;
    data['mobilenumber'] = this.mobilenumber;
    data['doctorid'] = this.doctorid;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
