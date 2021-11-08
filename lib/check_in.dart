import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Api/helper.dart';
import 'color.dart';
import 'model/projectList.dart';
import 'provider/project_Provider.dart';

class CheckIn extends StatefulWidget {
  CheckIn({Key? key}) : super(key: key);

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  Api api = Api();

  List<String> _project = ["Choose Project"];
  String? _selectedProject = "Choose Project";
  bool loadingProject = false;

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // @override
  // void didChangeDependencies() {
  //   Provider.of<UserProvider>(context, listen: false).checkInOutUser();
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    getProject();
    // getLocation();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getLocation();
  // }

  String? latitudeData;
  String? longitudeData;

  // Future getLocation() async {
  //   try {
  //     Location location = new Location();
  //     bool _serviceEnabled;

  //     PermissionStatus _permissionGranted;
  //     LocationData _locationData;

  //     _serviceEnabled = await location.serviceEnabled();
  //     if (!_serviceEnabled) {
  //       _serviceEnabled = await location.requestService();
  //       if (!_serviceEnabled) {
  //         return;
  //       }
  //     }

  //     _permissionGranted = await location.hasPermission();
  //     if (_permissionGranted == PermissionStatus.denied) {
  //       _permissionGranted = await location.requestPermission();
  //       if (_permissionGranted != PermissionStatus.granted) {
  //         return;
  //       }
  //     }

  //     _locationData = await location.getLocation();
  //     setState(() {
  //       latitudeData = _locationData.longitude.toString();
  //       longitudeData = _locationData.latitude.toString();
  //     });

  //     print('thsi si long data $latitudeData');
  //     print('thsi si long data $longitudeData');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // late bool _serviceEnabled;
  // PermissionStatus? _permissionGranted;
  // ignore: unused_field
  // LocationData? _locationData;
  Location location = new Location();

  // Future _getLocation() async {
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   LocationData _currentPosition = await location.getLocation();
  //   Provider.of<UserProvider>(context, listen: false)
  //       .getResponse(_currentPosition.latitude, _currentPosition.longitude);
  // }

