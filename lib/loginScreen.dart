// import 'dart:ffi';

import 'package:cni_app/color.dart';
import 'package:cni_app/homePage.dart';
import 'package:cni_app/provider/project_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Api/helper.dart';
// import 'color.dart';
import 'widget/otp_widgey.dart';

enum EmaiSigninForm { signIn, register }

class Users {
  Users({required this.uid});
  final String uid;
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtController1 = TextEditingController();
  TextEditingController txtController2 = TextEditingController();
  TextEditingController txtController3 = TextEditingController();
  TextEditingController txtController4 = TextEditingController();
  TextEditingController txtController5 = TextEditingController();
  TextEditingController txtController6 = TextEditingController();
  Api api = Api();
  Future<void> _makephoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not Dail Number try again later'),
        duration: Duration(seconds: 5),
      ));
    }
  }

  @override
  void initState() {
    checkFBMTokens();
    super.initState();
  }

  Future checkFBMTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkTokensFBM = prefs.getString('deviceToken');
    var response = await api.checkFirstToken(checkTokensFBM.toString());
    print(
        'This is status Code ${response.statusCode}and toke n $checkTokensFBM');
    if (response.statusCode == 422) {
      _makephoneCall(
          'mailto:admin.app@cnitech.info?subject=Login Token&body=Firebase Device token \n\n $checkTokensFBM');
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    }
    // return false;
  }

  @override
  Widget build(BuildContext context) {
    // final primaryText = 'Sign In';
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor.fromHex('#ffffff'),
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Colors.black, //change your color here
        //   ),
        //   backgroundColor: HexColor.fromHex('#FFF4E1'),
        //   elevation: 3,
        //   centerTitle: true,
        //   title: Text(
        //     'Sign In',
        //     style: TextStyle(fontSize: 24.0, color: Colors.black),
        //   ),
        // ),
        body: Stack(
          // fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 40.0, horizontal: 20.0),
                            child: new Image.asset(
                              'asset/images/logo.png',
                              width: 200,
                              height: 200,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                otpTextField1(context, true, txtController1),
                                SizedBox(
                                  width: 2.0,
                                ),
                                otpTextField(context, true, txtController2),
                                SizedBox(
                                  width: 2.0,
                                ),
                                otpTextField(context, true, txtController3),
                                SizedBox(
                                  width: 2.0,
                                ),
                                otpTextField(context, true, txtController4),
                                SizedBox(
                                  width: 2.0,
                                ),
                                otpTextField(context, true, txtController5),
                                SizedBox(
                                  width: 1.0,
                                ),
                                otpTextField3(context, true, txtController6),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            height: 44.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: txtController1.text.isEmpty ||
                                        txtController2.text.isEmpty ||
                                        txtController3.text.isEmpty ||
                                        txtController4.text.isEmpty ||
                                        txtController5.text.isEmpty ||
                                        txtController6.text.isEmpty
                                    ? Colors.grey
                                    : Colors.indigo,
                                borderRadius: BorderRadius.circular(4.0)),
                            // ignore: deprecated_member_use
                            child: FlatButton(
                                onPressed: txtController1.text.isEmpty ||
                                        txtController2.text.isEmpty ||
                                        txtController3.text.isEmpty ||
                                        txtController4.text.isEmpty ||
                                        txtController5.text.isEmpty ||
                                        txtController6.text.isEmpty
                                    ? null
                                    : () async {
                                        if (!await context
                                            .read<UserProvider>()
                                            .checkPin(txtController1.text
                                                    .toString()
                                                    .trim() +
                                                txtController2.text
                                                    .toString()
                                                    .trim() +
                                                txtController3.text
                                                    .toString()
                                                    .trim() +
                                                txtController4.text
                                                    .toString()
                                                    .trim() +
                                                txtController5.text
                                                    .toString()
                                                    .trim() +
                                                txtController6.text
                                                    .toString()
                                                    .trim())) {
                                          switch (context
                                              .read<UserProvider>()
                                              .checkPinState) {
                                            case CheckPinState.initial:
                                            case CheckPinState.loading:
                                            case CheckPinState.complete:
                                            case CheckPinState.error:
                                              print('Token Not Found');
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String deviceToken = prefs
                                                  .getString("deviceToken")
                                                  .toString();
                                              _makephoneCall(
                                                  'mailto:admin.app@cnitech.info?subject=Login Token&body=Firebase Device token \n\n $deviceToken');
                                          }
                                        } else {
                                          if (!await context
                                              .read<UserProvider>()
                                              .login(txtController1.text
                                                      .toString()
                                                      .trim() +
                                                  txtController2.text
                                                      .toString()
                                                      .trim() +
                                                  txtController3.text
                                                      .toString()
                                                      .trim() +
                                                  txtController4.text
                                                      .toString()
                                                      .trim() +
                                                  txtController5.text
                                                      .toString()
                                                      .trim() +
                                                  txtController6.text
                                                      .toString()
                                                      .trim())) {
                                            switch (context
                                                .read<UserProvider>()
                                                .loginState) {
                                              case LoginState.initial:
                                              case LoginState.loading:
                                              case LoginState.complete:
                                              case LoginState.error:
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .getMessage
                                                          .toString()),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                            }
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String deviceToken = prefs
                                                .getString("deviceToken")
                                                .toString();
                                            _makephoneCall(
                                                'mailto:admin.app@cnitech.info?subject=Login Token&body=Firebase Device token \n\n $deviceToken');
                                          } else {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                        }
                                      },
                                child: Provider.of<UserProvider>(context)
                                            .checkPinText ==
                                        true
                                    ? postLogin(context)
                                    : verifyPin(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                  alignment: Alignment.bottomCenter, child: Text('CNI App V3')),
            )
          ],
        ),
      ),
    );
  }
}

Widget postLogin(BuildContext context) {
  switch (context.watch<UserProvider>().loginState) {
    case LoginState.initial:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case LoginState.loading:
      return Row(children: [
        CircularProgressIndicator(),
        Text(
          'Authenticating...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
        )
      ]);
    case LoginState.error:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case LoginState.complete:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
  }
}

Widget verifyPin(BuildContext context) {
  switch (context.watch<UserProvider>().checkPinState) {
    case CheckPinState.initial:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckPinState.loading:
      return Row(children: [
        CircularProgressIndicator(),
        Text(
          'Authenticating...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'SourceSansPro',
          ),
        )
      ]);
    case CheckPinState.error:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
    case CheckPinState.complete:
      return Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'SourceSansPro',
        ),
      );
  }
}
// https://stackoverflow.com/questions/64162523/how-to-keep-user-logged-in-in-flutter
