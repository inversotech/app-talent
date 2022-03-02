// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

import 'notification_general.dart';

AlbumModel albumModelFromJson(String str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
    AlbumModel({
        this.idAlbum,
        this.idEntidad,
        this.nombreEntidad,
        this.idDepto,
        this.idInstitucion,
        this.idPersona,
        this.nombre,
        this.descripcion,
        this.fecha,
        this.addNotificaciones,
        this.estado,
        this.idsFcmApp,
        this.fotos,
        this.fechaParse,
        this.personaFullname,
        this.personaAvatar,
        this.like=false,
        this.countLikes,
        this.countComentarios,
        this.createdAt,
        this.updatedAt,
    });

    int? idAlbum;
    String? idEntidad;
    String? nombreEntidad;
    String? idDepto;
    String? idInstitucion;
    String? idPersona;
    String? nombre;
    String? descripcion;
    DateTime? fecha;
    String? addNotificaciones;
    String? estado;
    String? idsFcmApp;
    List<Foto>? fotos;
    String? fechaParse;
    String? personaFullname;
    String? personaAvatar;
    bool like;
    int? countLikes;
    int? countComentarios;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        idAlbum: json["id_album"],
        idEntidad: json["id_entidad"],
        nombreEntidad: json["nombre_entidad"],
        idDepto: json["id_depto"],
        idInstitucion: json["id_institucion"],
        idPersona: json["id_persona"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        addNotificaciones: json["add_notificaciones"],
        estado: json["estado"],
        idsFcmApp: json["ids_fcm_app"],
        fotos: json["fotos"]  == null ? [] : (json["fotos"] as List).map((jsonElement) => Foto.fromJson(jsonElement))
          .toList(),
        fechaParse: json["fecha_parse"],
        personaFullname: json["persona_fullname"],
        personaAvatar: json["persona_avatar"], 
        like: json["like"] == null ? false : json["like"].toString().toLowerCase() == 'true',
        countLikes: json["count_likes"] == null ? 0 : int.parse(json["count_likes"].toString()),
        countComentarios: json["count_comentarios"] == null ? 0 : int.parse(json["count_comentarios"].toString()),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_album": idAlbum,
        "id_entidad": idEntidad,
        "nombre_entidad": nombreEntidad,
        "id_depto": idDepto,
        "id_institucion": idInstitucion,
        "id_persona": idPersona,
        "nombre": nombre,
        "descripcion": descripcion,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "add_notificaciones": addNotificaciones,
        "estado": estado,
        "ids_fcm_app": idsFcmApp,
        "fotos": fotos == null ? null :  List<dynamic>.from(fotos!.map((x) => x.toJson())),
        "fecha_parse": fechaParse,
        "persona_fullname": personaFullname,
        "persona_avatar": personaAvatar,
        "like": like,
        "count_likes": countLikes,
        "count_comentarios": countComentarios,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}