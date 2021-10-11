import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';

class TravelsNotifierService with ChangeNotifier {
  UserPreferences _prefs = new UserPreferences();
  TravelsService _travelsService = new TravelsService();
  AccountStatusModel accountStatusModel = new AccountStatusModel();

  Map<String, dynamic> listTravelData = {};

  bool loading = false;
  bool initialLoading = true;

  TravelsNotifierService() {
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
    this.getTravel();
  }

  void executeServiceInitial() {
    if (initialLoading) {
      loading = true;
      initialLoading = false;
      notifyListeners();
      this.getTravel();
    }
  }

  void getTravel() async {
    final Map<String, String> params = {
      'id_entidad': accountStatusModel.idEntity.toString(),
      'id_cta_cte': accountStatusModel.nroDocument,
      'id_mes': accountStatusModel.month.toString(),
      'id_anho': accountStatusModel.year.toString()
    };
    final resp = await _travelsService.getTravelsData(params);

    listTravelData = resp;
    loading = false;
    notifyListeners();
  }
}
