// To parse this JSON data, do
//
//     final justificationGroup = justificationGroupFromJson(jsonString);

import 'dart:convert';

import 'justificacion.dart';

JustificationGroup justificationGroupFromJson(String str) => JustificationGroup.fromJson(json.decode(str));

String justificationGroupToJson(JustificationGroup data) => json.encode(data.toJson());

class JustificationGroup {
    JustificationGroup({
        this.idTrabajador,
        this.apellidonombre,
        this.children,
    });

    String? idTrabajador;
    String? apellidonombre;
    List<JustificationModel>? children;

    factory JustificationGroup.fromJson(Map<String, dynamic> json) => JustificationGroup(
        idTrabajador: json["id_trabajador"],
        apellidonombre: json["apellidonombre"],
        children: json["children"] == null ? [] : (json["children"] as List).map((jsonElement) => JustificationModel.fromJson(jsonElement))
          .toList(),
    );

    Map<String, dynamic> toJson() => {
        "id_trabajador": idTrabajador,
        "apellidonombre": apellidonombre,
        "children": children == null ? null :  List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}
