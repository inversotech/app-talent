// To parse this JSON data, do
//
//     final typeLicensePermitModel = typeLicensePermitModelFromJson(jsonString);

import 'dart:convert';

TypeLicensePermitModel typeLicensePermitModelFromJson(String str) => TypeLicensePermitModel.fromJson(json.decode(str));

String typeLicensePermitModelToJson(TypeLicensePermitModel data) => json.encode(data.toJson());

class TypeLicensePermitModel {
    TypeLicensePermitModel({
        this.idTipoPermLic,
        this.codigo,
        this.nombre,
        this.vigencia,
    });

    String? idTipoPermLic;
    String? codigo;
    String? nombre;
    String? vigencia;

    factory TypeLicensePermitModel.fromJson(Map<String, dynamic> json) => TypeLicensePermitModel(
        idTipoPermLic: json["id_tipo_perm_lic"] == null ? null : json["id_tipo_perm_lic"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_tipo_perm_lic": idTipoPermLic == null ? null : idTipoPermLic,
        "codigo": codigo == null ? null : codigo,
        "nombre": nombre == null ? null : nombre,
        "vigencia": vigencia == null ? null : vigencia,
    };
}
