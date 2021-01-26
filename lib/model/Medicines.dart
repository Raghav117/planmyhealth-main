class Medicines {
  List<Medicinelist> medicinelist;

  Medicines({this.medicinelist});

  Medicines.fromJson(Map<String, dynamic> json) {
    if (json['medicinelist'] != null) {
      medicinelist = new List<Medicinelist>();
      json['medicinelist'].forEach((v) {
        medicinelist.add(new Medicinelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicinelist != null) {
      data['medicinelist'] = this.medicinelist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicinelist {
  String sId;
  int id;
  String drugName;
  String composition;
  String manufacturer;
  double price;
  String packing;
  String prescription;
  String introduction;
  String useOfMedicine;
  String sideEffects;
  String howToCope;
  String howToUse;
  String howItWork;
  String safetyAdvice;
  String ifForget;
  String expertAdvice;
  String alternateBrand;
  String interationWithDrug;
  String patientConcerns;
  String relatedProdcuts;
  String feedBacks;
  String ayurvedicIngredients;
  String relatedLabTest;
  String faq;
  String references;
  String manufacturerAddress;
  String vendorPartner;

  Medicinelist(
      {this.sId,
      this.id,
      this.drugName,
      this.composition,
      this.manufacturer,
      this.price,
      this.packing,
      this.prescription,
      this.introduction,
      this.useOfMedicine,
      this.sideEffects,
      this.howToCope,
      this.howToUse,
      this.howItWork,
      this.safetyAdvice,
      this.ifForget,
      this.expertAdvice,
      this.alternateBrand,
      this.interationWithDrug,
      this.patientConcerns,
      this.relatedProdcuts,
      this.feedBacks,
      this.ayurvedicIngredients,
      this.relatedLabTest,
      this.faq,
      this.references,
      this.manufacturerAddress,
      this.vendorPartner});

  Medicinelist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    drugName = json['drugName'];
    composition = json['composition'];
    manufacturer = json['manufacturer'];
    price = json['price'];
    packing = json['packing'];
    prescription = json['prescription'];
    introduction = json['introduction'];
    useOfMedicine = json['useOfMedicine'];
    sideEffects = json['sideEffects'];
    howToCope = json['howToCope'];
    howToUse = json['howToUse'];
    howItWork = json['howItWork'];
    safetyAdvice = json['safetyAdvice'];
    ifForget = json['ifForget'];
    expertAdvice = json['expertAdvice'];
    alternateBrand = json['alternateBrand'];
    interationWithDrug = json['interationWithDrug'];
    patientConcerns = json['patientConcerns'];
    relatedProdcuts = json['relatedProdcuts'];
    feedBacks = json['feedBacks'];
    ayurvedicIngredients = json['ayurvedic_ingredients'];
    relatedLabTest = json['related_lab_test'];
    faq = json['faq'];
    references = json['references'];
    manufacturerAddress = json['manufacturer_address'];
    vendorPartner = json['vendor_partner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['drugName'] = this.drugName;
    data['composition'] = this.composition;
    data['manufacturer'] = this.manufacturer;
    data['price'] = this.price;
    data['packing'] = this.packing;
    data['prescription'] = this.prescription;
    data['introduction'] = this.introduction;
    data['useOfMedicine'] = this.useOfMedicine;
    data['sideEffects'] = this.sideEffects;
    data['howToCope'] = this.howToCope;
    data['howToUse'] = this.howToUse;
    data['howItWork'] = this.howItWork;
    data['safetyAdvice'] = this.safetyAdvice;
    data['ifForget'] = this.ifForget;
    data['expertAdvice'] = this.expertAdvice;
    data['alternateBrand'] = this.alternateBrand;
    data['interationWithDrug'] = this.interationWithDrug;
    data['patientConcerns'] = this.patientConcerns;
    data['relatedProdcuts'] = this.relatedProdcuts;
    data['feedBacks'] = this.feedBacks;
    data['ayurvedic_ingredients'] = this.ayurvedicIngredients;
    data['related_lab_test'] = this.relatedLabTest;
    data['faq'] = this.faq;
    data['references'] = this.references;
    data['manufacturer_address'] = this.manufacturerAddress;
    data['vendor_partner'] = this.vendorPartner;
    return data;
  }
}
