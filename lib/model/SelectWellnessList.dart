class SelectWellnessList {
  String sId;
  String wellnessname;

  SelectWellnessList({this.sId, this.wellnessname});

  SelectWellnessList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    wellnessname = json['wellnessname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['wellnessname'] = this.wellnessname;
    return data;
  }
}
