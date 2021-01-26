class Treatment {
  String sId;
  String icdCode;
  String diagnosisName;
  String description;
  String avgDaysOfCure;
  String specialistCode;
  String sideEffects;
  String symptoms;
  String testRecommended;
  String medicineRecommended;
  String ayushTreatment;

  Treatment(
      {this.sId,
      this.icdCode,
      this.diagnosisName,
      this.description,
      this.avgDaysOfCure,
      this.specialistCode,
      this.sideEffects,
      this.symptoms,
      this.testRecommended,
      this.medicineRecommended,
      this.ayushTreatment});

  Treatment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    icdCode = json['icd_code'];
    diagnosisName = json['diagnosis_name'];
    description = json['description'];
    avgDaysOfCure = json['avg_days_of_cure'];
    specialistCode = json['specialist_code'];
    sideEffects = json['side_effects'];
    symptoms = json['symptoms'];
    testRecommended = json['test_recommended'];
    medicineRecommended = json['medicine_recommended'];
    ayushTreatment = json['ayush_treatment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['icd_code'] = this.icdCode;
    data['diagnosis_name'] = this.diagnosisName;
    data['description'] = this.description;
    data['avg_days_of_cure'] = this.avgDaysOfCure;
    data['specialist_code'] = this.specialistCode;
    data['side_effects'] = this.sideEffects;
    data['symptoms'] = this.symptoms;
    data['test_recommended'] = this.testRecommended;
    data['medicine_recommended'] = this.medicineRecommended;
    data['ayush_treatment'] = this.ayushTreatment;
    return data;
  }
}
