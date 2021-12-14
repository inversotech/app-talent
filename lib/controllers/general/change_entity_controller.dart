import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/routers_names.dart';
import 'package:lamb_talent/resources/models/general/deparment.dart';
import 'package:lamb_talent/resources/models/general/entity.dart';
import 'package:lamb_talent/resources/services/auth/auth_service.dart';
import 'package:lamb_talent/resources/services/general/deparments_service.dart';
import 'package:lamb_talent/resources/services/general/entity_service.dart';

class ChangeEntityController extends GetxController {
  TextEditingController inputFieldEntity = TextEditingController();
  TextEditingController inputFieldDepto = TextEditingController();
  List<Entity> listEntitiesG = [];
  List<Deparment> listMyDeptosG = [];
  List<Map<String, dynamic>> listMyDeptos = [];
  List<Map<String, dynamic>> listMyEntities = [];
  RxBool loadingEntities = false.obs;
  RxBool loadingDeptos = false.obs;

  @override
  void onReady() {
    getEntities();
    super.onReady();
  }

  void getEntities() async {
    loadingEntities.value = true;
    final _entityService = EntityService();
    final list = await _entityService.getListMyEntities();
    listMyEntities = [];
    for (var element in list) {
      listMyEntities.add({
        'value': element.idEntidad,
        'label': element.nombre,
        'icon': null,
      });
    }
    listEntitiesG = list;

    loadingEntities.value = false;
  }

  void fnGetDeptos(String val) async {
    listMyDeptos = [];
    loadingDeptos.value = true;
    final _deparmentService = DeparmentsService();
    List<Deparment> list = await _deparmentService
        .getListMyDeparments({'id_entidad': val.toString()});
    listMyDeptosG = list;
    for (var element in list) {
      listMyDeptos.add({
        'value': element.idDepto,
        'label': element.nombre,
        'icon': null,
      });
    }
    loadingDeptos.value = false;
  }

  void saveNewEntityDepto(BuildContext buildContext) async {
    Map<String, String> params = {
      'id_entidad': inputFieldEntity.text.toString(),
      'id_depto': inputFieldDepto.text.toString()
    };
    final _authService = AuthService();
    final response = await _authService.changeEntityDepto(params);
    if (response.success) {
      Get.offAllNamed(RoutesName.checkAuth);
    }
  }
}
