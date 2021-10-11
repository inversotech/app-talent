import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
}
