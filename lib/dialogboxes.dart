import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCupertinoDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Error'),
          ),
          content: Text('Hey! Please select Month and Week'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close')),
            TextButton(
              onPressed: () {
                // print('HelloWorld!');
                Navigator.pop(context);
              },
              child: Text('Okay!'),
            )
          ],
        );
      });
}
