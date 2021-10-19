import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_justification.dart';
import 'package:upn_financiero_mobil/src/constants/routers_license_permit.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/constants/routers_report.dart';
import 'package:upn_financiero_mobil/src/pages/auth/login/login.dart';
import 'package:upn_financiero_mobil/src/pages/pages.dart';
import 'package:upn_financiero_mobil/src/constants/routers_account_status.dart';
import 'package:upn_financiero_mobil/src/constants/routers_home.dart';

/* void getPage(String route) {
  var page = null;
  switch (route) {
    case Routes.home:
      page = HomePage();
      break;
    case Routes.dashboard:
      page = DashboardPage();
      break;
    case Routes.accountStatusTabs:
      page = AccountStatusTabsPage();
      break;
    case Routes.accountStatus:
      page = AccountStatusPage();
      break;
    default:
      page = HomePage();
      break;
  }
  return page;
} */

getRouters() {
  /* return {
    'login': (BuildContext context) => LoginPage(),
    'dashboard': (BuildContext context) => DashboardPage(),
    'home': (BuildContext context) => HomePage(),
    'account-status': (BuildContext context) => AccountStatusPage(),
  }; */
  Map<String, Widget Function(BuildContext)> routesApp = {
    RoutesName.check_auth: (BuildContext context) => CheckAuthPage(),
    RoutesName.login: (BuildContext context) => LoginPage(),
  };
  routesApp.addAll(getRoutersHome());
  routesApp.addAll(getRoutersAccountStatus());
  routesApp.addAll(getRoutersReport());
  routesApp.addAll(getRoutersJustification());
  routesApp.addAll(getRoutersLicensePermit());

  return routesApp;
}
