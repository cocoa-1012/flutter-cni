import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  // static String serverUrl = "http://127.0.0.1:8000/api";
  // static String serverUrl = "http://192.168.43.49:8000/api";
  // static String serverUrl = "http://10.0.2.2:8000/api";
  static String serverUrl = "http://cni.today/api";

  checkPincode(String pincode) async {
    String myUrl = "$serverUrl/checkToken";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'connection': 'keep-alive',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded'
    };
    final body = jsonEncode({
      "pincode": "$pincode",
    });

    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  checkFirstToken(String fbmToken) async {
    String myUrl = "$serverUrl/checkFirstTimeToken/$fbmToken";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'connection': 'keep-alive',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded'
    };
    final response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  login(String pincode, fcmToken) async {
    String myUrl = "$serverUrl/login";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded'
    };
    final body = jsonEncode({"pincode": "$pincode", "fcm_token": "$fcmToken"});
    print(myUrl);
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  postProject(
      String projId, date, approvedHour, comment, projName, token) async {
    String myUrl = "$serverUrl/user/postProject";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "proj_id": "$projId",
      "date": "$date",
      "approved_hour": "$approvedHour",
      "comment": "$comment",
      'proj_name': "$projName"
    });
    print(body);
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  getProjectList(String token) async {
    String myUrl = "$serverUrl/user/getOfficeProject";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  checkInDetails(String empNo, projectname, projectcode, checkintime,
      checkinaddress, checkincomments, token, checkinlat, checkinlng) async {
    String myUrl = "$serverUrl/user/checkIn";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'emp_no': '$empNo',
      "project_name": "$projectname",
      "projectcode": "$projectcode",
      "checkin_time": "$checkintime",
      "checkin_address": "$checkinaddress",
      "checkin_comments": "$checkincomments",
      "checkin_lat": "$checkinlat",
      "checkin_lng": "$checkinlng",
    });
    print('this is the body $body');
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  materialOut(String empNo, materialcode, projectname, materialout, comment,
      datetime, token) async {
    String myUrl = "$serverUrl/user/materialOut";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "emp_no": "$empNo",
      "material_code": "$materialcode",
      "project_name": "$projectname",
      "material_out": "$materialout",
      "comment": "$comment",
      "date_time": "$datetime",
    });
    print(body);
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  getAssetLog(String token) async {
    String myUrl = "$serverUrl/user/getAssetlog";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  getUser(String token) async {
    String myUrl = "$serverUrl/user/userProfile";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  getCheck(String token, userId) async {
    String myUrl = "$serverUrl/user/getCheck/$userId";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    print('this is CheckOut url $myUrl');
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  checkOutDetails(String id, checkOuttime, checkOutaddress, checkincomments,
      token, checkoutlat, checkoutlng) async {
    String myUrl = "$serverUrl/user/checkOut/$id";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "checkout_time": "$checkOuttime",
      "checkout_address": "$checkOutaddress",
      "checkin_comments": "$checkincomments",
      "checkout_lat": "$checkoutlat",
      "checkout_lng": "$checkoutlng",
    });

    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  getMaterialInventory(String token, materialCode) async {
    String myUrl = "$serverUrl/user/getMaterialInventory/$materialCode";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  getAssetInventory(String token, assetCode) async {
    String myUrl = "$serverUrl/user/getAssetInventory/$assetCode";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  addAssetInventory(String assetCode, empNo, assetName, checkinDate,
      checkoutDate, token) async {
    String myUrl = "$serverUrl/user/assetLog";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "asset_code": "$assetCode",
      "emp_no": "$empNo",
      "asset_name": "$assetName",
      "checkin_date": "$checkinDate",
      "checkout_date": "$checkoutDate",
    });
    print(body);
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }

  getReturnAssetInventory(String token, assetCode) async {
    String myUrl = "$serverUrl/user/returnAssetInventory/$assetCode";
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    http.Response response = await http.get(Uri.parse(myUrl), headers: headers);
    return response;
  }

  returnAsset(String assetCode, empNo, assetName, checkinDate, checkoutDate,
      token) async {
    String myUrl = "$serverUrl/user/Returnasset";

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Content-Transfer-Encoding': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      "asset_code": "$assetCode",
      "emp_no": "$empNo",
      "asset_name": "$assetName",
      "checkin_date": "$checkinDate",
      // "checkout_date": "time out Time",
      "checkout_date": "$checkoutDate",
    });
    final response =
        await http.post(Uri.parse(myUrl), headers: headers, body: body);
    return response;
  }
}
