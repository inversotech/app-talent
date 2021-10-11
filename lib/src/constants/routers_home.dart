import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/home/home_page.dart';

getRoutersHome() {
  return {
    RoutesName.home: (BuildContext context) => HomePage()
  };
}
