// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationGeneralModel notificationModelFromJson(String str) => NotificationGeneralModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationGeneralModel data) => json.encode(data.toJson());

class NotificationGeneralModel {
    NotificationGeneralModel({
        this.codigo,
        this.id,
        this.idPersona,
        this.mensaje,
        this.descripcion,
        this.direccion,
        this.fechaInicio,
        this.fechaFin,
        this.addBtnAsistir,
        this.showFechaHora,
        this.addLink,
        this.link,
        this.addArchivo,
        this.archivoName,
        this.archivoUrl,
        this.addVideo,
        this.videoUrl,
        this.imagenUrl,
        this.estado,
        this.grupos,
        this.fotos
    });

    String? codigo;
    String? id;
    String? idPersona;
    String? mensaje;
    String? descripcion;
    String? direccion;
    DateTime? fechaInicio;
    DateTime? fechaFin;
    String? addBtnAsistir;
    String? showFechaHora;
    String? addLink;
    String? link;
    String? addArchivo;
    String? archivoName;
    String? archivoUrl;
    String? addVideo;
    String? videoUrl;
    String? imagenUrl;
    String? estado;
    List<Grupo>? grupos;
    List<Foto>? fotos;

    factory NotificationGeneralModel.fromJson(Map<String, dynamic> json) => NotificationGeneralModel(
        codigo: json["codigo"],
        id: json["id"],
        idPersona: json["id_persona"],
        mensaje: json["mensaje"],
        descripcion: json["descripcion"],
        direccion: json["direccion"],
        fechaInicio: json["fecha_inicio"] == null ? null : DateTime.parse(json["fecha_inicio"]),
        fechaFin: json["fecha_fin"] == null ? null : DateTime.parse(json["fecha_fin"]),
        addBtnAsistir: json["add_btn_asistir"],
        showFechaHora: json["show_fecha_hora"],
        addLink: json["add_link"],
        link: json["link"],
        addArchivo: json["add_archivo"],
        archivoName: json["archivo_name"],
        archivoUrl: json["archivo_url"],
        addVideo: json["add_video"],
        videoUrl: json["video_url"],
        imagenUrl: json["imagen_url"],
        estado: json["estado"],
        grupos: json["grupos"] == null ? [] : (json["grupos"] as List).map((jsonElement) => Grupo.fromJson(jsonElement))
          .toList(),
        fotos: json["fotos"] == null ? [] : (json["fotos"] as List).map((jsonElement) => Foto.fromJson(jsonElement))
          .toList(),
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "id": id,
        "id_persona": idPersona,
        "mensaje": mensaje,
        "descripcion": descripcion,
        "direccion": direccion,
        "fecha_inicio": fechaInicio == null ? null : fechaInicio!.toIso8601String(),
        "fecha_fin": fechaFin == null ? null : fechaFin!.toIso8601String(),
        "add_btn_asistir": addBtnAsistir,
        "show_fecha_hora": showFechaHora,
        "add_link": addLink,
        "link": link,
        "add_archivo": addArchivo,
        "archivo_name": archivoName,
        "archivo_url": archivoUrl,
        "add_video": addVideo,
        "video_url": videoUrl,
        "imagen_url": imagenUrl,
        "estado": estado,
        "grupos": grupos == null ? null :  List<dynamic>.from(grupos!.map((x) => x.toJson())),
        "fotos": fotos == null ? null : List<dynamic>.from(fotos!.map((x) => x.toJson())),
    };
}

class Grupo {
    Grupo({
        this.idGrupo,
        this.grupoNombre,
        this.grupoDescripcion,
    });

    int? idGrupo;
    String? grupoNombre;
    String? grupoDescripcion;

    factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
        idGrupo: json["id_grupo"] == null ? 0 : int.parse(json["id_grupo"].toString()),
        grupoNombre: json["grupo_nombre"],
        grupoDescripcion: json["grupo_descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id_grupo": idGrupo,
        "grupo_nombre": grupoNombre,
        "grupo_descripcion": grupoDescripcion,
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
        this.like=false
    });

    int? idAfoto;
    int? idAlbum;
    String? descripcion;
    int? countLikes;
    int? countComentarios;
    String? imagenUrl;
    DateTime? createdAt;
    DateTime? updatedAt;
    bool like;

    factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        idAfoto: json["id_afoto"] == null ? 0 : int.parse(json["id_afoto"].toString()),
        idAlbum: json["id_album"] == null ? 0 : int.parse(json["id_album"].toString()),
        descripcion: json["descripcion"],
        countLikes: json["count_likes"] == null ? 0 : int.parse(json["count_likes"].toString()),
        countComentarios: json["count_comentarios"] == null ? 0 : int.parse(json["count_comentarios"].toString()),
        imagenUrl: json["imagen_url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        like: json["like"] == null ? false : json["like"].toString().toLowerCase() == 'true',
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
        "like": like,
    };
}
