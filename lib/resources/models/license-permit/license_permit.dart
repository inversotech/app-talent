// To parse this JSON data, do
//
//     final licensePermitModel = licensePermitModelFromJson(jsonString);

import 'dart:convert';

LicensePermitModel licensePermitModelFromJson(String str) => LicensePermitModel.fromJson(json.decode(str));

String licensePermitModelToJson(LicensePermitModel data) => json.encode(data.toJson());

class LicensePermitModel {
    LicensePermitModel({
        this.idLicenciaPermiso,
        this.adjunto,
        this.idConceptoPermLic,
        this.nombreCortoTipoConcepto,
        this.motivo,
        this.idTrabajador,
        this.nombre,
        this.nombreCorto,
        this.fechaDesde,
        this.nomperiodo,
        this.fechaHasta,
        this.horaInicio,
        this.horaFin,
        this.periodo,
        this.dias,
        this.horas,
        this.estadoNombre,
        this.idEstadoLicaPer,
        this.formato,
        this.tipo,
        this.idTipoPermLic,
        this.nombreTipoPermLic,
        this.codigoTipoPermLic,
        this.idTipoInstAtencion,
        this.nombreInst,
        this.codigocitt,
        this.adjuntocitt,
        this.adjuntovoucher,
        this.codigonit,
        this.adjuntonit,
        this.codigoviva,
        this.adjuntoviva,
        this.numdocumento,
        this.tipoPermLic,
        this.nombreConcepto,
        this.codigoConcepto,
        this.engrupo,
        this.goce
    });


    String? idLicenciaPermiso;
    String? adjunto;
    String? idConceptoPermLic;
    String? nombreCortoTipoConcepto;
    String? motivo;
    String? idTrabajador;
    String? nombre;
    String? nombreCorto;
    String? fechaDesde;
    String? nomperiodo;
    String? fechaHasta;
    String? horaInicio;
    String? horaFin;
    String? periodo;
    String? dias;
    String? horas;
    String? estadoNombre;
    String? idEstadoLicaPer;
    String? formato;
    String? tipo;
    String? idTipoPermLic;
    String? nombreTipoPermLic;
    String? codigoTipoPermLic;
    String? idTipoInstAtencion;
    String? nombreInst;
    String? codigocitt;
    String? adjuntocitt;
    String? adjuntovoucher;
    String? codigonit;
    String? adjuntonit;
    String? codigoviva;
    String? adjuntoviva;
    String? numdocumento;
    String? tipoPermLic;
    String? nombreConcepto;
    String? codigoConcepto;
    String? engrupo;
    String? goce;



    factory LicensePermitModel.fromJson(Map<String, dynamic> json) => LicensePermitModel(
        idLicenciaPermiso: json["id_licencia_permiso"],
        adjunto: json["adjunto"],
        idConceptoPermLic: json["id_concepto_perm_lic"],
        nombreCortoTipoConcepto: json["nombre_corto_tipo_concepto"],
        motivo: json["motivo"],
        nombre: json["nombre"],
        idTrabajador: json["id_trabajador"],
        nombreCorto: json["nombre_corto"],
        fechaDesde: json["fecha_desde"],
        nomperiodo: json["nomperiodo"],
        fechaHasta: json["fecha_hasta"],
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        periodo: json["periodo"],
        dias: json["dias"],        
        horas: json["horas"],
        estadoNombre: json["estado_nombre"],
        idEstadoLicaPer: json["id_estado_lica_per"],
        formato: json["formato"],
        tipo: json["tipo"],
        idTipoPermLic: json["id_tipo_perm_lic"],
        nombreTipoPermLic: json["nombre_tipo_perm_lic"],
        codigoTipoPermLic: json["codigo_tipo_perm_lic"],
        idTipoInstAtencion: json["id_tipo_inst_atencion"],
        nombreInst: json["nombre_inst"],
        codigocitt: json["codigocitt"],
        adjuntocitt: json["adjuntocitt"],
        adjuntovoucher: json["adjuntovoucher"],
        codigonit: json["codigonit"],
        adjuntonit: json["adjuntonit"],
        codigoviva: json["codigoviva"],
        adjuntoviva: json["adjuntoviva"],
        numdocumento: json["numdocumento"],
        tipoPermLic: json["tipo_perm_lic"],
        nombreConcepto: json["nombre_concepto"],
        codigoConcepto: json["codigo_concepto"],
        engrupo: json["engrupo"],
        goce: json["goce"],
    );

    Map<String, dynamic> toJson() => {
        "id_licencia_permiso": idLicenciaPermiso,
        "adjunto": adjunto,
        "id_concepto_perm_lic": idConceptoPermLic,
        "nombre_corto_tipo_concepto": nombreCortoTipoConcepto,
        "motivo": motivo,
        "nombre": nombre,
        "id_trabajador": idTrabajador,
        "nombre_corto": nombreCorto,
        "fecha_desde": fechaDesde,
        "nomperiodo": nomperiodo,
        "fecha_hasta": fechaHasta,
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "periodo": periodo,
        "dias": dias,
        "horas": horas,
        "estado_nombre": estadoNombre,
        "id_estado_lica_per": idEstadoLicaPer,
        "formato": formato,
        "tipo": tipo,
        "id_tipo_perm_lic": idTipoPermLic,
        "nombre_tipo_perm_lic": nombreTipoPermLic,
        "codigo_tipo_perm_lic": codigoTipoPermLic,
        "id_tipo_inst_atencion": idTipoInstAtencion,
        "nombre_inst": nombreInst,
        "codigocitt": codigocitt,
        "adjuntocitt": adjuntocitt,
        "adjuntovoucher": adjuntovoucher,
        "codigonit": codigonit,
        "adjuntonit": adjuntonit,
        "codigoviva": codigoviva,
        "adjuntoviva": adjuntoviva,
        "numdocumento": numdocumento,
        "tipo_perm_lic": tipoPermLic,
        "nombre_concepto": nombreConcepto,
        "codigo_concepto": codigoConcepto,
        "engrupo": engrupo,
        "goce": goce,
    };
}
