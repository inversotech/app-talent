// To parse this JSON data, do
//
//     final surveyItem = surveyItemFromJson(jsonString);

import 'dart:convert';

SurveyItem surveyItemFromJson(String str) => SurveyItem.fromJson(json.decode(str));

String surveyItemToJson(SurveyItem data) => json.encode(data.toJson());

class SurveyItem {
    SurveyItem({
        this.idItem,
        this.idParent,
        this.titulo,
        this.codigo,
        this.descripcion,
        this.order,
        this.childrenAlign,
        this.idUserReg,
        this.idUserMod,
        this.fechaReg,
        this.fechaMod,
        this.idTipoItem,
        this.idEncuesta,
        this.tipoItemCodigo,
        this.tipoItemNombre,
        this.idTipoPregunta,
        this.nroAlternativas,
        this.obligatorio,
        this.ayuda,
        this.orientacion,
        this.tipoPreguntaNombre,
        this.tipoPreguntaCodigo,
        this.tipo,
        this.tipoComponente,
        this.items,
        this.idItemSeleccionado,
        this.valorInicial,
        this.respuesta
    });

    String? idItem;
    String? idParent;
    String? titulo;
    String? codigo;
    String? descripcion;
    String? order;
    String? childrenAlign;
    String? idUserReg;
    String? idUserMod;
    DateTime? fechaReg;
    DateTime? fechaMod;
    String? idTipoItem;
    String? idEncuesta;
    String? tipoItemCodigo;
    String? tipoItemNombre;
    String? idTipoPregunta;
    String? nroAlternativas;
    String? obligatorio;
    String? ayuda;
    String? orientacion;
    String? tipoPreguntaNombre;
    String? tipoPreguntaCodigo;
    String? tipo;
    String? tipoComponente;
    List<SurveyItem>? items;
    String? idItemSeleccionado;
    String? valorInicial;
    String? respuesta;

    factory SurveyItem.fromJson(Map<String, dynamic> json) => SurveyItem(
        idItem: json["id_item"],
        idParent: json["id_parent"],
        titulo: json["titulo"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        order: json["order"],
        childrenAlign: json["children_align"],
        idUserReg: json["id_user_reg"],
        idUserMod: json["id_user_mod"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        idTipoItem: json["id_tipo_item"],
        idEncuesta: json["id_encuesta"],
        tipoItemCodigo: json["tipo_item_codigo"],
        tipoItemNombre: json["tipo_item_nombre"],
        idTipoPregunta: json["id_tipo_pregunta"],
        nroAlternativas: json["nro_alternativas"],
        obligatorio: json["obligatorio"],
        ayuda: json["ayuda"],
        orientacion: json["orientacion"],
        tipoPreguntaNombre: json["tipo_pregunta_nombre"],
        tipoPreguntaCodigo: json["tipo_pregunta_codigo"],
        tipo: json["tipo"],
        tipoComponente: json["tipo_componente"],
        items: json["items"] == null ? [] : (json["items"] as List).map((jsonElement) => SurveyItem.fromJson(jsonElement)).toList(),
        idItemSeleccionado: json["id_item_seleccionado"],
        valorInicial: json["valor_inicial"],
        respuesta: json["respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "id_item": idItem,
        "id_parent": idParent,
        "titulo": titulo,
        "codigo": codigo,
        "descripcion": descripcion,
        "order": order,
        "children_align": childrenAlign,
        "id_user_reg": idUserReg,
        "id_user_mod": idUserMod,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "id_tipo_item": idTipoItem,
        "id_encuesta": idEncuesta,
        "tipo_item_codigo": tipoItemCodigo,
        "tipo_item_nombre": tipoItemNombre,
        "id_tipo_pregunta": idTipoPregunta,
        "nro_alternativas": nroAlternativas,
        "obligatorio": obligatorio,
        "ayuda": ayuda,
        "orientacion": orientacion,
        "tipo_pregunta_nombre": tipoPreguntaNombre,
        "tipo_pregunta_codigo": tipoPreguntaCodigo,
        "tipo": tipo,
        "tipo_componente": tipoComponente,
        "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toJson())),
        "id_item_seleccionado": idItemSeleccionado,
        "valor_inicial": valorInicial,
        "respuesta": respuesta,
    };
}
