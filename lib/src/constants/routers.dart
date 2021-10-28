import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/auth/login/login.dart';
import 'package:upn_financiero_mobil/src/pages/pages.dart';

getRouters() {

  Map<String, Widget Function(BuildContext)> routesApp = {
    RoutesName.check_auth: (BuildContext context) => CheckAuthPage(),
    RoutesName.login: (BuildContext context) => LoginPage(),
  };
  return routesApp;
}
