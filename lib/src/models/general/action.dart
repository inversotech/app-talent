// To parse this JSON data, do
//
//     final actionModule = actionModuleFromJson(jsonString);

import 'dart:convert';

ActionModule actionModuleFromJson(String str) => ActionModule.fromJson(json.decode(str));

String actionModuleToJson(ActionModule data) => json.encode(data.toJson());

class ActionModule {
    ActionModule({
        this.idModulo,
        this.idRol,
        this.rol,
        this.acceso,
        this.clave,
        this.metodo,
        this.codigo,
        this.valor,
    });

    String? idModulo;
    String? idRol;
    String? rol;
    String? acceso;
    String? clave;
    String? metodo;
    String? codigo;
    String? valor;

    factory ActionModule.fromJson(Map<String, dynamic> json) => ActionModule(
        idModulo: json["id_modulo"] == null ? null : json["id_modulo"],
        idRol: json["id_rol"] == null ? null : json["id_rol"],
        rol: json["rol"] == null ? null : json["rol"],
        acceso: json["acceso"] == null ? null : json["acceso"],
        clave: json["clave"] == null ? null : json["clave"],
        metodo: json["metodo"] == null ? null : json["metodo"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        valor: json["valor"] == null ? null : json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id_modulo": idModulo == null ? null : idModulo,
        "id_rol": idRol == null ? null : idRol,
        "rol": rol == null ? null : rol,
        "acceso": acceso == null ? null : acceso,
        "clave": clave == null ? null : clave,
        "metodo": metodo == null ? null : metodo,
        "codigo": codigo == null ? null : codigo,
        "valor": valor == null ? null : valor,
    };
}
