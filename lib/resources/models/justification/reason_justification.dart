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
        idMotivoJustif: json["id_motivo_justif"],
        nombre: json["nombre"],
        vigencia: json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_motivo_justif": idMotivoJustif,
        "nombre": nombre,
        "vigencia": vigencia,
    };
}
