import 'package:get/get.dart';
import 'package:lamb_talent/ui/modules/auth/login_page.dart';
import 'package:lamb_talent/ui/modules/auth/verify_authentication_page.dart';
import 'package:lamb_talent/ui/modules/home/home_page.dart';

import 'routers_names.dart';

getRouters() {
  List<GetPage> routesApp = [
    GetPage(name: RoutesName.checkAuth, page: () => const VerifyPage()),
    GetPage(name: RoutesName.login, page: () => LoginPage()),
    GetPage(name: RoutesName.home, page: () => HomePage()),
  ];
  return routesApp;
}
