// To parse this JSON data, do
//
//     final justificationGroup = justificationGroupFromJson(jsonString);

import 'dart:convert';

import 'license_permit.dart';

LicensePermitGroupModel justificationGroupFromJson(String str) => LicensePermitGroupModel.fromJson(json.decode(str));

String justificationGroupToJson(LicensePermitGroupModel data) => json.encode(data.toJson());

class LicensePermitGroupModel {
    LicensePermitGroupModel({
        this.idTrabajador,
        this.apellidonombre,
        this.children,
    });

    String? idTrabajador;
    String? apellidonombre;
    List<LicensePermitModel>? children;

    factory LicensePermitGroupModel.fromJson(Map<String, dynamic> json) => LicensePermitGroupModel(
        idTrabajador: json["id_trabajador"],
        apellidonombre: json["apellidonombre"],
        children: json["children"] == null ? [] : (json["children"] as List).map((jsonElement) => LicensePermitModel.fromJson(jsonElement))
          .toList(),
    );

    Map<String, dynamic> toJson() => {
        "id_trabajador": idTrabajador,
        "apellidonombre": apellidonombre,
        "children": children == null ? null :  List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}
