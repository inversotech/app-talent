import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/justification/justification_page.dart';

getRoutersJustification() {
  return {
    RoutesName.justifications: (BuildContext context) => JustificationPage(),
  };
}
