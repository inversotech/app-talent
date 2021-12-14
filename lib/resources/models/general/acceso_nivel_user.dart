// To parse this JSON data, do
//
//     final accesoNivelUser = accesoNivelUserFromJson(jsonString);

import 'dart:convert';

AccesoNivelUser accesoNivelUserFromJson(String str) => AccesoNivelUser.fromJson(json.decode(str));

String accesoNivelUserToJson(AccesoNivelUser data) => json.encode(data.toJson());

class AccesoNivelUser {
    AccesoNivelUser({
        this.accesoNivel,
        this.modulo,
    });

    AccesoNivel? accesoNivel;
    Modulo? modulo;

    factory AccesoNivelUser.fromJson(Map<String, dynamic> json) => AccesoNivelUser(
        accesoNivel: json["acceso_nivel"] == null ? AccesoNivel.fromJsonNull() : AccesoNivel.fromJson(json["acceso_nivel"]),
        modulo: json["modulo"] == null ? Modulo.fromNull() : Modulo.fromJson(json["modulo"]),
    );

    Map<String, dynamic> toJson() => {
        "acceso_nivel": accesoNivel!.toJson(),
        "modulo": modulo!.toJson(),
    };
}

class AccesoNivel {
    AccesoNivel({
        this.codigo,
        this.comentario,
        this.idAccesoNivel,
        this.idArea,
        this.idDepto,
        this.idEntidad,
        this.idEntidadFilter,
        this.idModulo,
        this.idPersona,
        this.idTipoNivelArea,
        this.idTipoNivelVista,
        this.idTrabajador,
        this.nivelhijo,
        this.nombreNivel,
        this.usuario,
    });

    String? codigo;
    String? comentario;
    String? idAccesoNivel;
    String? idArea;
    String? idDepto;
    String? idEntidad;
    String? idEntidadFilter;
    String? idModulo;
    String? idPersona;
    String? idTipoNivelArea;
    String? idTipoNivelVista;
    String? idTrabajador;
    String? nivelhijo;
    String? nombreNivel;
    String? usuario;

    factory AccesoNivel.fromJson(Map<String, dynamic> json) => AccesoNivel(
        codigo: json["codigo"],
        comentario: json["comentario"],
        idAccesoNivel: json["id_acceso_nivel"],
        idArea: json["id_area"],
        idDepto: json["id_depto"],
        idEntidad: json["id_entidad"],
        idEntidadFilter: json["id_entidad_filter"],
        idModulo: json["id_modulo"],
        idPersona: json["id_persona"],
        idTipoNivelArea: json["id_tipo_nivel_area"],
        idTipoNivelVista: json["id_tipo_nivel_vista"],
        idTrabajador: json["id_trabajador"],
        nivelhijo: json["nivelhijo"],
        nombreNivel: json["nombre_nivel"],
        usuario: json["usuario"],
    );

  factory AccesoNivel.fromJsonNull() => AccesoNivel(
        codigo: null,
        comentario: null,
        idAccesoNivel: null,
        idArea: null,
        idDepto: null,
        idEntidad: null,
        idEntidadFilter: null,
        idModulo: null,
        idPersona: null,
        idTipoNivelArea: null,
        idTipoNivelVista: null,
        idTrabajador:null,
        nivelhijo: null,
        nombreNivel: null,
        usuario: null,
    );
    
    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "comentario": comentario,
        "id_acceso_nivel": idAccesoNivel,
        "id_area": idArea,
        "id_depto": idDepto,
        "id_entidad": idEntidad,
        "id_entidad_filter": idEntidadFilter,
        "id_modulo": idModulo,
        "id_persona": idPersona,
        "id_tipo_nivel_area": idTipoNivelArea,
        "id_tipo_nivel_vista": idTipoNivelVista,
        "id_trabajador": idTrabajador,
        "nivelhijo": nivelhijo,
        "nombre_nivel": nombreNivel,
        "usuario": usuario,
    };
}

class Modulo {
    Modulo({
        this.accesoxnivel,
        this.idModulo,
    });

    String? accesoxnivel;
    String? idModulo;

    factory Modulo.fromJson(Map<String, dynamic> json) => Modulo(
        accesoxnivel: json["accesoxnivel"],
        idModulo: json["id_modulo"],
    );
factory Modulo.fromNull() => Modulo(
        accesoxnivel: null,
        idModulo: null,
    );
    Map<String, dynamic> toJson() => {
        "accesoxnivel": accesoxnivel,
        "id_modulo": idModulo,
    };
}
