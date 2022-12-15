import 'package:flutter/foundation.dart';
import 'package:lamb_talent/enviroment/models.dart';
import 'package:lamb_talent/enviroment/vhosts.dart';

class Env {
  static VHost api = kDebugMode ? Api().apiDev : Api().apiProd;
}
