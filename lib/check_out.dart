import 'package:cni_app/provider/project_Provider.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'color.dart';

class CheckOut extends StatefulWidget {
  CheckOut({Key? key}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  String? latitudeData;
  String? longitudeData;
  Future getLocation() async {
    try {
      Location location = new Location();
      bool _serviceEnabled;

      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
      setState(() {
        latitudeData = _locationData.longitude.toString();
        longitudeData = _locationData.latitude.toString();
      });

      // print('thsi si long data $longitude_data');
      // print('thsi si long data $latitude_data');
    } catch (e) {
      print(e);
    }
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
            'Check Out',
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Consumer<UserProvider>(builder: (_, userdata, child) {
              var data = userdata.checkData;
              // print(data.id);
              return Expanded(
                flex: 10,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30.0),
                    child: ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Project:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Address:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Time:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${data.projectName == null ? 'loading...' : data.projectName}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${data.checkinAddress == null ? 'loading...' : data.checkinAddress}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${data.checkinTime == null ? 'loading...' : DateTime.now()}',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                            controller: _commentController,
                            toolbarOptions: ToolbarOptions(
                                copy: false, cut: false, paste: false),
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
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blue)),
                                color: Colors.blue,
                                child: postCheckIn(context),
                                onPressed: () async {
                                  if (latitudeData.toString() ==
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
                                    if (!await context
                                        .read<UserProvider>()
                                        .checkOut(
                                            DateTime.now().toString(),
                                            '${data.checkinAddress}',
                                            _commentController.text,
                                            latitudeData.toString(),
                                            latitudeData.toString())) {
                                      switch (context
                                          .read<UserProvider>()
                                          .checkOutState) {
                                        case CheckOutState.initial:
                                        case CheckOutState.loading:
                                        case CheckOutState.complete:
                                        case CheckOutState.error:
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Could not be added'),
                                            duration: Duration(seconds: 5),
                                          ));
                                      }
                                    } else {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .getUserProfile();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Check out'),
                                        duration: Duration(seconds: 5),
                                      ));
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .checkInOutUser();
                                      Navigator.pop(context);
                                    }
                                  }
                                }),
                          ),
                        )
                      ],
                    )),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget postCheckIn(BuildContext context) {
  switch (context.watch<UserProvider>().checkOutState) {
    case CheckOutState.initial:
      return Text(
        'Check Out',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckOutState.loading:
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
    case CheckOutState.error:
      return Text(
        'Check Out',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckOutState.complete:
      return Text(
        'Check Out',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
  }
}
