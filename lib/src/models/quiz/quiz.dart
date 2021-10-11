// To parse this JSON data, do
//
//     final survey = surveyFromJson(jsonString);

import 'dart:convert';

import 'package:upn_financiero_mobil/src/models/quiz/quiz_item.dart';

Survey surveyFromJson(String str) => Survey.fromJson(json.decode(str));

String surveyToJson(Survey data) => json.encode(data.toJson());

class Survey {
    Survey({
        this.idEncuesta,
        this.nombre,
        this.descripcion,
        this.terminos,
        this.estado,
        this.idUserReg,
        this.idUserMod,
        this.fechaReg,
        this.fechaMod,
        this.codigo,
        this.items,
    });

    String? idEncuesta;
    String? nombre;
    String? descripcion;
    String? terminos;
    String? estado;
    String? idUserReg;
    String? idUserMod;
    DateTime? fechaReg;
    DateTime? fechaMod;
    String? codigo;
    List<SurveyItem>? items;

    factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        idEncuesta: json["id_encuesta"] == null ? null : json["id_encuesta"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        terminos: json["terminos"] == null ? null : json["terminos"],
        estado: json["estado"] == null ? null : json["estado"],
        idUserReg: json["id_user_reg"] == null ? null : json["id_user_reg"],
        idUserMod: json["id_user_mod"] == null ? null : json["id_user_mod"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        codigo: json["codigo"] == null ? null : json["codigo"],
        items: json["items"] == null ? [] : (json["items"] as List).map((jsonElement) => SurveyItem.fromJson(jsonElement))
          .toList(),
    );

    Map<String, dynamic> toJson() => {
        "id_encuesta": idEncuesta == null ? null : idEncuesta,
        "nombre": nombre == null ? null : nombre,
        "descripcion": descripcion == null ? null : descripcion,
        "terminos": terminos == null ? null : terminos,
        "estado": estado == null ? null : estado,
        "id_user_reg": idUserReg == null ? null : idUserReg,
        "id_user_mod": idUserMod == null ? null : idUserMod,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "codigo": codigo == null ? null : codigo,
        "items": items == null ? null :  List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}
