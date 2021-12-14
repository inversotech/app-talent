import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';

loadingIndicator(
    {bool opacity = true, bool onlyLoading = true, String text = ''}) async {
  Get.dialog(_showLoadingIndicator(onlyLoading, text),
      barrierDismissible: false,
      barrierColor:
          onlyLoading && !opacity ? Colors.transparent : Colors.black45);
}

Widget _showLoadingIndicator(bool onlyLoading, String text) {
  return WillPopScope(
      onWillPop: () async => true,
      child: Center(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
              color: onlyLoading ? Colors.transparent : Colors.white,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _loadingIndicator(text, onlyLoading),
          ),
        ),
      ));
}

Widget _loadingIndicator(String text, bool onlyLoading) {
  return Container(
      color: onlyLoading ? Colors.transparent : null,
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getLoadingIndicator(onlyLoading),
            !onlyLoading ? _getText(text) : Container()
          ]));
}

Widget _getLoadingIndicator(bool onlyLoading) {
  return Container(
      color: onlyLoading ? Colors.transparent : null,
      child: CircularProgressIndicator(
          color: onlyLoading ? ColorsApp.primary : null),
      width: 32,
      height: 32);
}

Widget _getText(String displayedText) {
  return Text(
    displayedText,
    style: const TextStyle(fontSize: 14),
    textAlign: TextAlign.center,
  );
}
