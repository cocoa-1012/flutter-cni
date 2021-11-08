import 'package:cni_app/project_ot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'asset.dart';
import 'check_in.dart';
import 'check_out.dart';
import 'color.dart';
import 'loginScreen.dart';
import 'material_out.dart';
import 'provider/project_Provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    Provider.of<UserProvider>(context, listen: false).checkInOutUser();
    Provider.of<UserProvider>(context, listen: false).getUserProfile();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor.fromHex('#ffffff'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: InkWell(
                                  onTap: () {
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .logout()
                                        .then((_) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                          (Route<dynamic> route) => false);
                                    });
                                  },
                                  child: Text("Logout")),
                            ),
                          ]),
                  Icon(Icons.notification_important),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: new Image.asset(
                  'asset/images/logo.png',
                  width: 150,
                )),
            Consumer<UserProvider>(builder: (_, userdata, child) {
              return Padding(
                  padding: EdgeInsets.only(bottom: 30.0, top: 5.0),
                  child: Text(
                    '${userdata.userModel.firstName} ${userdata.userModel.lastName}',
                    style: TextStyle(fontSize: 40),
                  ));
            }),
            Consumer<UserProvider>(builder: (_, userdata, child) {
              var data = userdata.checkData;
              var userprofile = userdata.userModel;
              return Expanded(
                flex: 10,
                child: Container(
                  // color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 30.0),
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    shrinkWrap: true,
                    children: <Widget>[
                      data.checkoutTime == null && data.checkinTime != null
                          ? new GridTile(
                              child: InkWell(
                                onTap: () {
                                  // Provider.of<UserProvider>(context,
                                  //                 listen: false)
                                  //             .firstVale ==
                                  //         null
                                  //     ? ScaffoldMessenger.of(context)
                                  //         .showSnackBar(SnackBar(
                                  //         content: Text('Wait...'),
                                  //         duration: Duration(seconds: 5),
                                  //       ))
                                  //     : Provider.of<UserProvider>(context,
                                  //                     listen: false)
                                  //                 .firstVale ==
                                  //             'true Value'
                                  //         ?
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CheckOut()));
                                  // : ScaffoldMessenger.of(context)
                                  //     .showSnackBar(SnackBar(
                                  //     content: Text(
                                  //         'You Location is too far from Project Location'),
                                  //     duration: Duration(seconds: 5),
                                  //   ));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10.0),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 1, color: Colors.blue)),
                                      child: Icon(
                                        Icons.model_training_sharp,
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text('Check-Out'))
                                  ],
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                // Provider.of<UserProvider>(context,
                                //                 listen: false)
                                //             .firstVale ==
                                //         null
                                //     ? ScaffoldMessenger.of(context)
                                //         .showSnackBar(SnackBar(
                                //         content: Text('Wait...'),
                                //         duration: Duration(seconds: 5),
                                //       ))
                                //     : Provider.of<UserProvider>(context,
                                //                     listen: false)
                                //                 .firstVale ==
                                //             'true Value'
                                //         ?
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckIn()));

                                // : ScaffoldMessenger.of(context)
                                //     .showSnackBar(SnackBar(
                                //     content: Text(
                                //         'You Location is too far from Project Location'),
                                //     duration: Duration(seconds: 5),
                                //   ));
                              },
                              child: new GridTile(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 1, color: Colors.black12)),
                                      child: Icon(
                                        Icons.add_location_sharp,
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Check-In'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                      // : Tex,t('Location is too far from Project'),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MaterialOut()));
                        },
                        child: new GridTile(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black12)),
                                child: Icon(
                                  Icons.work_outline,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('Materials'))
                            ],
                          ),
                        ),
                      ),
                      userprofile.role == 'Workers'
                          ? SizedBox()
                          : userprofile.role == 'Supervisors' ||
                                  userprofile.role == 'Engineers' ||
                                  userprofile.role == 'Managers' ||
                                  userprofile.role == 'Admins' ||
                                  userprofile.role == 'Sales'
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AssetScreen()));
                                  },
                                  child: new GridTile(
                                    child: new Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black12)),
                                          child: Icon(
                                            Icons.settings,
                                            color: Colors.white,
                                            size: 50.0,
                                          ),
                                        ),
                                        Container(
                                            margin:
                                                EdgeInsets.only(right: 10.0),
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text('Assets'))
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                      userprofile.role == 'Workers' ||
                              userprofile.role == 'Supervisors'
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProjectOt()));
                              },
                              child: new GridTile(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 1, color: Colors.black12)),
                                      child: Icon(
                                        Icons.calendar_today_rounded,
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text('Project OT'))
                                  ],
                                ),
                              ),
                            ),
                      userprofile.role == 'Workers' ||
                              userprofile.role == 'Supervisors'
                          ? SizedBox()
                          : new GridTile(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 1, color: Colors.black12)),
                                    child: Icon(
                                      Icons.work_outline,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Coming Soon'))
                                ],
                              ),
                            ),
                      userprofile.role == 'Workers' ||
                              userprofile.role == 'Supervisors'
                          ? SizedBox()
                          : new GridTile(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 1, color: Colors.black12)),
                                    child: Icon(
                                      Icons.work_outline,
                                      color: Colors.white,
                                      size: 50.0,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Coming Soon'))
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
