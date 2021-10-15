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
        idItem: json["id_item"] == null ? null : json["id_item"],
        idParent: json["id_parent"] == null ? null : json["id_parent"],
        titulo: json["titulo"] == null ? null : json["titulo"],
        codigo: json["codigo"] == null ? null : json["codigo"],
        descripcion: json["descripcion"] == null ? null : json["descripcion"],
        order: json["order"] == null ? null : json["order"],
        childrenAlign: json["children_align"] == null ? null : json["children_align"],
        idUserReg: json["id_user_reg"] == null ? null : json["id_user_reg"],
        idUserMod: json["id_user_mod"] == null ? null : json["id_user_mod"],
        fechaReg: json["fecha_reg"] == null ? null : DateTime.parse(json["fecha_reg"]),
        fechaMod: json["fecha_mod"] == null ? null : DateTime.parse(json["fecha_mod"]),
        idTipoItem: json["id_tipo_item"] == null ? null : json["id_tipo_item"],
        idEncuesta: json["id_encuesta"] == null ? null : json["id_encuesta"],
        tipoItemCodigo: json["tipo_item_codigo"] == null ? null : json["tipo_item_codigo"],
        tipoItemNombre: json["tipo_item_nombre"] == null ? null : json["tipo_item_nombre"],
        idTipoPregunta: json["id_tipo_pregunta"] == null ? null : json["id_tipo_pregunta"],
        nroAlternativas: json["nro_alternativas"] == null ? null : json["nro_alternativas"],
        obligatorio: json["obligatorio"] == null ? null : json["obligatorio"],
        ayuda: json["ayuda"] == null ? null : json["ayuda"],
        orientacion: json["orientacion"] == null ? null : json["orientacion"],
        tipoPreguntaNombre: json["tipo_pregunta_nombre"] == null ? null : json["tipo_pregunta_nombre"],
        tipoPreguntaCodigo: json["tipo_pregunta_codigo"] == null ? null : json["tipo_pregunta_codigo"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        tipoComponente: json["tipo_componente"] == null ? null : json["tipo_componente"],
        items: json["items"] == null ? [] : (json["items"] as List).map((jsonElement) => SurveyItem.fromJson(jsonElement)).toList(),
        idItemSeleccionado: json["id_item_seleccionado"] == null ? null : json["id_item_seleccionado"],
        valorInicial: json["valor_inicial"] == null ? null : json["valor_inicial"],
        respuesta: json["respuesta"] == null ? null : json["respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "id_item": idItem == null ? null : idItem,
        "id_parent": idParent == null ? null : idParent,
        "titulo": titulo == null ? null : titulo,
        "codigo": codigo == null ? null : codigo,
        "descripcion": descripcion == null ? null : descripcion,
        "order": order == null ? null : order,
        "children_align": childrenAlign == null ? null : childrenAlign,
        "id_user_reg": idUserReg == null ? null : idUserReg,
        "id_user_mod": idUserMod == null ? null : idUserMod,
        "fecha_reg": fechaReg == null ? null : fechaReg!.toIso8601String(),
        "fecha_mod": fechaMod == null ? null : fechaMod!.toIso8601String(),
        "id_tipo_item": idTipoItem == null ? null : idTipoItem,
        "id_encuesta": idEncuesta == null ? null : idEncuesta,
        "tipo_item_codigo": tipoItemCodigo == null ? null : tipoItemCodigo,
        "tipo_item_nombre": tipoItemNombre == null ? null : tipoItemNombre,
        "id_tipo_pregunta": idTipoPregunta == null ? null : idTipoPregunta,
        "nro_alternativas": nroAlternativas == null ? null : nroAlternativas,
        "obligatorio": obligatorio == null ? null : obligatorio,
        "ayuda": ayuda == null ? null : ayuda,
        "orientacion": orientacion == null ? null : orientacion,
        "tipo_pregunta_nombre": tipoPreguntaNombre == null ? null : tipoPreguntaNombre,
        "tipo_pregunta_codigo": tipoPreguntaCodigo == null ? null : tipoPreguntaCodigo,
        "tipo": tipo == null ? null : tipo,
        "tipo_componente": tipoComponente == null ? null : tipoComponente,
        "items": items == null ? null : List<dynamic>.from(items!.map((x) => x.toJson())),
        "id_item_seleccionado": idItemSeleccionado == null ? null : idItemSeleccionado,
        "valor_inicial": valorInicial == null ? null : valorInicial,
        "respuesta": respuesta == null ? null : respuesta,
    };
}
