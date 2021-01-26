class Prescriptionfinal {
  String message;
  Filename filename;

  Prescriptionfinal({this.message, this.filename});

  Prescriptionfinal.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    filename = json['filename'] != null
        ? new Filename.fromJson(json['filename'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.filename != null) {
      data['filename'] = this.filename.toJson();
    }
    return data;
  }
}

class Filename {
  String filename;

  Filename({this.filename});

  Filename.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    return data;
  }
}
