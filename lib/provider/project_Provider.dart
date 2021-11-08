import 'dart:convert';

import 'package:cni_app/Api/helper.dart';
// import 'package:cni_app/model/assetInventories.dart';
import 'package:cni_app/model/assetInventory.dart';
import 'package:cni_app/model/assetLog.dart';
import 'package:cni_app/model/checkdata.dart';
import 'package:cni_app/model/material_inventory.dart';
// import 'package:cni_app/model/projectList.dart';
import 'package:cni_app/model/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PostProject { initial, error, loading, complete }
enum CheckInState { initial, error, loading, complete }
enum CheckOutState { initial, error, loading, complete }
enum MaterialOutState { initial, error, loading, complete }
enum LoginState { initial, error, loading, complete }
enum CheckPinState { initial, error, loading, complete }
enum AssetInventoryState { initial, error, loading, complete }
enum AssetInventoryOutState { initial, error, loading, complete }

class UserProvider extends ChangeNotifier {
  UserProvider() {
    getAssetLogs();
    getUserProfile();
    checkInOutUser();
  }
  Api api = Api();
  PostProject _postProject = PostProject.initial;
  PostProject get postProject => _postProject;

  Future<bool> projectOT(
      String projId, date, approvedHour, projName, comment) async {
    try {
      _postProject = PostProject.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.postProject(
          projId, date, approvedHour, comment, projName, token);
      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        _postProject = PostProject
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();

        return true;
      }
      print(
          'this is the json result for $responseJson  ${response.statusCode}');
      return false;
    } catch (exception) {
      print('this is get User Detail $exception');
      _postProject = PostProject
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  CheckInState _checkInState = CheckInState.initial;
  CheckInState get checkInState => _checkInState;

  String? _dataId;
  String? get dataId => _dataId;

  Future<bool> checkIn(String empNo, projectname, projectcode, checkintime,
      checkinaddress, checkincomments, checkinlat, checkinlng) async {
    try {
      _checkInState = CheckInState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.checkInDetails(
          empNo,
          projectname,
          projectcode,
          checkintime,
          checkinaddress,
          checkincomments,
          token,
          checkinlat,
          checkinlng);
      final responseJson = json.decode(response.body);
      prefs.setString('userId', '${responseJson['data']['id']}');
      if (response.statusCode == 200) {
        _checkInState = CheckInState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }

      return false;
    } catch (exception) {
      print('this is get User Detail $exception');
      _checkInState = CheckInState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  MaterialOutState _materialOutState = MaterialOutState.initial;
  MaterialOutState get materialOutState => _materialOutState;

  String? _messageOut;
  String? get messageOut => _messageOut;

  Future<bool> materialOut(String empNo, materialcode, projectname, materialout,
      comment, datetime) async {
    try {
      _materialOutState = MaterialOutState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.materialOut(empNo, materialcode, projectname,
          materialout, comment, datetime, token);
      final responseJson = json.decode(response.body);
      print(
          'this is the json result for $responseJson  ${response.statusCode}');
      if (response.statusCode == 200) {
        _materialOutState = MaterialOutState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }
      if (response.statusCode == 422) {
        _messageOut = responseJson['message'];
        _materialOutState = MaterialOutState
            .error; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return false;
      }
      return false;
    } catch (exception) {
      print('this is get User Detail $exception');
      _materialOutState = MaterialOutState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  List<AssetLog> _getAccetlog = <AssetLog>[];
  List<AssetLog> get getAccetlog {
    return [..._getAccetlog];
  }

  Future<List<AssetLog>?> getAssetLogs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.getAssetLog(token);
      var result = json.decode(response.body) as List;
      _getAccetlog = result.map((e) => AssetLog.fromJson(e)).toList();
      notifyListeners();
    } catch (exception) {
      return null;
    }
  }

  List<AssetLog> _getAccetlogStatus = <AssetLog>[];
  List<AssetLog> get getAccetlogStatus {
    return [..._getAccetlogStatus];
  }

  Future<List<AssetLog>?> getAssetLogsStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.getAssetLog(token);
      var result = json.decode(response.body) as List;
      final getEmpId = prefs.getString('empid');
      print('this is empoy id $getEmpId');
      print('This is employee details ${getEmpId.toString()}');
      // if()
      _getAccetlogStatus = result
          .where((status) =>
              status['check_status'] == 1.toString() &&
              status['emp_no'] == getEmpId.toString())
          .map((e) => AssetLog.fromJson(e))
          .toList();
      notifyListeners();
      return _getAccetlogStatus;
    } catch (exception) {
      return null;
    }
  }

  LoginState _loginState = LoginState.initial;
  LoginState get loginState => _loginState;

  String? _getMessage;
  String? get getMessage => _getMessage;

  Future<bool> login(String pincode) async {
    try {
      _loginState = LoginState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String deviceToken = prefs.getString('deviceToken').toString();
      var response = await api.login(pincode, deviceToken);
      final responseJson = json.decode(response.body);
      print(
          'this is the json result for $responseJson  ${response.statusCode}');
      if (response.statusCode == 200) {
        prefs.setString('token', responseJson['token']);
        _loginState = LoginState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }
      if (response.statusCode == 422) {
        _getMessage = responseJson['message'];
        _loginState = LoginState
            .error; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return false;
      }
      _getMessage = responseJson['message'];
      _loginState = LoginState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
    } catch (exception) {
      print('this is get User Detail $exception');
      _loginState = LoginState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  CheckPinState _checkPinState = CheckPinState.initial;
  CheckPinState get checkPinState => _checkPinState;
  bool _checkPinText = false;
  bool get checkPinText => _checkPinText;

  Future<bool> checkPin(String pincode) async {
    try {
      _checkPinState = CheckPinState.loading;
      notifyListeners();
      var response = await api.checkPincode(pincode);
      print(response.statusCode);
      if (response.statusCode == 402) {
        _checkPinState = CheckPinState.error;
        _checkPinText = true;
        print('error 402');
        notifyListeners();
        return false;
      }
      if (response.statusCode == 422) {
        _checkPinState = CheckPinState.error;
        _checkPinText = true;
        print('error 422');
        notifyListeners();
        return false;
      }
      if (response.statusCode == 200) {
        _checkPinState = CheckPinState.complete;
        _checkPinText = true;
        notifyListeners();
        return true;
      }

      return false;
    } catch (exception) {
      print('verify pin token exception $exception');
      print('error exception');
      _checkPinState = CheckPinState.error;
      _checkPinText = true;
      notifyListeners();
      return false;
      // return null;
    }
  }

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  Future<UserModel> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var response = await api.getUser(token);
    final responseJson = json.decode(response.body);
    prefs.setString('empid', '${responseJson['empid']}');
    print('This is profile ${responseJson}');
    print(responseJson);
    _userModel = UserModel.fromJson(responseJson);
    notifyListeners();
    return _userModel;
  }

  CheckData _checkData = CheckData();
  CheckData get checkData => _checkData;

  Future<CheckData?> checkInOutUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var userId = prefs.getString('userId').toString();
      print('this is check id $userId');
      var response = await api.getCheck(token, userId);
      final responseJson = json.decode(response.body);
      print('this is check in result $responseJson $userId');
      _checkData = CheckData.fromJson(responseJson!['data']);
      notifyListeners();
      return _checkData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  CheckOutState _checkOutState = CheckOutState.initial;
  CheckOutState get checkOutState => _checkOutState;
  Future<bool> checkOut(String checkOuttime, checkOutaddress, checkincomments,
      checkoutlat, checkoutlng) async {
    try {
      _checkOutState = CheckOutState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var userId = prefs.getString('userId').toString();
      var response = await api.checkOutDetails(userId, checkOuttime,
          checkOutaddress, checkincomments, token, checkoutlat, checkoutlng);
      final responseJson = json.decode(response.body);

      print(
          'this is the json result for check out $responseJson  $responseJson');
      if (response.statusCode == 200) {
        // prefs.remove('userId');
        // prefs.remove('userId').toString();
        _checkOutState = CheckOutState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }

      return false;
    } catch (exception) {
      print('this is get User Detail $exception');
      _checkOutState = CheckOutState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  MaterialInventory _materialInventory = MaterialInventory();
  MaterialInventory get materialInventory => _materialInventory;

  Future<MaterialInventory?> checkMaterialInventory(
      String? materialCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.getMaterialInventory(token, materialCode);
      final responseJson = json.decode(response.body);
      print('This is response value $responseJson');
      _materialInventory = MaterialInventory.fromJson(responseJson['data']);
      notifyListeners();
      return _materialInventory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // List<ProjectList> _projectList = <ProjectList>[];
  // List<ProjectList> get projectList => _projectList;

  // String? _firstVale;
  // String? get firstVale => _firstVale;

  // Future getResponse(double? currentlag, currentLong) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token').toString();
  //   var response = await api.getProjectList(token);
  //   var result = json.decode(response.body) as List;
  //   // print('this is result from project list ${result[0]}');
  //   result.forEach((element) {
  //     _projectList.add(ProjectList.fromJson(element));
  //     notifyListeners();
  //   });
  //   if (_projectList.any((e) => e.projStatus == 'On-going')) {
  //     if (_projectList.any((ProjectList lat) =>
  //         double.parse(currentLong.toString()) >= double.parse(lat.longitude) &&
  //         double.parse(currentlag.toString()) >= double.parse(lat.latitude))) {
  //       _firstVale = 'true Value';
  //       notifyListeners();
  //     } else {
  //       _firstVale = "false Value";
  //       notifyListeners();
  //     }
  //   } else {
  //     _firstVale = 'true Value';
  //     notifyListeners();
  //   }

  //   return _projectList;
  // }

  // print('this is setLocation $_setlocation');
  // print(
  //     'working this si login ${_projectList.where((e) => double.parse(e.latitude) > 5).map((e) => e.projName)}');

  // print(
  //     'this is data type ${_projectList.map((e) => e.latitude.runtimeType)}');
// if (_projectList.any(
  //         (ProjectList lat) => double.parse(lat.longitude) > -122.0839857) &&
  //     _projectList.any(
  //         (ProjectList lat) => double.parse(lat.latitude) > 37.4217901)) {
  //   _setlocation = true;
  //   notifyListeners();
  //   print('This is map REsult');
  // } else {
  //   _setlocation = false;
  //   notifyListeners();
  //   print('This is false');
  // }
  //  if (_projectList.any((ProjectList lat) =>
  //     double.parse(currentLong.toString()) < double.parse(lat.longitude) &&
  //     double.parse(currentlag.toString()) > double.parse(lat.latitude))) {
//or
  // List<ProjectList> _projectList = <ProjectList>[];
  // List<ProjectList> get projectList {
  //   return [..._projectList];
  // }

  // Future<List<ProjectList>?> getResponse() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token').toString();
  //   var response = await api.getProjectList(token);
  //   var result = json.decode(response.body);
  //   var projectRes = result as List;
  //   print('this is result from project list $result');
  //   _projectList = projectRes.map((e) => ProjectList.fromJson(e)).toList();
  //   // projectRes.forEach((data) {
  //   //   print('this is data ${data['latitude']}');
  //   //   print('this is long ${data['longitude']}');
  //   //   var model = ProjectList();
  //   //   model.projId = data['proj_id'];
  //   //   _project.add(model.projId.toString());
  //   //   notifyListeners();
  //   // });

  //   return _projectList;
  // }

  AssetInventory _assetInventory = AssetInventory();
  AssetInventory get assetInventory => _assetInventory;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Future<AssetInventory?> checkAssetInventory(String assetCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.getAssetInventory(token, assetCode);
      final responseJson = json.decode(response.body);
      print('this is asset Inventory ${response.body}');
      if (response.statusCode == 422 ||
          response.statusCode == 402 ||
          response.statusCode != 200) {
        _errorMessage = responseJson['message'];
        notifyListeners();
        return response.statusCode;
      }
      if (response.statusCode == 200) {
        _assetInventory = AssetInventory.fromJson(responseJson['data']);
        notifyListeners();
      }
      return _assetInventory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  AssetInventoryState _assetInventoryState = AssetInventoryState.initial;
  AssetInventoryState get assetInventoryState => _assetInventoryState;
  String? _displayMessage;

  String? get displayMessage => _displayMessage;

  Future<bool> assetInventoryPost(
      String assetCode, empNo, assetName, checkinDate, checkoutDate) async {
    try {
      _assetInventoryState = AssetInventoryState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.addAssetInventory(
          assetCode, empNo, assetName, checkinDate, checkoutDate, token);
      final responseJson = json.decode(response.body);
      print(
          'this is the json result for asset Inventory $responseJson  ${response.statusCode} ${responseJson['message']}');
      if (response.statusCode == 200) {
        _assetInventoryState = AssetInventoryState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }
      if (response.statusCode == 422) {
        _displayMessage = responseJson['message'];
        _assetInventoryState = AssetInventoryState
            .error; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return false;
      }
      _assetInventoryState = AssetInventoryState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
    } catch (exception) {
      print('this is get json exception for asset Inventory $exception');
      _assetInventoryState = AssetInventoryState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  AssetInventory _assetReturnInventory = AssetInventory();
  AssetInventory get assetReturnInventory => _assetReturnInventory;
  String? _errorReturnMessage;
  String? get errorReturnMessage => _errorReturnMessage;
  Future<AssetInventory?> checkReturnAssetInventory(String assetCode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.getReturnAssetInventory(token, assetCode);
      final responseJson = json.decode(response.body);
      print('this is asset Inventory ${response.body}');
      if (response.statusCode == 422 ||
          response.statusCode == 402 ||
          response.statusCode != 200) {
        _errorMessage = responseJson['message'];
        notifyListeners();
        return null;
      }
      if (response.statusCode == 200) {
        _assetInventory = AssetInventory.fromJson(responseJson['data']);
        notifyListeners();
      }
      return _assetInventory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  AssetInventoryOutState _assetInventoryOutState =
      AssetInventoryOutState.initial;
  AssetInventoryOutState get assetInventoryOutState => _assetInventoryOutState;
  String? _displayMessage2;

  String? get displayMessage2 => _displayMessage2;

  Future<bool> assetInventoryreturn(
    String assetCode,
    empNo,
    assetName,
    checkinDate,
    checkoutDate,
  ) async {
    try {
      _assetInventoryOutState = AssetInventoryOutState.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token').toString();
      var response = await api.returnAsset(
          assetCode, empNo, assetName, checkinDate, checkoutDate, token);
      final responseJson = json.decode(response.body);
      print(
          'this is the json result for asset Inventory return $responseJson  ${response.statusCode} ${responseJson['message']}');
      if (response.statusCode == 200) {
        _assetInventoryOutState = AssetInventoryOutState
            .complete; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return true;
      }
      if (response.statusCode == 422) {
        _displayMessage2 = responseJson['message'];
        _assetInventoryOutState = AssetInventoryOutState
            .error; // When User Touches the Sign Up Button, it will Load
        notifyListeners();
        return false;
      }
      _assetInventoryOutState = AssetInventoryOutState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
    } catch (exception) {
      print('this is get json exception for asset Inventory return $exception');
      _assetInventoryState = AssetInventoryState
          .error; // When User Touches the Sign Up Button, it will Load
      notifyListeners();
      return false;
      // return null;
    }
  }

  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    // prefs.remove('deviceToken');
    prefs.remove('userId');
    prefs.remove('empid');
    _postProject = PostProject.initial;
    _checkInState = CheckInState.initial;
    _dataId = '';
    _materialOutState = MaterialOutState.initial;
    _getAccetlog = <AssetLog>[];
    _loginState = LoginState.initial;
    _checkPinState = CheckPinState.initial;
    _checkPinText = false;
    _userModel = UserModel();
    _checkData = CheckData();
    _checkOutState = CheckOutState.initial;
    _materialInventory = MaterialInventory();
    // _projectList = <ProjectList>[];
    // _firstVale = '';
    _assetInventory = AssetInventory();
    _assetInventoryState = AssetInventoryState.initial;
    return true;
  }
}
