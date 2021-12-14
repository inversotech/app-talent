import 'package:get/get.dart';
import 'package:lamb_talent/core/end_points.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/resources/providers/api.provider.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';

class VerifyAutheticationController extends GetxController {
  final _authService = AuthService();
  @override
  void onInit() {
    _validToken();
    super.onInit();
  }

  void _validToken() async {
    final _apiProvider = ApiProvider();
    final response = await _apiProvider.postParams(
        endPoint: endPoints['oauth']['valid-tokens-oauth'],
        params: {},
        showMessage: false);
    _apiProvider.dispose();
    if (response.success) {
      final resp = await _authService.userInfo();
      if (resp.success) {
        Get.offAllNamed(RoutesName.home);
      } else {
        Get.offAllNamed(RoutesName.login);
      }
    } else {
      Get.offAllNamed(RoutesName.login);
    }
  }
}
