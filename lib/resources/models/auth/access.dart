import 'dart:convert';

Access accessFromJson(String str) => Access.fromJson(json.decode(str));

String accessToJson(Access data) => json.encode(data.toJson());

class Access {
  Access({
    required this.accessToken,
    required this.fullname,
    required this.idPersona,
    required this.imagenUrl,
    required this.token,
  });

  String accessToken;
  String fullname;
  int idPersona;
  String imagenUrl;
  String token;

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        accessToken: json["access_token"],
        fullname: json["fullname"],
        idPersona: json["id_persona"],
        imagenUrl: json["imagen_url"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "fullname": fullname,
        "id_persona": idPersona,
        "imagen_url": imagenUrl,
        "token": token,
      };
}
