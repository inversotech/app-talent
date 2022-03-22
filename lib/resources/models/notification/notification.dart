// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    NotificationModel({
        this.idNotificacion,
        this.idEntidad,
        this.nombreEntidad,
        this.idDepto,
        this.idInstitucion,
        this.idPersona,
        this.mensaje,
        this.fecha,
        this.fechaParse,
        this.addLink,
        this.link,
        this.addVideo,
        this.videoUrl,
        this.addArchivo,
        this.archivoUrl,
        this.archivoName,
        this.imagenUrl,
        this.imagenDefaultUrl,
        this.estado,
        this.idsFcmApp,
        this.isScheduled,
        this.personaFullname,
        this.personaAvatar,
        this.createdAt,
        this.updatedAt,
    });

    int? idNotificacion;
    String? idEntidad;
    String? nombreEntidad;
    String? idDepto;
    String? idInstitucion;
    String? idPersona;
    String? mensaje;
    DateTime? fecha;
    String? fechaParse;
    String? addLink;
    String? link;
    String? addVideo;
    String? videoUrl;
    String? addArchivo;
    String? archivoUrl;
    String? archivoName;
    String? imagenUrl;
    String? imagenDefaultUrl;
    String? estado;
    String? idsFcmApp;
    String? isScheduled;
    String? personaFullname;
    String? personaAvatar;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        idNotificacion: json["id_notificacion"],
        idEntidad: json["id_entidad"],
        nombreEntidad: json["nombre_entidad"],
        idDepto: json["id_depto"],
        idInstitucion: json["id_institucion"],
        idPersona: json["id_persona"],
        mensaje: json["mensaje"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        fechaParse: json["fecha_parse"],
        addLink: json["add_link"],
        link: json["link"] ?? '',
        addVideo: json["add_video"],
        videoUrl: json["video_url"] ?? '',
        addArchivo: json["add_archivo"],
        archivoUrl: json["archivo_url"] ?? '',
        archivoName: json["archivo_name"],
        imagenUrl: json["imagen_url"] ?? '',
        imagenDefaultUrl: json["imagen_default_url"] ?? '',
        estado: json["estado"],
        idsFcmApp: json["ids_fcm_app"],
        isScheduled: json["is_scheduled"],
        personaFullname: json["persona_fullname"],
        personaAvatar: json["persona_avatar"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_notificacion": idNotificacion,
        "id_entidad": idEntidad,
        "nombre_entidad": nombreEntidad,
        "id_depto": idDepto,
        "id_institucion": idInstitucion,
        "id_persona": idPersona,
        "mensaje": mensaje,
        "fecha": fecha == null ? null : fecha!.toIso8601String(),
        "fecha_parse": fechaParse,
        "add_link": addLink,
        "link": link ?? '',
        "add_video": addVideo,
        "video_url": videoUrl ?? '',
        "add_archivo": addArchivo,
        "archivo_url": archivoUrl ?? '',
        "archivo_name": archivoName,
        "imagen_url": imagenUrl ?? '',
        "imagen_default_url": imagenDefaultUrl ?? '',
        "estado": estado,
        "ids_fcm_app": idsFcmApp,
        "is_scheduled": isScheduled,
        "persona_fullname": personaFullname,
        "persona_avatar": personaAvatar,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
