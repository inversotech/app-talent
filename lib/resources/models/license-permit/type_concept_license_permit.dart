// To parse this JSON data, do
//
//     final typeConceptLicensePermitModel = typeConceptLicensePermitModelFromJson(jsonString);

import 'dart:convert';

TypeConceptLicensePermitModel typeConceptLicensePermitModelFromJson(String str) => TypeConceptLicensePermitModel.fromJson(json.decode(str));

String typeConceptLicensePermitModelToJson(TypeConceptLicensePermitModel data) => json.encode(data.toJson());

class TypeConceptLicensePermitModel {
    TypeConceptLicensePermitModel({
        this.idConceptoPermLic,
        this.idTipoPermLic,
        this.idTipoSuspension,
        this.nombre,
        this.codigo,
        this.periodo,
        this.notificacion,
        this.engrupo,
        this.diasFijo,
        this.minDias,
        this.maxDias,
        this.maxDiasAnho,
        this.adjuntos,
        this.vigencia,
        this.nombreTipoPerLic,
        this.nombreTipoSuspension,
        this.tipoSuspension,
        this.periodoValor,
    });

    String? idConceptoPermLic;
    String? idTipoPermLic;
    String? idTipoSuspension;
    String? nombre;
    String? codigo;
    String? periodo;
    String? notificacion;
    String? engrupo;
    String? diasFijo;
    String? minDias;
    String? maxDias;
    String? maxDiasAnho;
    String? adjuntos;
    String? vigencia;
    String? nombreTipoPerLic;
    String? nombreTipoSuspension;
    String? tipoSuspension;
    String? periodoValor;

    factory TypeConceptLicensePermitModel.fromJson(Map<String, dynamic> json) => TypeConceptLicensePermitModel(
        idConceptoPermLic: json["id_concepto_perm_lic"],
        idTipoPermLic: json["id_tipo_perm_lic"],
        idTipoSuspension: json["id_tipo_suspension"],
        nombre: json["nombre"],
        codigo: json["codigo"],
        periodo: json["periodo"],
        notificacion: json["notificacion"],
        engrupo: json["engrupo"],
        diasFijo: json["dias_fijo"],
        minDias: json["min_dias"],
        maxDias: json["max_dias"],
        maxDiasAnho: json["max_dias_anho"],
        adjuntos: json["adjuntos"],
        vigencia: json["vigencia"],
        nombreTipoPerLic: json["nombre_tipo_per_lic"],
        nombreTipoSuspension: json["nombre_tipo_suspension"],
        tipoSuspension: json["tipo_suspension"],
        periodoValor: json["periodo_valor"],
    );

    Map<String, dynamic> toJson() => {
        "id_concepto_perm_lic": idConceptoPermLic,
        "id_tipo_perm_lic": idTipoPermLic,
        "id_tipo_suspension": idTipoSuspension,
        "nombre": nombre,
        "codigo": codigo,
        "periodo": periodo,
        "notificacion": notificacion,
        "engrupo": engrupo,
        "dias_fijo": diasFijo,
        "min_dias": minDias,
        "max_dias": maxDias,
        "max_dias_anho": maxDiasAnho,
        "adjuntos": adjuntos,
        "vigencia": vigencia,
        "nombre_tipo_per_lic": nombreTipoPerLic,
        "nombre_tipo_suspension": nombreTipoSuspension,
        "tipo_suspension": tipoSuspension,
        "periodo_valor": periodoValor,
    };
}
