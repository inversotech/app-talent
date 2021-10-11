// To parse this JSON data, do
//
//     final validLicensePermitModel = validLicensePermitModelFromJson(jsonString);

import 'dart:convert';

ValidLicensePermitModel validLicensePermitModelFromJson(String str) => ValidLicensePermitModel.fromJson(json.decode(str));

String validLicensePermitModelToJson(ValidLicensePermitModel data) => json.encode(data.toJson());

class ValidLicensePermitModel {
    ValidLicensePermitModel({
        this.diasAcumulado,
        this.diasDesmed,
        this.fechaFinDesmes,
        this.diasSubs,
        this.fechaIniSubs,
        this.fechaFinSubs,
        this.totalDia,
        this.maxDiasAnho,
    });

    String? diasAcumulado;
    String? diasDesmed;
    String? fechaFinDesmes;
    String? diasSubs;
    String? fechaIniSubs;
    String? fechaFinSubs;
    String? totalDia;
    String? maxDiasAnho;

    factory ValidLicensePermitModel.fromJson(Map<String, dynamic> json) => ValidLicensePermitModel(
        diasAcumulado: json["dias_acumulado"] == null ? null : json["dias_acumulado"],
        diasDesmed: json["dias_desmed"] == null ? null : json["dias_desmed"],
        fechaFinDesmes: json["fecha_fin_desmes"] == null ? null : json["fecha_fin_desmes"],
        diasSubs: json["dias_subs"] == null ? null : json["dias_subs"],
        fechaIniSubs: json["fecha_ini_subs"] == null ? null : json["fecha_ini_subs"],
        fechaFinSubs: json["fecha_fin_subs"] == null ? null : json["fecha_fin_subs"],
        totalDia: json["total_dia"] == null ? null : json["total_dia"],
        maxDiasAnho: json["max_dias_anho"] == null ? null : json["max_dias_anho"],
    );

    Map<String, dynamic> toJson() => {
        "dias_acumulado": diasAcumulado == null ? null : diasAcumulado,
        "dias_desmed": diasDesmed == null ? null : diasDesmed,
        "fecha_fin_desmes": fechaFinDesmes == null ? null : fechaFinDesmes,
        "dias_subs": diasSubs == null ? null : diasSubs,
        "fecha_ini_subs": fechaIniSubs == null ? null : fechaIniSubs,
        "fecha_fin_subs": fechaFinSubs == null ? null : fechaFinSubs,
        "total_dia": totalDia == null ? null : totalDia,
        "max_dias_anho": maxDiasAnho == null ? null : maxDiasAnho,
    };
}
