class SelectMedicineList {
  String id;
  String name;
  String time;
  String qut;
  String withtake;
  String days;

  SelectMedicineList({this.id, this.name, this.time, this.qut, this.withtake});

  SelectMedicineList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
    qut = json['qut'];
    withtake = json['withtake'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    data['qut'] = this.qut;
    data['withtake'] = this.withtake;
    return data;
  }
}
