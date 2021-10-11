import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/license_permit/license_permit_page.dart';

getRoutersLicensePermit() {
  return {
    RoutesName.licensePermit: (BuildContext context) => LicensePermitPage(),
  };
}
