import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class VerifyAutheticationController extends GetxController {
  final _authService = AuthService();

  @override
  void onReady() {
    _validToken();
    super.onReady();
  }

  void _validToken() async {
    final storage = GetStorage();
    final token = storage.read('tokenLamb');
    if (token != null && token.isNotEmpty) {
      Map<String, String> params = {};
      final userPref = UserPreferences();
      final apiProvider = ApiProvider();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (userPref.tokenNotify.isNotEmpty) {
        OneSignal.login(userPref.tokenNotify);
        params['token_notify'] = userPref.tokenNotify;
      }
      String deviceId = '';
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id;
        params['uuid'] = deviceId; //UUID for Android by pedro
        // params['uuid'] = androidInfo.androidId!; //UUID for Android
        params['model'] = androidInfo.model;
        params['platform'] = Platform.operatingSystem;
        params['id_app'] = '5';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        params['uuid'] = deviceId; //UUID for iOS
        params['model'] = iosInfo.model!;
        params['platform'] = Platform.operatingSystem;
        params['id_app'] = '6';
      }
      params['device_source'] = 'APP_UPN';
      final response = await apiProvider.postParams(
          endPoint: endPoints['oauth']['valid-tokens-oauth'],
          params: params,
          showMessage: false);
      if (response.success) {
        final resp = await _authService.userInfo();
        if (resp.success) {
          if (userPref.menu!.isNotEmpty && userPref.existNotify == false) {
            Get.offAllNamed(userPref.menu![0].url.toString());
          } else {
            if (userPref.menu!.isNotEmpty &&
                userPref.existNotify == true &&
                userPref.routeNotify.isNotEmpty) {
              Get.offAllNamed(userPref.routeNotify);
            } else {
              userPref.existNotify = false;
              Get.offAllNamed(RoutesName.login);
              Get.snackbar('Mensaje:', 'No tiene acceso a ningún item.',
                  duration: const Duration(seconds: 10),
                  colorText: ColorsApp.danger,
                  backgroundColor: ColorsApp.white);
            }
          }
        } else {
          Get.offAllNamed(RoutesName.login);
        }
      } else {
        Get.offAllNamed(RoutesName.login);
      }
    } else {
      Get.offAllNamed(RoutesName.login);
    }
  }

/*   void _clearStorage() {
    final storage = GetStorage();
    storage.remove('tokenLamb');
  } */
}
