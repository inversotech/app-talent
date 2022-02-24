// To parse this JSON data, do
//
//     final albumModel = albumModelFromJson(jsonString);

import 'dart:convert';

AlbumModel albumModelFromJson(String str) => AlbumModel.fromJson(json.decode(str));

String albumModelToJson(AlbumModel data) => json.encode(data.toJson());

class AlbumModel {
    AlbumModel({
        this.idAlbum,
        this.idEntidad,
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
        this.createdAt,
        this.updatedAt,
    });

    int? idAlbum;
    String? idEntidad;
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
    DateTime? createdAt;
    DateTime? updatedAt;

    factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
        idAlbum: json["id_album"],
        idEntidad: json["id_entidad"],
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_album": idAlbum,
        "id_entidad": idEntidad,
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
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}

class Foto {
    Foto({
        this.idAfoto,
        this.idAlbum,
        this.descripcion,
        this.countLikes,
        this.countComentarios,
        this.imagenUrl,
        this.createdAt,
        this.updatedAt,
    });

    int? idAfoto;
    String? idAlbum;
    String? descripcion;
    int? countLikes;
    int? countComentarios;
    String? imagenUrl;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        idAfoto: json["id_afoto"],
        idAlbum: json["id_album"],
        descripcion: json["descripcion"],
        countLikes: json["count_likes"],
        countComentarios: json["count_comentarios"],
        imagenUrl: json["imagen_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_afoto": idAfoto,
        "id_album": idAlbum,
        "descripcion": descripcion,
        "count_likes": countLikes,
        "count_comentarios": countComentarios,
        "imagen_url": imagenUrl,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
