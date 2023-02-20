import 'dart:convert';

import 'package:lamb_talent/resources/models/general/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instancia = UserPreferences._internal();

  factory UserPreferences() {
    return _instancia;
  }

  UserPreferences._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void clear() {
    _prefs?.clear();
  }

  // GET y SET del fullnamePersonFather aqui estan los datos del que se logeo.
  String? get fullnamePersonFather {
    return _prefs?.getString('fullnamePersonFather');
  }

  set fullnamePersonFather(String? value) {
    _prefs?.setString('fullnamePersonFather', value!);
  }

  // GET y SET del fullname
  String? get fullnamePerson {
    return _prefs?.getString('fullnamePerson');
  }

  set fullnamePerson(String? value) {
    _prefs?.setString('fullnamePerson', value!);
  }

  // GET y SET del idPersonFather
  int? get idPersonFather {
    return _prefs?.getInt('idPersonFather');
  }

  set idPersonFather(int? value) {
    _prefs?.setInt('idPersonFather', value!);
  }

  // GET y SET del idPerson
  int? get idPerson {
    return _prefs?.getInt('idPerson');
  }

  set idPerson(int? value) {
    _prefs?.setInt('idPerson', value!);
  }

  // GET y SET del idWorkerFather
  int? get idWorkerFather {
    return _prefs?.getInt('idWorkerFather');
  }

  set idWorkerFather(int? value) {
    _prefs?.setInt('idWorkerFather', value!);
  }

  // GET y SET del idWorker
  int? get idWorker {
    return _prefs?.getInt('idWorker');
  }

  set idWorker(int? value) {
    _prefs?.setInt('idWorker', value!);
  }

  // GET y SET del nroDocumentFather
  String? get nroDocumentFather {
    return _prefs?.getString('nroDocumentFather') ?? '';
  }

  set nroDocumentFather(String? value) {
    _prefs?.setString('nroDocumentFather', value!);
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
    return _prefs?.getString('photoUrl');
  }

  set photoUrl(String? value) {
    _prefs?.setString('photoUrl', value!);
  }

  // GET y SET del idEntity
  int? get idEntityFather {
    return _prefs?.getInt('idEntityFather');
  }

  set idEntityFather(int? value) {
    _prefs?.setInt('idEntityFather', value!);
  }

  // GET y SET del idEntity
  int? get idEntity {
    return _prefs?.getInt('idEntity');
  }

  set idEntity(int? value) {
    _prefs?.setInt('idEntity', value!);
  }

  // GET y SET del nameEntity
  String? get nameEntity {
    return _prefs?.getString('nameEntity');
  }

  set nameEntity(String? value) {
    _prefs?.setString('nameEntity', value!);
  }

  // GET y SET del idDeparment
  String? get idDeparmentFathher {
    return _prefs?.getString('idDeparmentFathher');
  }

  set idDeparmentFathher(String? value) {
    _prefs?.setString('idDeparmentFathher', value!);
  }

  // GET y SET del idDeparment
  String? get idDeparment {
    return _prefs?.getString('idDeparment');
  }

  set idDeparment(String? value) {
    _prefs?.setString('idDeparment', value!);
  }

  // GET y SET del nomDeparment
  String? get nameDeparment {
    return _prefs?.getString('nameDeparment');
  }

  set nameDeparment(String? value) {
    _prefs?.setString('nameDeparment', value!);
  }

  // GET y SET del menu
  List<Menu>? get menu {
    List<dynamic> jsonList =
        json.decode(_prefs?.getString('menu') ?? '[]') as List<dynamic>;

    List<Menu> list =
        jsonList.map((jsonElement) => Menu.fromJson(jsonElement)).toList();
    return list;
  }

  set menu(List<Menu>? value) {
    _prefs?.setString('menu', json.encode(value!.toList()).toString());
  }

  // GET y SET del total entities
  int get cantEntities {
    return _prefs?.getInt('cantEntities') ?? 0;
  }

  set cantEntities(int value) {
    _prefs?.setInt('cantEntities', value);
  }

  // GET y SET del total deptos
  int get cantDeptos {
    return _prefs?.getInt('cantDeptos') ?? 0;
  }

  set cantDeptos(int value) {
    _prefs?.setInt('cantDeptos', value);
  }

  // GET y SET isWorkerChild
  bool get isWorkerChild {
    return _prefs?.getBool('isWorkerChild') ?? false;
  }

  set isWorkerChild(bool value) {
    _prefs?.setBool('isWorkerChild', value);
  }

  // GET y SET searchOption
  String? get searchOption {
    return _prefs?.getString('searchOption') ?? 'TALENT';
  }

  set searchOption(String? value) {
    _prefs?.setString('searchOption', value!);
  }

  // GET y SET idNivelAcceso
  String get idNivelAcceso {
    return _prefs?.getString('idNivelAcceso') ?? '';
  }

  set idNivelAcceso(String value) {
    _prefs?.setString('idNivelAcceso', value);
  }

  // GET y SET searchPerson
  bool get searchPerson {
    return _prefs?.getBool('searchPerson') ?? false;
  }

  set searchPerson(bool value) {
    _prefs?.setBool('searchPerson', value);
  }

  // GET y SET tokenNotify
  String get tokenNotify {
    return _prefs?.getString('tokenNotify') ?? '';
  }

  set tokenNotify(String value) {
    _prefs?.setString('tokenNotify', value);
  }

  // GET y SET cantNotify
  int get cantNotify {
    return _prefs?.getInt('cantNotify') ?? 0;
  }

  set cantNotify(int value) {
    _prefs?.setInt('cantNotify', value);
  }

  // GET y SET optionLocation
  String get optionLocation {
    return _prefs?.getString('optionLocation') ??
        '2'; //1 is not get location, 2 is get location, '3' is new get location
  }

  set optionLocation(String value) {
    _prefs?.setString('optionLocation', value);
  }

  // GET y SET latitude
  String get latitude {
    return _prefs?.getString('latitude') ?? '';
  }

  set latitude(String value) {
    _prefs?.setString('latitude', value);
  }

  // GET y SET longitude
  String get longitude {
    return _prefs?.getString('longitude') ?? '';
  }

  set longitude(String value) {
    _prefs?.setString('longitude', value);
  }

  // GET y SET resultChange
  bool get resultChange {
    return _prefs?.getBool('resultChange') ?? false;
  }

  set resultChange(bool value) {
    _prefs?.setBool('resultChange', value);
  }
  // GET y SET existNotify
  bool get existNotify {
    return _prefs?.getBool('existNotify') ?? false;
  }

  set existNotify(bool value) {
    _prefs?.setBool('existNotify', value);
  }
}
