import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia =
      new UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  void clear() {
    this._prefs?.clear();
  }


  // GET y SET del fullname
  String? get fullnamePerson {
    return _prefs?.getString('fullnamePerson') ?? null;
  }

  set fullnamePerson(String? value) {
    _prefs?.setString('fullnamePerson', value!);
  }

  // GET y SET del idPerson
  int? get idPerson {
    return _prefs?.getInt('idPerson') ?? null;
  }

  set idPerson(int? value) {
    _prefs?.setInt('idPerson', value!);
  }
  // GET y SET del idWorker
  int? get idWorker {
    return _prefs?.getInt('idWorker') ?? null;
  }

  set idWorker(int? value) {
    _prefs?.setInt('idWorker', value!);
  }
  // GET y SET del nroDocument
  String? get nroDocument {
    return _prefs?.getString('nroDocument') ?? '';
  }

  set nroDocument(String? value) {
    _prefs?.setString('nroDocument', value!);
  }

  // GET y SET del photoUrl
  String? get photoUrl {
    return _prefs?.getString('photoUrl') ?? null;
  }

  set photoUrl(String? value) {
    _prefs?.setString('photoUrl', value!);
  }
  // GET y SET del idEntity
  int? get idEntity {
    return _prefs?.getInt('idEntity') ?? null;
  }

  set idEntity(int? value) {
    _prefs?.setInt('idEntity', value!);
  }
  // GET y SET del nameEntity
  String? get nameEntity {
    return _prefs?.getString('nameEntity') ?? null;
  }

  set nameEntity(String? value) {
    _prefs?.setString('nameEntity', value!);
  }
  // GET y SET del idDeparment
  String? get idDeparment {
    return _prefs?.getString('idDeparment') ?? null;
  }

  set idDeparment(String? value) {
    _prefs?.setString('idDeparment', value!);
  }
  // GET y SET del nomDeparment
  String? get nomDeparment {
    return _prefs?.getString('nomDeparment') ?? null;
  }

  set nomDeparment(String? value) {
    _prefs?.setString('nomDeparment', value!);
  }
 // GET y SET del admin
  String? get admin {
    return _prefs?.getString('admin') ?? null;
  }

  set admin(String? value) {
    _prefs?.setString('admin', value!);
  }
  
}
