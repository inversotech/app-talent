
import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';


class DeparmentsNotifierService with ChangeNotifier {
  UserPreferences _prefs = new UserPreferences();
  DeparmentsService deparmentsService = new DeparmentsService();
  AccountStatusModel accountStatusModel = new AccountStatusModel();

  List<dynamic> listDeparmentsItems = [];

  bool loading = false;
  bool initialLoading = true;
  DeparmentsNotifierService() {
    accountStatusModel.nameEntity = _prefs.nameEntity!;
    accountStatusModel.idEntity = _prefs.idEntity!;
    accountStatusModel.fullnamePerson = _prefs.fullnamePerson!;
    accountStatusModel.idPerson = _prefs.idPerson!;
    accountStatusModel.photoUrl = _prefs.photoUrl!;
    accountStatusModel.nroDocument = _prefs.nroDocument!;
    accountStatusModel.month = DateTime.now().month;
    accountStatusModel.nameMonth =
        capitalize(DateFormat.MMMM('es').format(DateTime.now()));
    accountStatusModel.year = DateTime.now().year;
  }

  void executeService() {
    loading = true;
    notifyListeners();
    this.getDeparmentsItems();
  }

  void executeServiceInitial() {
    if (initialLoading) {
      loading = true;
      initialLoading = false;
      notifyListeners();
      this.getDeparmentsItems();
    }
  }

  void getDeparmentsItems() async {
    final Map<String, String> params = {
        'id_entidad': accountStatusModel.idEntity.toString(),
        'id_persona': accountStatusModel.idPerson.toString(),
        'id_anho': accountStatusModel.year.toString()
    };
    final resp = await deparmentsService.getDeparmentsItems(params);
      listDeparmentsItems = resp;
    loading = false;
    notifyListeners();
  }
}
