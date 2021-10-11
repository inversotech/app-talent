// To parse this JSON data, do
//
//     final assistanceSummaryDetailModel = assistanceSummaryDetailModelFromJson(jsonString);

import 'dart:convert';

AssistanceSummaryDetailModel assistanceSummaryDetailModelFromJson(String str) => AssistanceSummaryDetailModel.fromJson(json.decode(str));

String assistanceSummaryDetailModelToJson(AssistanceSummaryDetailModel data) => json.encode(data.toJson());

class AssistanceSummaryDetailModel {
    AssistanceSummaryDetailModel({
        this.codigo,
        this.nombre,
        this.fecha,
        this.fechahoraHorario,
        this.fechahoraBase,
        this.fechahoraReal,
        this.minutosTar,
        this.minutosTarTotal,
    });

    String? codigo;
    String? nombre;
    DateTime? fecha;
    DateTime? fechahoraHorario;
    DateTime? fechahoraBase;
    DateTime? fechahoraReal;
    String? minutosTar;
    String? minutosTarTotal;

    factory AssistanceSummaryDetailModel.fromJson(Map<String, dynamic> json) => AssistanceSummaryDetailModel(
        codigo: json["codigo"] == null ? null : json["codigo"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        fechahoraHorario: json["fechahora_horario"] == null ? null : DateTime.parse(json["fechahora_horario"]),
        fechahoraBase: json["fechahora_base"] == null ? null : DateTime.parse(json["fechahora_base"]),
        fechahoraReal: json["fechahora_real"] == null ? null : DateTime.parse(json["fechahora_real"]),
        minutosTar: json["minutos_tar"] == null ? null : json["minutos_tar"],
        minutosTarTotal: json["minutos_tar_total"] == null ? null : json["minutos_tar_total"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo == null ? null : codigo,
        "nombre": nombre == null ? null : nombre,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "fechahora_horario": fechahoraHorario == null ? null : fechahoraHorario!.toIso8601String(),
        "fechahora_base": fechahoraBase == null ? null : fechahoraBase!.toIso8601String(),
        "fechahora_real": fechahoraReal == null ? null : fechahoraReal!.toIso8601String(),
        "minutos_tar": minutosTar == null ? null : minutosTar,
        "minutos_tar_total": minutosTarTotal == null ? null : minutosTarTotal,
    };
}
