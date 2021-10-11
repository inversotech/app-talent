import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';

class ShowLoadingIndicator {
  static showLoadingIndicator(
      {required BuildContext context,
      String text = '',
      bool onlyLoading = false,
      bool opacity: true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor:
          onlyLoading && !opacity ? Colors.transparent : Colors.black45,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    color: onlyLoading ? Colors.transparent : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _loadingIndicator(text, onlyLoading),
                ),
              ),
            ));
      },
    );
  }

  static Widget _loadingIndicator(String text, bool onlyLoading) {
    return Container(
        color: onlyLoading ? Colors.transparent : null,
        padding: EdgeInsets.all(16),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _getLoadingIndicator(onlyLoading),
              !onlyLoading ? _getText(text) : Container()
            ]));
  }

  static Widget _getLoadingIndicator(bool onlyLoading) {
    return Container(
        color: onlyLoading ? Colors.transparent : null,
        child: CircularProgressIndicator(
            color: onlyLoading ? ColorsApp.primary : null),
        width: 32,
        height: 32);
  }

  static Widget _getText(String displayedText) {
    return Text(
      displayedText,
      style: TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
