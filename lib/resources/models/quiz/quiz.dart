// To parse this JSON data, do
//
//     final survey = surveyFromJson(jsonString);

import 'dart:convert';

import 'package:lamb_talent/resources/models/quiz/quiz_item.dart';


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
        this.fecha,
        this.aprobado,
        this.descripcionLink,
        this.nombreLink,
        this.link,
        this.nombreLinkOpcional,
        this.linkOpcional
        
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
    DateTime? fecha;
    String? aprobado;
    String? descripcionLink;
    String? nombreLink;
    String? link;
    String? nombreLinkOpcional;
    String? linkOpcional;

    factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        idEncuesta: json["id_encuesta"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        terminos: json["terminos"],
        estado: json["estado"],
        idUserReg: json["id_user_reg"],
        idUserMod: json["id_user_mod"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        codigo: json["codigo"],
        items: json["items"] == null ? [] : (json["items"] as List).map((jsonElement) => SurveyItem.fromJson(jsonElement))
          .toList(),
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        aprobado: json["aprobado"] ?? '0',
        descripcionLink: json["descripcion_link"],
        nombreLink: json["nombre_link"],
        link: json["link"],
        nombreLinkOpcional: json["nombre_link_opcional"],
        linkOpcional: json["link_opcional"]
    );

    Map<String, dynamic> toJson() => {
        "id_encuesta": idEncuesta,
        "nombre": nombre,
        "descripcion": descripcion,
        "terminos": terminos,
        "estado": estado,
        "id_user_reg": idUserReg,
        "id_user_mod": idUserMod,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "codigo": codigo,
        "items": items == null ? null :  List<dynamic>.from(items!.map((x) => x.toJson())),
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "aprobado": codigo == null ? '0' : aprobado,
        "descripcion_link": descripcionLink,
        "nombre_link": nombreLink,
        "link": link,
        "nombre_link_opcional": nombreLinkOpcional,
        "link_opcional": linkOpcional
    };
}
