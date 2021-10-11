// To parse this JSON data, do
//
//     final descriptionMarkingModel = descriptionMarkingModelFromJson(jsonString);

import 'dart:convert';

DescriptionMarkingModel descriptionMarkingModelFromJson(String str) => DescriptionMarkingModel.fromJson(json.decode(str));

String descriptionMarkingModelToJson(DescriptionMarkingModel data) => json.encode(data.toJson());

class DescriptionMarkingModel {
    DescriptionMarkingModel({
        this.idDescripMarcacion,
        this.nombre,
        this.vigencia,
    });

    String? idDescripMarcacion;
    String? nombre;
    String? vigencia;

    factory DescriptionMarkingModel.fromJson(Map<String, dynamic> json) => DescriptionMarkingModel(
        idDescripMarcacion: json["id_descrip_marcacion"] == null ? null : json["id_descrip_marcacion"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_descrip_marcacion": idDescripMarcacion == null ? null : idDescripMarcacion,
        "nombre": nombre == null ? null : nombre,
        "vigencia": vigencia == null ? null : vigencia,
    };
}
