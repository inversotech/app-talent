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
        diasAcumulado: json["dias_acumulado"],
        diasDesmed: json["dias_desmed"],
        fechaFinDesmes: json["fecha_fin_desmes"],
        diasSubs: json["dias_subs"],
        fechaIniSubs: json["fecha_ini_subs"],
        fechaFinSubs: json["fecha_fin_subs"],
        totalDia: json["total_dia"],
        maxDiasAnho: json["max_dias_anho"],
    );

    Map<String, dynamic> toJson() => {
        "dias_acumulado": diasAcumulado,
        "dias_desmed": diasDesmed,
        "fecha_fin_desmes": fechaFinDesmes,
        "dias_subs": diasSubs,
        "fecha_ini_subs": fechaIniSubs,
        "fecha_fin_subs": fechaFinSubs,
        "total_dia": totalDia,
        "max_dias_anho": maxDiasAnho,
    };
}
