class UserModel {
  int? id;
  dynamic lastLogin;
  dynamic isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  dynamic isStaff;
  dynamic isActive;
  String? dateJoined;
  String? empid;
  String? nric;
  String? nationality;
  String? wpType;
  String? wpNo;
  String? wpExpiry;
  String? passportNo;
  String? passportExpiry;
  String? dob;
  String? role;
  String? email;
  String? phone;
  dynamic latitude;
  dynamic longitude;
  String? pincode;
  String? fcmToken;

  UserModel(
      {this.id,
      this.lastLogin,
      this.isSuperuser,
      this.username,
      this.firstName,
      this.lastName,
      this.isStaff,
      this.isActive,
      this.dateJoined,
      this.empid,
      this.nric,
      this.nationality,
      this.wpType,
      this.wpNo,
      this.wpExpiry,
      this.passportNo,
      this.passportExpiry,
      this.dob,
      this.role,
      this.email,
      this.phone,
      this.latitude,
      this.longitude,
      this.pincode,
      this.fcmToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = json['last_login'];
    isSuperuser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = json['date_joined'];
    empid = json['empid'];
    nric = json['nric'];
    nationality = json['nationality'];
    wpType = json['wp_type'];
    wpNo = json['wp_no'];
    wpExpiry = json['wp_expiry'];
    passportNo = json['passport_no'];
    passportExpiry = json['passport_expiry'];
    dob = json['dob'];
    role = json['role'];
    email = json['email'];
    phone = json['phone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    pincode = json['pincode'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last_login'] = this.lastLogin;
    data['is_superuser'] = this.isSuperuser;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_staff'] = this.isStaff;
    data['is_active'] = this.isActive;
    data['date_joined'] = this.dateJoined;
    data['empid'] = this.empid;
    data['nric'] = this.nric;
    data['nationality'] = this.nationality;
    data['wp_type'] = this.wpType;
    data['wp_no'] = this.wpNo;
    data['wp_expiry'] = this.wpExpiry;
    data['passport_no'] = this.passportNo;
    data['passport_expiry'] = this.passportExpiry;
    data['dob'] = this.dob;
    data['role'] = this.role;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['pincode'] = this.pincode;
    data['fcm_token'] = this.fcmToken;
    return data;
  }
}