  Future getResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var response = await api.getProjectList(token);
    var result = json.decode(response.body);
    print('this is $result');
    return result;
  }

  Future getProject() async {
    var projectRes = await getResponse() as List;
    projectRes
        .where((w) =>
            w['proj_status'] == 'On-going' ||
            w['company_name'] == 'Sick Leave' ||
            w['company_name'] == 'Training / On Course' ||
            w['company_name'] == 'Training / On Course ' ||
            w['company_name'] == 'Training/on course' ||
            w['company_name'] == 'On Course' ||
            w['company_name'] == 'Training' ||
            w['company_name'] == 'Leave' ||
            w['company_name'] == 'Survey' ||
            w['company_name'] == 'MC' ||
            w['company_name'] == 'Others, please comment below' ||
            w['company_name'] == 'Others')
        .forEach((data) {
      // print('this is data ${data}');
      var model = ProjectList();
      if (!mounted) return;
      setState(() {
        model.projId = data['proj_id'];
        model.latitude = data['latitude'];
        model.longitude = data['longitude'];
        model.companyName = data['company_name'];
        model.worksiteAddress = data['worksite_address'];
        model.projName = data['proj_name'];
        _project.add(model.projName.toString() +
            ':' +
            model.latitude.toString() +
            ':' +
            model.longitude.toString() +
            ':' +
            model.companyName.toString() +
            ':' +
            model.worksiteAddress.toString() +
            ':' +
            model.projId.toString());
        loadingProject = true;
      });
    });

    return _project;
  }

  String? sendlong1;
  String? sendlong2;
  String? sendlong;
  String? sendlat;
  String? sendlat1;
  String? newSelectedProject;
  String? companYname;
  // String? workAddress;

  String? projectId;

  bool checkIn = false;
  void _onSelectedProject(String value) async {
    LocationData _currentPosition = await location.getLocation();
    if (!mounted) return;
    setState(() {
      latitudeData = _currentPosition.longitude.toString();
      longitudeData = _currentPosition.latitude.toString();
      _selectedProject = value;
      sendlong1 =
          _selectedProject!.split(':').sublist(1).join(':').trim().toString();
      sendlong2 = sendlong1!.split(':').sublist(1).join(':').trim().toString();
      sendlong =
          sendlong2!.split(':').sublist(0, 1).join(':').trim().toString();
      companYname =
          sendlong2!.split(':').sublist(1, 2).join(':').trim().toString();
      sendlat1 =
          _selectedProject!.split(':').sublist(1).join(':').trim().toString();
      sendlat = sendlat1!.split(':').sublist(0, 1).join(':').trim().toString();
      _addressController.text = sendlong2!
                      .split(':')
                      .sublist(2, 3)
                      .join(':')
                      .trim()
                      .toString() ==
                  null.toString() ||
              sendlong2!.split(':').sublist(2, 3).join(':').trim().toString() ==
                  ''
          ? ''
          : sendlong2!.split(':').sublist(2, 3).join(':').trim().toString();
      newSelectedProject = _selectedProject!
          .split(':')
          .sublist(0, 1)
          .join(':')
          .trim()
          .toString();
      projectId = _selectedProject!
          .split(':')
          .sublist(5, 6) //take the last two values
          .join(':')
          .trim()
          .toString();
    });
    print(
        'this is projec name for $projectId value work address  $_selectedProject  and $longitudeData ooo  $sendlong companye name $companYname  and $sendlat and new $newSelectedProject my current ${_currentPosition.latitude},  and current ${_currentPosition.longitude},');
    if (companYname == 'Sick Leave' ||
        companYname == 'Training / On Course' ||
        companYname == 'Training / On Course ' ||
        companYname == 'Training/on course' ||
        companYname == 'On Course' ||
        companYname == 'Training' ||
        companYname == 'Leave' ||
        companYname == 'Survey' ||
        companYname == 'MC' ||
        companYname == 'Others, please comment below' ||
        companYname == 'Others') {
      print('leave');
      setState(() {
        checkIn = true;
      });
    } else {
      calculateDistance(
          _currentPosition.latitude,
          _currentPosition.longitude,
          sendlat.toString() == null.toString()
              ? 0.0
              : double.parse(sendlat.toString()),
          sendlong.toString() == null.toString()
              ? 0.0
              : double.parse(sendlong.toString()));
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    if (12742 * asin(sqrt(a)) <= 1) {
      setState(() {
        checkIn = true;
      });
    } else {
      setState(() {
        checkIn = false;
      });
    }
    print('Thois is distance in KM ${12742 * asin(sqrt(a)) <= 1}');
    print('Thois is distance in KM ${12742 * asin(sqrt(a))}');
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: HexColor.fromHex('#9E9E9E'),
          elevation: 3,
          centerTitle: true,
          title: Text(
            'Check In',
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Project:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: 70,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(
                              left: 2.0, bottom: 2.0, top: 8.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: Border.all(
                                  color: Colors.black,
                                  // Color(0xffDEE0E8).withAlpha(10), // set border color
                                  width: 1.0), // set border width
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ) // set rounded corner radius
                              ),
                          child: Theme(
                              data: ThemeData(
                                canvasColor: Colors.black,
                              ),
                              child: DropdownButton<String>(
                                  focusColor: Colors.black,
                                  dropdownColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: _project.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: loadingProject == false
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(
                                              width: double.infinity,
                                              alignment: Alignment.centerLeft,
                                              height: 50,
                                              child: ListView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 1.0,
                                                            top: 5.0),
                                                    child: Text(
                                                        value
                                                            .split(':')
                                                            .sublist(0, 1)
                                                            .join(':')
                                                            .trim()
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  value == 'Choose Project' ||
                                                          value ==
                                                              _selectedProject
                                                      ? SizedBox()
                                                      : Divider(
                                                          color: Colors.black,
                                                          thickness: 0.5,
                                                        )
                                                ],
                                              ),
                                            ),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      _onSelectedProject(value!),
                                  value: _selectedProject
                                  // ),
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Address:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        // height: 70,
                        child: TextField(
                          readOnly: true,
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          controller: _addressController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.withOpacity(.5),
                            filled: true,
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, bottom: 2.0, top: 8.0),
                        child: Text(
                          'Comment:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        // height: 70,
                        child: TextField(
                          toolbarOptions: ToolbarOptions(
                              copy: false, cut: false, paste: false),
                          controller: _commentController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: 8,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.grey, width: 2.0)),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 60.0,
                          // ignore: deprecated_member_use
                          child: Consumer<UserProvider?>(
                              builder: (_, userdata, child) {
                            var data = userdata!.userModel;
                            // ignore: deprecated_member_use
                            return FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)),
                                color: Colors.blue,
                                child: postCheckIn(context),
                                onPressed: () async {
                                  if (_selectedProject.toString() ==
                                          'Choose Project' ||
                                      _selectedProject == null &&
                                          _addressController.text.isEmpty &&
                                          _commentController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Please Choose a Project'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else if (latitudeData.toString() ==
                                          null.toString() &&
                                      longitudeData.toString() ==
                                          null.toString()) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Please On your location and start again'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else {
                                    if (checkIn) {
                                      if (!await context
                                          .read<UserProvider>()
                                          .checkIn(
                                              data.empid.toString(),
                                              newSelectedProject.toString(),
                                              projectId.toString(),
                                              DateTime.now(),
                                              // DateFormat.Hm().format(DateTime.now()),
                                              _addressController.text,
                                              _commentController.text,
                                              latitudeData.toString(),
                                              latitudeData.toString())) {
                                        switch (context
                                            .read<UserProvider>()
                                            .checkInState) {
                                          case CheckInState.initial:
                                          case CheckInState.loading:
                                          case CheckInState.complete:
                                          case CheckInState.error:
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('Could not Check in'),
                                              duration: Duration(seconds: 2),
                                            ));
                                        }
                                      } else {
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .checkInOutUser();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Check In'),
                                          duration: Duration(seconds: 2),
                                        ));
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Project not available in this location'),
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                  }
                                });
                          }),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

Widget postCheckIn(BuildContext context) {
  switch (context.watch<UserProvider>().checkInState) {
    case CheckInState.initial:
      return Text(
        'Check In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckInState.loading:
      return Row(children: [
        CircularProgressIndicator(),
        Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
        )
      ]);
    case CheckInState.error:
      return Text(
        'Check In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckInState.complete:
      return Text(
        'Check In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
  }
}
