// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
    GroupModel({
        this.idGrupo,
        this.idPersona,
        this.nombre,
        this.estado,
        this.createdAt,
        this.updatedAt,
        this.descripcion,
        this.checked,
        this.countPersonas,
    });

    String? idGrupo;
    String? idPersona;
    String? nombre;
    String? estado;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? descripcion;
    String? checked;
    String? countPersonas;

    factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        idGrupo: json["id_grupo"],
        idPersona: json["id_persona"],
        nombre: json["nombre"],
        estado: json["estado"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        descripcion: json["descripcion"],
        checked: json["checked"],
        countPersonas: json["count_personas"],
    );

    Map<String, dynamic> toJson() => {
        "id_grupo": idGrupo,
        "id_persona": idPersona,
        "nombre": nombre,
        "estado": estado,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "descripcion": descripcion,
        "checked": checked,
        "count_personas": countPersonas,
    };
}
