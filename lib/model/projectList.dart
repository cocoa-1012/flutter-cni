class ProjectList {
  int? id;
  String? projId;
  String? qttId;
  String? companyName;
  dynamic worksiteAddress;
  dynamic contactPerson;
  String? email;
  String? tel;
  String? fax;
  dynamic siteIncharge;
  dynamic siteTel;
  String? startDate;
  dynamic endDate;
  String? rE;
  dynamic projIncharge;
  String? projStatus;
  dynamic projName;
  dynamic latitude;
  dynamic longitude;

  ProjectList(
      {this.id,
      this.projId,
      this.qttId,
      this.companyName,
      this.worksiteAddress,
      this.contactPerson,
      this.email,
      this.tel,
      this.fax,
      this.siteIncharge,
      this.siteTel,
      this.startDate,
      this.endDate,
      this.rE,
      this.projIncharge,
      this.projStatus,
      this.projName,
      this.latitude,
      this.longitude});

  ProjectList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projId = json['proj_id'];
    qttId = json['qtt_id'];
    companyName = json['company_name'];
    worksiteAddress = json['worksite_address'];
    contactPerson = json['contact_person'];
    email = json['email'];
    tel = json['tel'];
    fax = json['fax'];
    siteIncharge = json['site_incharge'];
    siteTel = json['site_tel'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    rE = json['RE'];
    projIncharge = json['proj_incharge'];
    projStatus = json['proj_status'];
    projName = json['proj_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['proj_id'] = this.projId;
    data['qtt_id'] = this.qttId;
    data['company_name'] = this.companyName;
    data['worksite_address'] = this.worksiteAddress;
    data['contact_person'] = this.contactPerson;
    data['email'] = this.email;
    data['tel'] = this.tel;
    data['fax'] = this.fax;
    data['site_incharge'] = this.siteIncharge;
    data['site_tel'] = this.siteTel;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['RE'] = this.rE;
    data['proj_incharge'] = this.projIncharge;
    data['proj_status'] = this.projStatus;
    data['proj_name'] = this.projName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
