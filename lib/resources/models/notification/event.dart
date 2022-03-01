// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) => EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
    EventModel({
        this.idEvento,
        this.idEntidad,
        this.nombreEntidad,
        this.idDepto,
        this.idInstitucion,
        this.idPersona,
        this.nombre,
        this.fechaInicio,
        this.fechaFin,
        this.lugar,
        this.informacion,
        this.addLink,
        this.link,
        this.addVideo,
        this.videoUrl,
        this.addArchivo,
        this.archivoUrl,
        this.archivoName,
        this.imagenUrl,
        this.imagenDefaultUrl,
        this.addBtnAsistir,
        this.addNotificaciones,
        this.addHoraFinalizacion,
        this.showFechaHora,
        this.idsFcmApp,
        this.dayBeforeEvent,
        this.estado,
        this.fechaParse,
        this.personaFullname,
        this.personaAvatar,
        this.createdAt,
        this.updatedAt,
    });

    int? idEvento;
    String? idEntidad;
    String? nombreEntidad;
    String? idDepto;
    String? idInstitucion;
    String? idPersona;
    String? nombre;
    DateTime? fechaInicio;
    DateTime? fechaFin;
    String? lugar;
    String? informacion;
    String? addLink;
    String? link;
    String? addVideo;
    String? videoUrl;
    String? addArchivo;
    String? archivoUrl;
    String? archivoName;
    String? imagenUrl;
    String? imagenDefaultUrl;
    String? addBtnAsistir;
    String? addNotificaciones;
    String? addHoraFinalizacion;
    String? showFechaHora;
    String? idsFcmApp;
    String? dayBeforeEvent;
    String? estado;
    String? fechaParse;
    String? personaFullname;
    String? personaAvatar;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        idEvento: json["id_evento"],
        idEntidad: json["id_entidad"],
        nombreEntidad: json["nombre_entidad"],
        idDepto: json["id_depto"],
        idInstitucion: json["id_institucion"],
        idPersona: json["id_persona"],
        nombre: json["nombre"],
        fechaInicio: json["fecha_inicio"] == null ? null : DateTime.parse(json["fecha_inicio"]),
        fechaFin: json["fecha_fin"] == null ? null : DateTime.parse(json["fecha_fin"]),
        lugar: json["lugar"],
        informacion: json["informacion"],
        addLink: json["add_link"],
        link: json["link"],
        addVideo: json["add_video"],
        videoUrl: json["video_url"],
        addArchivo: json["add_archivo"],
        archivoUrl: json["archivo_url"],
        archivoName: json["archivo_name"],
        imagenUrl: json["imagen_url"],
        imagenDefaultUrl: json["imagen_default_url"],
        addBtnAsistir: json["add_btn_asistir"],
        addNotificaciones: json["add_notificaciones"],
        addHoraFinalizacion: json["add_hora_finalizacion"],
        showFechaHora: json["show_fecha_hora"],
        idsFcmApp: json["ids_fcm_app"],
        dayBeforeEvent: json["day_before_event"],
        estado: json["estado"],
        fechaParse: json["fecha_parse"],
        personaFullname: json["persona_fullname"],
        personaAvatar: json["persona_avatar"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_evento": idEvento,
        "id_entidad": idEntidad,
        "nombre_entidad": nombreEntidad,
        "id_depto": idDepto,
        "id_institucion": idInstitucion,
        "id_persona": idPersona,
        "nombre": nombre,
        "fecha_inicio": fechaInicio == null ? null : fechaInicio!.toIso8601String(),
        "fecha_fin": fechaFin == null ? null : fechaFin!.toIso8601String(),
        "lugar": lugar,
        "informacion": informacion,
        "add_link": addLink,
        "link": link,
        "add_video": addVideo,
        "video_url": videoUrl,
        "add_archivo": addArchivo,
        "archivo_url": archivoUrl,
        "archivo_name": archivoName,
        "imagen_url": imagenUrl,
        "imagen_default_url": imagenDefaultUrl,
        "add_btn_asistir": addBtnAsistir,
        "add_notificaciones": addNotificaciones,
        "add_hora_finalizacion": addHoraFinalizacion,
        "show_fecha_hora": showFechaHora,
        "ids_fcm_app": idsFcmApp,
        "day_before_event": dayBeforeEvent,
        "estado": estado,
        "fecha_parse": fechaParse,
        "persona_fullname": personaFullname,
        "persona_avatar": personaAvatar,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
