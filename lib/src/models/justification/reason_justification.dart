// To parse this JSON data, do
//
//     final reasonJustificationModel = reasonJustificationModelFromJson(jsonString);

import 'dart:convert';

ReasonJustificationModel reasonJustificationModelFromJson(String str) => ReasonJustificationModel.fromJson(json.decode(str));

String reasonJustificationModelToJson(ReasonJustificationModel data) => json.encode(data.toJson());

class ReasonJustificationModel {
    ReasonJustificationModel({
        this.idMotivoJustif,
        this.nombre,
        this.vigencia,
    });

    String? idMotivoJustif;
    String? nombre;
    String? vigencia;

    factory ReasonJustificationModel.fromJson(Map<String, dynamic> json) => ReasonJustificationModel(
        idMotivoJustif: json["id_motivo_justif"] == null ? null : json["id_motivo_justif"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_motivo_justif": idMotivoJustif == null ? null : idMotivoJustif,
        "nombre": nombre == null ? null : nombre,
        "vigencia": vigencia == null ? null : vigencia,
    };
}
