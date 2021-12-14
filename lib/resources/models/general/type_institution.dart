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
        idTipoInstAtencion: json["id_tipo_inst_atencion"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        vigencia: json["vigencia"],
    );

    Map<String, dynamic> toJson() => {
        "id_tipo_inst_atencion": idTipoInstAtencion,
        "codigo": codigo,
        "nombre": nombre,
        "vigencia": vigencia,
    };
}
