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
        idConceptoPermLic: json["id_concepto_perm_lic"] == null ? null : json["id_concepto_perm_lic"],
        idTipoPermLic: json["id_tipo_perm_lic"] == null ? null : json["id_tipo_perm_lic"],
        idTipoSuspension: json["id_tipo_suspension"] == null ? null : json["id_tipo_suspension"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        periodo: json["periodo"] == null ? null : json["periodo"],
        notificacion: json["notificacion"] == null ? null : json["notificacion"],
        engrupo: json["engrupo"] == null ? null : json["engrupo"],
        diasFijo: json["dias_fijo"] == null ? null : json["dias_fijo"],
        minDias: json["min_dias"] == null ? null : json["min_dias"],
        maxDias: json["max_dias"] == null ? null : json["max_dias"],
        maxDiasAnho: json["max_dias_anho"] == null ? null : json["max_dias_anho"],
        adjuntos: json["adjuntos"] == null ? null : json["adjuntos"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
        nombreTipoPerLic: json["nombre_tipo_per_lic"] == null ? null : json["nombre_tipo_per_lic"],
        nombreTipoSuspension: json["nombre_tipo_suspension"] == null ? null : json["nombre_tipo_suspension"],
        tipoSuspension: json["tipo_suspension"] == null ? null : json["tipo_suspension"],
        periodoValor: json["periodo_valor"] == null ? null : json["periodo_valor"],
    );

    Map<String, dynamic> toJson() => {
        "id_concepto_perm_lic": idConceptoPermLic == null ? null : idConceptoPermLic,
        "id_tipo_perm_lic": idTipoPermLic == null ? null : idTipoPermLic,
        "id_tipo_suspension": idTipoSuspension == null ? null : idTipoSuspension,
        "nombre": nombre == null ? null : nombre,
        "codigo": codigo == null ? null : codigo,
        "periodo": periodo == null ? null : periodo,
        "notificacion": notificacion == null ? null : notificacion,
        "engrupo": engrupo == null ? null : engrupo,
        "dias_fijo": diasFijo == null ? null : diasFijo,
        "min_dias": minDias == null ? null : minDias,
        "max_dias": maxDias == null ? null : maxDias,
        "max_dias_anho": maxDiasAnho == null ? null : maxDiasAnho,
        "adjuntos": adjuntos == null ? null : adjuntos,
        "vigencia": vigencia == null ? null : vigencia,
        "nombre_tipo_per_lic": nombreTipoPerLic == null ? null : nombreTipoPerLic,
        "nombre_tipo_suspension": nombreTipoSuspension == null ? null : nombreTipoSuspension,
        "tipo_suspension": tipoSuspension == null ? null : tipoSuspension,
        "periodo_valor": periodoValor == null ? null : periodoValor,
    };
}
