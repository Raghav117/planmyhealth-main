class PRates {
  String sId;
  String providerType;
  String serviceType;
  String mRP;
  String referralCut;
  String finalPrice;

  PRates(
      {this.sId,
      this.providerType,
      this.serviceType,
      this.mRP,
      this.referralCut,
      this.finalPrice});

  PRates.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    providerType = json['provider_type'];
    serviceType = json['Service_type'];
    mRP = json['MRP'];
    referralCut = json['Referral_cut'];
    finalPrice = json['Final Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['provider_type'] = this.providerType;
    data['Service_type'] = this.serviceType;
    data['MRP'] = this.mRP;
    data['Referral_cut'] = this.referralCut;
    data['Final Price'] = this.finalPrice;
    return data;
  }
}
