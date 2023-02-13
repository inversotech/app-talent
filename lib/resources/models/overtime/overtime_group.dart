import 'dart:convert';

import 'overtime.dart';

OvertimeGroup overtimeGroupFromJson(String str) =>
    OvertimeGroup.fromJson(json.decode(str));

String overtimeGroupToJson(OvertimeGroup data) => json.encode(data.toJson());

class OvertimeGroup {
  OvertimeGroup({
    this.idTrabajador,
    this.apellidonombre,
    this.children,
  });

  String? idTrabajador;
  String? apellidonombre;
  List<OvertimeModel>? children;

  factory OvertimeGroup.fromJson(Map<String, dynamic> json) => OvertimeGroup(
        idTrabajador: json["id_trabajador"],
        apellidonombre: json["apellidonombre"],
        children: json["children"] == null
            ? []
            : (json["children"] as List)
                .map((jsonElement) => OvertimeModel.fromJson(jsonElement))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        "id_trabajador": idTrabajador,
        "apellidonombre": apellidonombre,
        "children": children == null
            ? null
            : List<dynamic>.from(children!.map((x) => x.toJson())),
      };
}
