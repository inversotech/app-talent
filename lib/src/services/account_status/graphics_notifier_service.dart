import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';

class GraphicsNotifierService with ChangeNotifier {
  UserPreferences _prefs = new UserPreferences();
  GraphicsService _accountStatusGraphicsService = new GraphicsService();
  AccountStatusModel accountStatusModel = new AccountStatusModel();

  Map<String, dynamic> listItemsGraphics = {};

  bool loading = false;
  bool initialLoading = true;

  GraphicsNotifierService() {
    accountStatusModel.nameEntity = _prefs.nameEntity!;
    accountStatusModel.idEntity = _prefs.idEntity!;
    accountStatusModel.fullnamePerson = _prefs.fullnamePerson!;
    accountStatusModel.idPerson = _prefs.idPerson!;
    accountStatusModel.photoUrl = _prefs.photoUrl!;
    accountStatusModel.nroDocument = _prefs.nroDocument!;
    accountStatusModel.year = DateTime.now().year;
  }

  void executeService() {
    loading = true;
    notifyListeners();
    this.getItemsGraphics();
  }

  void executeServiceInitial() {
    if (initialLoading) {
      loading = true;
      initialLoading = false;
      notifyListeners();
      this.getItemsGraphics();
    }
  }

  void getItemsGraphics() async {
    try {
      final Map<String, String> params = {
        'id_entidad': accountStatusModel.idEntity.toString(),
        'id_persona': accountStatusModel.idPerson.toString(),
        'id_anho': accountStatusModel.year.toString()
      };
      final resp = await _accountStatusGraphicsService.getGraphData(params);
      listItemsGraphics = resp;
    } catch (e) {
      listItemsGraphics = {};
    }

    loading = false;
    notifyListeners();
  }
}
