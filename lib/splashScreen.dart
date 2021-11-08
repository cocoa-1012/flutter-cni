import 'dart:async';

// import 'package:cni_app/homePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Api/helper.dart';
import 'LoginScreen.dart';
import 'homePage.dart';

// import 'homePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  Api api = Api();
  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userStatus = prefs.containsKey('token');
    if (userStatus) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }
  }

  Future<void> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var response = await api.getUser(token);
    // final responseJson = json.decode(response.body);
    if (response.statusCode == 401) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      return null;
    }
    if (response.statusCode == 422) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      return null;
    }
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              // LoginScreen()
              HomePage()));
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              flex: 20,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                      'asset/images/logo.png',
                    ),
                    fit: BoxFit.fitWidth,
                    // fit: BoxFit.cover,
                  ),
                  // shape: BoxShape.circle,
                ),
              ),
            ),
            // Expanded(
            //     flex: 1,
            //     child: Text(
            //       'CNI App',
            //       style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            //     ))
          ]),
        ));
  }
}
//
