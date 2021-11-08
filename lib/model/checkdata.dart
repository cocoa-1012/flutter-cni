class CheckData {
  int? id;
  dynamic empNo;
  String? projectName;
  dynamic projectcode;
  String? checkinTime;
  dynamic workerId;
  dynamic checkinComments;
  String? checkinAddress;
  dynamic checkinLat;
  dynamic checkinLng;
  dynamic checkoutTime;
  dynamic checkoutWorkerId;
  dynamic checkoutAddress;
  dynamic checkoutLat;
  dynamic checkoutLng;

  CheckData(
      {this.id,
      this.empNo,
      this.projectName,
      this.projectcode,
      this.checkinTime,
      this.workerId,
      this.checkinComments,
      this.checkinAddress,
      this.checkinLat,
      this.checkinLng,
      this.checkoutTime,
      this.checkoutWorkerId,
      this.checkoutAddress,
      this.checkoutLat,
      this.checkoutLng});

  CheckData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNo = json['emp_no'];
    projectName = json['project_name'];
    projectcode = json['projectcode'];
    checkinTime = json['checkin_time'];
    workerId = json['worker_id'];
    checkinComments = json['checkin_comments'];
    checkinAddress = json['checkin_address'];
    checkinLat = json['checkin_lat'];
    checkinLng = json['checkin_lng'];
    checkoutTime = json['checkout_time'];
    checkoutWorkerId = json['checkout_worker_id'];
    checkoutAddress = json['checkout_address'];
    checkoutLat = json['checkout_lat'];
    checkoutLng = json['checkout_lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_no'] = this.empNo;
    data['project_name'] = this.projectName;
    data['projectcode'] = this.projectcode;
    data['checkin_time'] = this.checkinTime;
    data['worker_id'] = this.workerId;
    data['checkin_comments'] = this.checkinComments;
    data['checkin_address'] = this.checkinAddress;
    data['checkin_lat'] = this.checkinLat;
    data['checkin_lng'] = this.checkinLng;
    data['checkout_time'] = this.checkoutTime;
    data['checkout_worker_id'] = this.checkoutWorkerId;
    data['checkout_address'] = this.checkoutAddress;
    data['checkout_lat'] = this.checkoutLat;
    data['checkout_lng'] = this.checkoutLng;
    return data;
  }
}
