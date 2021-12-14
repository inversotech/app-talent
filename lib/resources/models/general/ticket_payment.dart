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
        this.urlDownload
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
    String? urlDownload;

    factory TicketPaymentModel.fromJson(Map<String, dynamic> json) => TicketPaymentModel(
        idAnho: json["id_anho"],
        idMes: json["id_mes"],
        idPersona: json["id_persona"],
        idContrato: json["id_contrato"],
        clave: json["clave"],
        archivo: json["archivo"],
        mes: json["mes"],
        nombre: json["nombre"],
        paterno: json["paterno"],
        materno: json["materno"],
        entidad: json["entidad"],
        correo1: json["correo1"],
        celular1: json["celular1"],
        firma: json["firma"],
        aviso: json["aviso"],
        revisado: json["revisado"],
        descargado: json["descargado"],
        ffirma: json["ffirma"],
        faviso: json["faviso"],
        frevisado: json["frevisado"],
        fdescargado: json["fdescargado"],
        boleta: json["boleta"],
        correo: json["correo"],
        celular: json["celular"],
        urls: json["urls"],
        urlDownload: json["url_download"]
    );

    Map<String, dynamic> toJson() => {
        "id_anho": idAnho,
        "id_mes": idMes,
        "id_persona": idPersona,
        "id_contrato": idContrato,
        "clave": clave,
        "archivo": archivo,
        "mes": mes,
        "nombre": nombre,
        "paterno": paterno,
        "materno": materno,
        "entidad": entidad,
        "correo1": correo1,
        "celular1": celular1,
        "firma": firma,
        "aviso": aviso,
        "revisado": revisado,
        "descargado": descargado,
        "ffirma": ffirma,
        "faviso": faviso,
        "frevisado": frevisado,
        "fdescargado": fdescargado,
        "boleta": boleta,
        "correo": correo,
        "celular": celular,
        "urls": urls,
        "url_download": urlDownload
    };
}
