import 'package:flutter/material.dart';

Widget otpTextField(
    BuildContext context, bool autoFocus, TextEditingController controller) {
  return Container(
    height: MediaQuery.of(context).size.shortestSide * 0.13,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      shape: BoxShape.rectangle,
    ),
    child: AspectRatio(
      aspectRatio: 1,
      child: TextField(
        toolbarOptions: ToolbarOptions(copy: false, cut: false, paste: false),
        obscureText: true,
        controller: controller,
        maxLength: 1,
        autofocus: autoFocus,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 18),
        maxLines: 1,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length <= 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    ),
  );
}

Widget otpTextField2(
    BuildContext context, bool autoFocus, TextEditingController controller) {
  return Container(
    height: MediaQuery.of(context).size.shortestSide * 0.11,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.15)),
      borderRadius: BorderRadius.circular(5),
      color: Colors.red,
      shape: BoxShape.rectangle,
    ),
    child: AspectRatio(
      aspectRatio: 1,
      child: TextField(
        toolbarOptions: ToolbarOptions(copy: false, cut: false, paste: false),
        controller: controller,
        maxLength: 1,
        autofocus: autoFocus,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white, fontSize: 18),
        maxLines: 1,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.length <= 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    ),
  );
}

Widget otpTextField3(
    BuildContext context, bool autoFocus, TextEditingController controller) {
  return Container(
    height: MediaQuery.of(context).size.shortestSide * 0.13,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      shape: BoxShape.rectangle,
    ),
    child: AspectRatio(
      aspectRatio: 1,
      child: TextField(
        toolbarOptions: ToolbarOptions(copy: false, cut: false, paste: false),
        obscureText: true,
        controller: controller,
        maxLength: 1,
        autofocus: autoFocus,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 18),
        maxLines: 1,
        onChanged: (value) {
          // if (value.length == 1) {
          //   FocusScope.of(context).nextFocus();
          // }
          if (value.length <= 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    ),
  );
}

Widget otpTextField1(
    BuildContext context, bool autoFocus, TextEditingController controller) {
  return Container(
    height: MediaQuery.of(context).size.shortestSide * 0.13,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      shape: BoxShape.rectangle,
    ),
    child: AspectRatio(
      aspectRatio: 1,
      child: TextField(
        toolbarOptions: ToolbarOptions(copy: false, cut: false, paste: false),
        obscureText: true,
        controller: controller,
        maxLength: 1,
        autofocus: autoFocus,
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: 18),
        maxLines: 1,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    ),
  );
}
