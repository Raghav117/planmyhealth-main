class Equip {
  String sId;
  String id;
  String name;
  String category;

  Equip({this.sId, this.id, this.name, this.category});

  Equip.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['Name'];
    category = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['Name'] = this.name;
    data['Category'] = this.category;
    return data;
  }
}

class Recomandation {
  String sId;
  String name;

  Recomandation({this.sId, this.name});

  Recomandation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Issue {
  String sId;
  String id;
  String createdAt;
  String modifiedAt;
  String description;
  String providerTypeId;

  Issue(
      {this.sId,
      this.id,
      this.createdAt,
      this.modifiedAt,
      this.description,
      this.providerTypeId});

  Issue.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    description = json['description'];
    providerTypeId = json['provider_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['description'] = this.description;
    data['provider_type_id'] = this.providerTypeId;
    return data;
  }
}

class Treatment {
  String sId;
  String id;
  String createdAt;
  String modifiedAt;
  String description;
  String providerTypeId;

  Treatment(
      {this.sId,
      this.id,
      this.createdAt,
      this.modifiedAt,
      this.description,
      this.providerTypeId});

  Treatment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    description = json['description'];
    providerTypeId = json['provider_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['description'] = this.description;
    data['provider_type_id'] = this.providerTypeId;
    return data;
  }
}
