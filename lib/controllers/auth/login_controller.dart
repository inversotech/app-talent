import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();
  final FocusNode focusPassword = FocusNode();
  final _authService = AuthService();
  RxBool obscureText = true.obs;
  @override
  void onInit() {
    obscureText.value = true;
    _clearStorage();
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
    Map<String, String> params = {
      'username': username.text.toString(),
      'password': password.text.toString(),
      'no_caduca': 'S'
    };
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String serial = '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      params['uuid'] = androidInfo.androidId; //UUID for Android
      params['model'] = androidInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['version'] = androidInfo.version.release;
      params['manufacturer'] = androidInfo.manufacturer;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      params['uuid'] = iosInfo.identifierForVendor; //UUID for iOS
      params['model'] = iosInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['version'] = iosInfo.systemVersion;
      params['manufacturer'] = iosInfo.systemName;
    }
    params['serial'] = serial;
    params['isvirtual'] = '';
    params['device_source'] = 'APP_UPN';
    loadingIndicator(onlyLoading: true, opacity: false);
  final _apiProvider = ApiProvider();
    final resp = await _apiProvider.loginLamb(params);
    _apiProvider.dispose();

    if (resp.success) {
      final resp = await _authService.userInfo();
      if (resp.success) {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.offAllNamed(RoutesName.home);
      }
    }
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void _clearStorage() {
    final storage = GetStorage();
    storage.remove('tokenLamb');
  }
}
