class AssetLog {
  int? id;
  String? empNo;
  String? assetCode;
  String? assetName;
  String? checkStatus;
  String? checkinDate;
  String? checkoutDate;

  AssetLog(
      {this.id,
      this.empNo,
      this.assetCode,
      this.assetName,
      this.checkStatus,
      this.checkinDate,
      this.checkoutDate});

  AssetLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNo = json['emp_no'];
    assetCode = json['asset_code'];
    assetName = json['asset_name'];
    checkStatus = json['check_status'];
    checkinDate = json['checkin_date'];
    checkoutDate = json['checkout_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_no'] = this.empNo;
    data['asset_code'] = this.assetCode;
    data['asset_name'] = this.assetName;
    data['check_status'] = this.checkStatus;
    data['checkin_date'] = this.checkinDate;
    data['checkout_date'] = this.checkoutDate;
    return data;
  }
}
