import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/constants/routers_names.dart';
import 'package:upn_financiero_mobil/src/pages/account_status/account_status_page.dart';

getRoutersAccountStatus() {
  return {
    RoutesName.accountStatus: (BuildContext context) => AccountStatusPage(),
    
  };
}
