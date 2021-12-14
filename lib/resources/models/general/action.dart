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
        idModulo: json["id_modulo"],
        idRol: json["id_rol"],
        rol: json["rol"],
        acceso: json["acceso"],
        clave: json["clave"],
        metodo: json["metodo"],
        codigo: json["codigo"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id_modulo": idModulo,
        "id_rol": idRol,
        "rol": rol,
        "acceso": acceso,
        "clave": clave,
        "metodo": metodo,
        "codigo": codigo,
        "valor": valor,
    };
}
