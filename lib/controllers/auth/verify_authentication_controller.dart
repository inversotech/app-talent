import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class VerifyAutheticationController extends GetxController {
  final _authService = AuthService();
  @override
  void onInit() {
    _validToken();
    super.onInit();
  }

  void _validToken() async {
    final _userPref = UserPreferences();
    if (_userPref.tokenNotify.isNotEmpty) {
      final _apiProvider = ApiProvider();
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      OneSignal.shared.setExternalUserId(_userPref.tokenNotify);
      Map<String, String> params = {'token_notify': _userPref.tokenNotify};
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        params['uuid'] = androidInfo.id; //UUID for Android by pedro
        // params['uuid'] = androidInfo.androidId!; //UUID for Android
        params['model'] = androidInfo.model;
        params['platform'] = Platform.operatingSystem;
        params['id_app'] = '5';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        params['uuid'] = iosInfo.identifierForVendor!; //UUID for iOS
        params['model'] = iosInfo.model!;
        params['platform'] = Platform.operatingSystem;
        params['id_app'] = '6';
      }
      params['device_source'] = 'APP_UPN';
      final response = await _apiProvider.postParams(
          endPoint: endPoints['oauth']['valid-tokens-oauth'],
          params: params,
          showMessage: false);
      //_apiProvider.dispose();
      if (response.success) {
        final resp = await _authService.userInfo();
        if (resp.success) {
          if (_userPref.menu!.isNotEmpty) {
            Get.offAllNamed(_userPref.menu![0].url.toString());
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
}
