import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/location_user.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  RxBool checkCredencial = false.obs;
  final FocusNode focusPassword = FocusNode();
  final _authService = AuthService();
  RxBool obscureText = true.obs;
  @override
  void onInit() {
    obscureText.value = true;

    _clearStorage();
    _dataUserStorage();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    focusPassword.dispose();
    super.dispose();
  }

  void loginLamb(BuildContext buildContext) async {
    LocationUser().initLocationUser();
    Map<String, String> params = {
      'username': username.text.toString(),
      'password': password.text.toString(),
      'no_caduca': 'S'
    };
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final _userPref = UserPreferences();
    String serial = '';
    OneSignal.shared.setExternalUserId(_userPref.tokenNotify);
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      params['uuid'] = androidInfo.id; //UUID for Android by pedro
      // params['uuid'] = androidInfo.androidId!; //UUID for Android
      params['model'] = androidInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['version'] = androidInfo.version.release;
      params['manufacturer'] = androidInfo.manufacturer;
      params['id_app'] = '5';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      params['uuid'] = iosInfo.identifierForVendor!; //UUID for iOS
      params['model'] = iosInfo.model!;
      params['platform'] = Platform.operatingSystem;
      params['version'] = iosInfo.systemVersion!;
      params['manufacturer'] = iosInfo.systemName!;
      params['id_app'] = '6';
    }
    params['serial'] = serial;
    params['isvirtual'] = '';
    params['device_source'] = 'APP_UPN';
    params['token_notify'] = _userPref.tokenNotify;
    loadingIndicator(onlyLoading: true, opacity: false);
    final _apiProvider = ApiProvider();
    final resp = await _apiProvider.loginLamb(params, checkCredencial.value);
    //_apiProvider.dispose();

    if (resp.success) {
      final resp = await _authService.userInfo();
      if (resp.success) {
        Get.until((route) => !Get.isDialogOpen!);
        if (_userPref.menu!.isNotEmpty) {
          Get.offAllNamed(_userPref.menu![0].url.toString());
        }
      }
    }
    Get.until((route) => !Get.isDialogOpen!);
  }

  void _clearStorage() {
    final storage = GetStorage();
    storage.remove('tokenLamb');
  }

  void _dataUserStorage() {
    final storage = GetStorage();
    if (storage.read('usernameLamb') != null &&
        storage.read('usernameLamb') != '') {
      username.value = TextEditingValue(text: storage.read('usernameLamb'));
      password.value = TextEditingValue(text: storage.read('passwordLamb'));
    }
  }
}
