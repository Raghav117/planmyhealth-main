class Wellness {
  List<Wellnesslist> wellnesslist;

  Wellness({this.wellnesslist});

  Wellness.fromJson(Map<String, dynamic> json) {
    if (json['wellnesslist'] != null) {
      wellnesslist = <Wellnesslist>[];
      json['wellnesslist'].forEach((v) {
        wellnesslist.add(new Wellnesslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wellnesslist != null) {
      data['wellnesslist'] = this.wellnesslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wellnesslist {
  String sId;
  String wellnessname;

  Wellnesslist({this.sId, this.wellnessname});

  Wellnesslist.fromJson(Map<String, dynamic> json) {
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
