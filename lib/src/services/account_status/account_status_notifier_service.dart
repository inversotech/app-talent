import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';

class AccountStatusNotifierService with ChangeNotifier {
  UserPreferences _prefs = new UserPreferences();
  AccountStatusService _accountStatusService = new AccountStatusService();
  AccountStatusModel accountStatusModel = AccountStatusModel();

  Map<String, dynamic> accountStatusData = {};
  bool loadingAccountStatus = false;

  AccountStatusNotifierService() {
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
    loadingAccountStatus = true;
    this.getAccountStatus();
  }
  void executeServiceAccountStatus() {
    loadingAccountStatus = true;
    notifyListeners();
    this.getAccountStatus();
  }

  void getAccountStatus() async {
    final String params = 'p_id_entidad=' +
        accountStatusModel.idEntity.toString() +
        ';p_id_anho=' +
        accountStatusModel.year.toString() +
        ';p_id_mes=' +
        accountStatusModel.month.toString() +
        ';p_id_persona=' +
        accountStatusModel.idPerson.toString() +
        ';p_id_cta_cte=' +
        accountStatusModel.nroDocument.toString();
    final resp = await _accountStatusService.getAccountStatus(params);
    accountStatusData = resp;
    loadingAccountStatus = false;
    notifyListeners();
  }
}
