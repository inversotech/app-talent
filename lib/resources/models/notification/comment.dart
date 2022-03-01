// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
    CommentModel({
        this.idComentario,
        this.idParent,
        this.idPersona,
        this.origen,
        this.idOrigen,
        this.mensaje,
        this.fechaParse,
        this.personaFullname,
        this.personaAvatar,  
        this.like = false,
        this.countLikes,
        this.countComentarios,
        this.comentarios,
        this.createdAt,
        this.updatedAt,
        this.page = 1,
        this.showMore = true,
        this.pressDelete = false,
    });

    int? idComentario;
    String? idParent;
    String? idPersona;
    String? origen;
    String? idOrigen;
    String? mensaje;
    String? fechaParse;
    String? personaFullname;
    String? personaAvatar;
    bool like;
    int? countLikes;
    int? countComentarios;
    List<CommentModel>? comentarios;
    DateTime? createdAt;
    DateTime? updatedAt;
    int page;
    bool showMore;
    bool pressDelete;

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        idComentario: json["id_comentario"],
        idParent: json["id_parent"] ?? '',
        idPersona: json["id_persona"],
        origen: json["origen"],
        idOrigen: json["id_origen"],
        mensaje: json["mensaje"],
        fechaParse: json["fecha_parse"],
        personaFullname: json["persona_fullname"],
        personaAvatar: json["persona_avatar"],
        like: json["like"] == null ? false : json["like"].toString().toLowerCase() == 'true',
        countLikes: json["count_likes"] == null ? 0 : int.parse(json["count_likes"].toString()),
        countComentarios: json["count_comentarios"] == null ? 0 : int.parse(json["count_comentarios"].toString()),
        comentarios: json["comentarios"] == null ? [] : (json["comentarios"] as List).map((jsonElement) => CommentModel.fromJson(jsonElement))
          .toList(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        page: json["page"] == null ? 1 : int.parse(json["page"].toString()),
        showMore: json["show_more"] == null ? true : json["show_more"].toString().toLowerCase() == 'true',
        pressDelete: json["press_delete"] == null ? false : json["press_delete"].toString().toLowerCase() == 'true',
    );

    Map<String, dynamic> toJson() => {
        "id_comentario": idComentario,
        "id_parent": idParent,
        "id_persona": idPersona,
        "origen": origen,
        "id_origen": idOrigen,
        "mensaje": mensaje,
        "fecha_parse": fechaParse,
        "persona_fullname": personaFullname,
        "persona_avatar": personaAvatar,
        "like": like,
        "count_likes": countLikes,
        "count_comentarios": countComentarios,
        "comentarios": comentarios == null ? null :  List<dynamic>.from(comentarios!.map((x) => x.toJson())),
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "page": page,
        "show_more": showMore,
        "press_delete": pressDelete,
    };
}
