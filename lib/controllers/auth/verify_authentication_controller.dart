import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';

class VerifyAutheticationController extends GetxController {
  final _authService = AuthService();
  @override
  void onInit() {
    // _clearStorage();
    _validToken();
    super.onInit();
  }

  void _validToken() async {
    Map<String, String> params = {};
    final userPref = UserPreferences();
    final apiProvider = ApiProvider();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (userPref.tokenNotify.isNotEmpty) {
      OneSignal.shared.setExternalUserId(userPref.tokenNotify);
      params['token_notify'] = userPref.tokenNotify;
    }
    String deviceId = await PlatformDeviceId.getDeviceId ?? '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      params['uuid'] = deviceId; //UUID for Android by pedro
      // params['uuid'] = androidInfo.androidId!; //UUID for Android
      params['model'] = androidInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['id_app'] = '5';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
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
        if (userPref.menu!.isNotEmpty) {
          Get.offAllNamed(userPref.menu![0].url.toString());
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
