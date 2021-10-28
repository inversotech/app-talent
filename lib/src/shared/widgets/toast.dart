import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastCustom {
  void success(
      {required String message,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 16.0}) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.green[900],
        textColor: Colors.white,
        fontSize: fontSize,
      );
    }
  }

  void successContext(
      {required String message,
      required BuildContext context,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 14.0}) {
    if (message.isNotEmpty) {
      FToast fToast = FToast();
      fToast.init(context);
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.green[900],
        ),
        child: Text(
          message,
          style:
              GoogleFonts.montserrat(color: Colors.white, fontSize: fontSize),
        ),
      );
      fToast.showToast(
          child: toast,
          gravity: gravity,
          toastDuration: Duration(seconds: time));
    }
  }

  void danger(
      {required String message,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 16.0}) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: fontSize,
      );
    }
  }

  void dangerContext(
      {required String message,
      required BuildContext context,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 14.0}) {
    if (message.isNotEmpty) {
      FToast fToast = FToast();
      fToast.init(context);
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.red,
        ),
        child: Text(
          message,
          style:
              GoogleFonts.montserrat(color: Colors.white, fontSize: fontSize),
        ),
      );
      fToast.showToast(
          child: toast,
          gravity: gravity,
          toastDuration: Duration(seconds: time));
    }
  }

  void warning(
      {required String message,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 16.0}) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: fontSize,
      );
    }
  }

  void warningContext(
      {required String message,
      required BuildContext context,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 14.0}) {
    if (message.isNotEmpty) {
      FToast fToast = FToast();
      fToast.init(context);
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.orange,
        ),
        child: Text(
          message,
          style:
              GoogleFonts.montserrat(color: Colors.white, fontSize: fontSize),
        ),
      );
      fToast.showToast(
          child: toast,
          gravity: gravity,
          toastDuration: Duration(seconds: time));
    }
  }

  void primary(
      {required String message,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 16.0}) {
    if (message.isNotEmpty) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: time,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: fontSize,
      );
    }
  }

  void primaryContext(
      {required String message,
      required BuildContext context,
      gravity = ToastGravity.TOP,
      time = 5,
      fontSize = 14.0}) {
    if (message.isNotEmpty) {
      FToast fToast = FToast();
      fToast.init(context);
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.blue,
        ),
        child: Text(
          message,
          style:
              GoogleFonts.montserrat(color: Colors.white, fontSize: fontSize),
        ),
      );
      fToast.showToast(
          child: toast,
          gravity: gravity,
          toastDuration: Duration(seconds: time));
    }
  }
}
