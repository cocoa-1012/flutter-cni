import 'package:cni_app/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppBar appbar(
  context,
  title,
) {
  final _firebaseAuth = FirebaseAuth.instance;
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15.0, top: 8.0),
        child: InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('uid');
              await _firebaseAuth.signOut().then((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              });
            },
            child: Icon(Icons.logout)),
      )
    ],
    centerTitle: true,
    // title:
  );
}
