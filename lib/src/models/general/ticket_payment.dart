// To parse this JSON data, do
//
//     final ticketPaymentModel = ticketPaymentModelFromJson(jsonString);

import 'dart:convert';

TicketPaymentModel ticketPaymentModelFromJson(String str) => TicketPaymentModel.fromJson(json.decode(str));

String ticketPaymentModelToJson(TicketPaymentModel data) => json.encode(data.toJson());

class TicketPaymentModel {
    TicketPaymentModel({
        this.idAnho,
        this.idMes,
        this.idPersona,
        this.idContrato,
        this.clave,
        this.archivo,
        this.mes,
        this.nombre,
        this.paterno,
        this.materno,
        this.entidad,
        this.correo1,
        this.celular1,
        this.firma,
        this.aviso,
        this.revisado,
        this.descargado,
        this.ffirma,
        this.faviso,
        this.frevisado,
        this.fdescargado,
        this.boleta,
        this.correo,
        this.celular,
        this.urls,
    });

    String? idAnho;
    String? idMes;
    String? idPersona;
    String? idContrato;
    String? clave;
    String? archivo;
    String? mes;
    String? nombre;
    String? paterno;
    String? materno;
    String? entidad;
    String? correo1;
    String? celular1;
    String? firma;
    String? aviso;
    String? revisado;
    String? descargado;
    String? ffirma;
    String? faviso;
    String? frevisado;
    String? fdescargado;
    String? boleta;
    String? correo;
    String? celular;
    String? urls;

    factory TicketPaymentModel.fromJson(Map<String, dynamic> json) => TicketPaymentModel(
        idAnho: json["id_anho"] == null ? null : json["id_anho"],
        idMes: json["id_mes"] == null ? null : json["id_mes"],
        idPersona: json["id_persona"] == null ? null : json["id_persona"],
        idContrato: json["id_contrato"] == null ? null : json["id_contrato"],
        clave: json["clave"] == null ? null : json["clave"],
        archivo: json["archivo"] == null ? null : json["archivo"],
        mes: json["mes"] == null ? null : json["mes"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        paterno: json["paterno"] == null ? null : json["paterno"],
        materno: json["materno"] == null ? null : json["materno"],
        entidad: json["entidad"] == null ? null : json["entidad"],
        correo1: json["correo1"] == null ? null : json["correo1"],
        celular1: json["celular1"] == null ? null : json["celular1"],
        firma: json["firma"] == null ? null : json["firma"],
        aviso: json["aviso"] == null ? null : json["aviso"],
        revisado: json["revisado"] == null ? null : json["revisado"],
        descargado: json["descargado"] == null ? null : json["descargado"],
        ffirma: json["ffirma"] == null ? null : json["ffirma"],
        faviso: json["faviso"] == null ? null : json["faviso"],
        frevisado: json["frevisado"] == null ? null : json["frevisado"],
        fdescargado: json["fdescargado"] == null ? null : json["fdescargado"],
        boleta: json["boleta"] == null ? null : json["boleta"],
        correo: json["correo"] == null ? null : json["correo"],
        celular: json["celular"] == null ? null : json["celular"],
        urls: json["urls"] == null ? null : json["urls"],
    );

    Map<String, dynamic> toJson() => {
        "id_anho": idAnho == null ? null : idAnho,
        "id_mes": idMes == null ? null : idMes,
        "id_persona": idPersona == null ? null : idPersona,
        "id_contrato": idContrato == null ? null : idContrato,
        "clave": clave == null ? null : clave,
        "archivo": archivo == null ? null : archivo,
        "mes": mes == null ? null : mes,
        "nombre": nombre == null ? null : nombre,
        "paterno": paterno == null ? null : paterno,
        "materno": materno == null ? null : materno,
        "entidad": entidad == null ? null : entidad,
        "correo1": correo1 == null ? null : correo1,
        "celular1": celular1 == null ? null : celular1,
        "firma": firma == null ? null : firma,
        "aviso": aviso == null ? null : aviso,
        "revisado": revisado == null ? null : revisado,
        "descargado": descargado == null ? null : descargado,
        "ffirma": ffirma == null ? null : ffirma,
        "faviso": faviso == null ? null : faviso,
        "frevisado": frevisado == null ? null : frevisado,
        "fdescargado": fdescargado == null ? null : fdescargado,
        "boleta": boleta == null ? null : boleta,
        "correo": correo == null ? null : correo,
        "celular": celular == null ? null : celular,
        "urls": urls == null ? null : urls,
    };
}
