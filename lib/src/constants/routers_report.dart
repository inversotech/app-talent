import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/markings/my_markings_page.dart';

getRoutersReport() {
  return {
    RoutesName.myMarkings: (BuildContext context) => MyMarkingsPage(),
  };
}
