// To parse this JSON data, do
//
//     final dateModel = dateModelFromJson(jsonString);

import 'dart:convert';

AccountStatusModel accountStatusFromJson(String str) =>
    AccountStatusModel.fromJson(json.decode(str));

String accountStatusToJson(AccountStatusModel data) => json.encode(data.toJson());

class AccountStatusModel {
  AccountStatusModel({
    this.day = 1,
    this.nameDay = '',
    this.month = 1,
    this.nameMonth = '',
    this.year = 0,
    this.idEntity = 0,
    this.idBusiness = 0,
    this.idTypeEntity = 0,
    this.nameEntity = '',
    this.nametypeEntity = '',
    this.nroDocument = '',
    this.photoUrl = '',
    this.idPerson = 0,
    this.fullnamePerson = '',
  });

  int day;
  String nameDay;
  int month;
  String nameMonth;
  int year;
  int idEntity;
  int idBusiness;
  int idTypeEntity;
  String nameEntity;
  String nametypeEntity;
  String nroDocument;
  String photoUrl;
  int idPerson;
  String fullnamePerson;

  factory AccountStatusModel.fromJson(Map<String, dynamic> json) =>
      AccountStatusModel(
        day: json["day"],
        nameDay: json["nameDay"],
        month: json["month"],
        nameMonth: json["nameMonth"],
        year: json["year"],
        idEntity: json["idEntity"],
        idBusiness: json["idBusiness"],
        idTypeEntity: json["idTypeEntity"],
        nameEntity: json["nameEntity"],
        nametypeEntity: json["nametypeEntity"],
        nroDocument: json["nroDocument"],
        photoUrl: json["photoUrl"],
        idPerson: json["idPerson"],
        fullnamePerson: json["fullnamePerson"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "nameDay": nameDay,
        "month": month,
        "nameMonth": nameMonth,
        "year": year,
        "idEntity": idEntity,
        "idBusiness": idBusiness,
        "idTypeEntity": idTypeEntity,
        "nameEntity": nameEntity,
        "nametypeEntity": nametypeEntity,
        "nroDocument": nroDocument,
        "photoUrl": photoUrl,
        "idPerson": idPerson,
        "fullnamePerson": fullnamePerson,
      };
}
