// To parse this JSON data, do
//
//     final markingWorkerModel = markingWorkerModelFromJson(jsonString);

import 'dart:convert';


MarkingWorkerModel markingWorkerModelFromJson(String str) => MarkingWorkerModel.fromJson(json.decode(str));

String markingWorkerModelToJson(MarkingWorkerModel data) => json.encode(data.toJson());

class MarkingWorkerModel {
    MarkingWorkerModel({
        this.idMarcacion,
        this.fechahora,
        this.fechahoraManual,
        this.idDescripMarcacion,
        this.nombreDescripMarcacion,
        this.esSolicitado=false,
        this.esJustificado=false,
        this.eliminar=false
    });

    String? idMarcacion;
    String? fechahora;
    String? fechahoraManual;
    String? idDescripMarcacion;
    String? nombreDescripMarcacion;
    bool esSolicitado;
    bool esJustificado;
    bool eliminar;

    factory MarkingWorkerModel.fromJson(Map<String, dynamic> json) => MarkingWorkerModel(
        idMarcacion: json["id_marcacion"],
        fechahora: json["fechahora"] == null ? null : json["fechahora"],
        fechahoraManual: json["fechahora_manual"] == null ? null : json["fechahora_manual"],
        idDescripMarcacion: json["id_descrip_marcacion"] == null ? null : json["id_descrip_marcacion"],
        nombreDescripMarcacion: json["nombre_descrip_marcacion"] == null ? null : json["nombre_descrip_marcacion"],
        esSolicitado: json["es_solicitado"] == null ? false: json["es_solicitado"].toString().toLowerCase() == 'true' ? true : false,
        esJustificado: json["es_justificado"] == null ? false: json["es_justificado"].toString().toLowerCase() == 'true' ? true : false,
        eliminar: json["eliminar"] == null ? false: json["eliminar"].toString().toLowerCase() == 'true' ? true : false
    );

    Map<String, dynamic> toJson() => {
        "id_marcacion": idMarcacion,
        "fechahora": fechahora == null ? null : fechahora,
        "fechahora_manual": fechahoraManual == null ? null : fechahoraManual,
        "id_descrip_marcacion": idDescripMarcacion == null ? null : idDescripMarcacion,
        "nombre_descrip_marcacion": nombreDescripMarcacion == null ? null : nombreDescripMarcacion,
        "es_solicitado": esSolicitado,
        "es_justificado": esJustificado,
        "eliminar": eliminar
    };
}
