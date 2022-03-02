// To parse this JSON data, do
//
//     final relationPersonModel = relationPersonModelFromJson(jsonString);

import 'dart:convert';

RelationPersonModel relationPersonModelFromJson(String str) => RelationPersonModel.fromJson(json.decode(str));

String relationPersonModelToJson(RelationPersonModel data) => json.encode(data.toJson());

class RelationPersonModel {
    RelationPersonModel({
        this.idPersona,
        this.origen,
        this.idOrigen,
        this.estaLeido,
        this.seraParticipante,
        this.fechaParse,
        this.personaFullname,
        this.personaAvatar,
        this.numDocumento,
        this.createdAt,
        this.updatedAt,
    });

    String? idPersona;
    String? origen;
    String? idOrigen;
    String? estaLeido;
    String? seraParticipante;
    String? fechaParse;
    String? personaFullname;
    String? personaAvatar;
    String? numDocumento;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory RelationPersonModel.fromJson(Map<String, dynamic> json) => RelationPersonModel(
        idPersona: json["id_persona"],
        origen: json["origen"],
        idOrigen: json["id_origen"],
        estaLeido: json["esta_leido"],
        seraParticipante: json["sera_participante"],
        fechaParse: json["fecha_parse"],
        personaFullname: json["persona_fullname"],
        personaAvatar: json["persona_avatar"],
        numDocumento: json["num_documento"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_persona": idPersona,
        "origen": origen,
        "id_origen": idOrigen,
        "esta_leido": estaLeido,
        "sera_participante": seraParticipante,
        "fecha_parse": fechaParse,
        "persona_fullname": personaFullname,
        "persona_avatar": personaAvatar,
        "num_documento": numDocumento,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
