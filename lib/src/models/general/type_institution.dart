// To parse this JSON data, do
//
//     final typeInstitutionModel = typeInstitutionModelFromJson(jsonString);

import 'dart:convert';

TypeInstitutionModel typeInstitutionModelFromJson(String str) => TypeInstitutionModel.fromJson(json.decode(str));

String typeInstitutionModelToJson(TypeInstitutionModel data) => json.encode(data.toJson());

class TypeInstitutionModel {
    TypeInstitutionModel({
        this.idTipoInstAtencion,
        this.codigo,
        this.nombre,
        this.vigencia,
    });

    String? idTipoInstAtencion;
    String? codigo;
    String? nombre;
    String? vigencia;

    factory TypeInstitutionModel.fromJson(Map<String, dynamic> json) => TypeInstitutionModel(
        idTipoInstAtencion: json["id_tipo_inst_atencion"] == null ? null : json["id_tipo_inst_atencion"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        vigencia: json["vigencia"] == null ? null : json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_tipo_inst_atencion": idTipoInstAtencion == null ? null : idTipoInstAtencion,
        "codigo": codigo == null ? null : codigo,
        "nombre": nombre == null ? null : nombre,
        "vigencia": vigencia == null ? null : vigencia,
    };
}
