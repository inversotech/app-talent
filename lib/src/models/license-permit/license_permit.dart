// To parse this JSON data, do
//
//     final licensePermitModel = licensePermitModelFromJson(jsonString);

import 'dart:convert';

LicensePermitModel licensePermitModelFromJson(String str) => LicensePermitModel.fromJson(json.decode(str));

String licensePermitModelToJson(LicensePermitModel data) => json.encode(data.toJson());

class LicensePermitModel {
    LicensePermitModel({
        this.idLicenciaPermiso,
        this.idEntidad,
        this.adjunto,
        this.idConceptoPermLic,
        this.nombreCortoTipoConcepto,
        this.idDepto,
        this.area,
        this.motivo,
        this.nombre,
        this.nombreCorto,
        this.convenio,
        this.conveniosinfirmar,
        this.conconvenio,
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
        this.codigoTipoPerLic,
        this.nombreConcepto,
        this.codigoConcepto,
        this.engrupo,
        this.tipoInstAtencion,
        this.codigoTipoInst,
        this.tipoSuspension,
        this.cantidadDetalle,
        this.goce
    });


    String? idLicenciaPermiso;
    String? idEntidad;
    String? adjunto;
    String? idConceptoPermLic;
    String? nombreCortoTipoConcepto;
    String? idDepto;
    String? area;
    String? motivo;
    String? nombre;
    String? nombreCorto;
    String? convenio;
    String? conveniosinfirmar;
    String? conconvenio;
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
    String? codigoTipoPerLic;
    String? nombreConcepto;
    String? codigoConcepto;
    String? engrupo;
    String? tipoInstAtencion;
    String? codigoTipoInst;
    String? tipoSuspension;
    String? cantidadDetalle;
    String? goce;



    factory LicensePermitModel.fromJson(Map<String, dynamic> json) => LicensePermitModel(
        idLicenciaPermiso: json["id_licencia_permiso"] == null ? null : json["id_licencia_permiso"],
        idEntidad: json["id_entidad"] == null ? null : json["id_entidad"],
        adjunto: json["adjunto"] == null ? null : json["adjunto"],
        idConceptoPermLic: json["id_concepto_perm_lic"] == null ? null : json["id_concepto_perm_lic"],
        nombreCortoTipoConcepto: json["nombre_corto_tipo_concepto"] == null ? null : json["nombre_corto_tipo_concepto"],
        idDepto: json["id_depto"] == null ? null : json["id_depto"],
        area: json["area"] == null ? null : json["area"],
        motivo: json["motivo"] == null ? null : json["motivo"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        nombreCorto: json["nombre_corto"] == null ? null : json["nombre_corto"],
        convenio: json["convenio"] == null ? null : json["convenio"],
        conveniosinfirmar: json["conveniosinfirmar"] == null ? null : json["conveniosinfirmar"],
        conconvenio: json["conconvenio"] == null ? null : json["conconvenio"],
        fechaDesde: json["fecha_desde"] == null ? null : json["fecha_desde"],
        nomperiodo: json["nomperiodo"] == null ? null : json["nomperiodo"],
        fechaHasta: json["fecha_hasta"] == null ? null : json["fecha_hasta"],
        horaInicio: json["hora_inicio"] == null ? null : json["hora_inicio"],
        horaFin: json["hora_fin"] == null ? null : json["hora_fin"],
        periodo: json["periodo"] == null ? null : json["periodo"],
        dias: json["dias"] == null ? null : json["dias"],        
        horas: json["horas"] == null ? null : json["horas"],
        estadoNombre: json["estado_nombre"] == null ? null : json["estado_nombre"],
        idEstadoLicaPer: json["id_estado_lica_per"] == null ? null : json["id_estado_lica_per"],
        formato: json["formato"] == null ? null : json["formato"],
        tipo: json["tipo"] == null ? null : json["tipo"],
        idTipoPermLic: json["id_tipo_perm_lic"] == null ? null : json["id_tipo_perm_lic"],
        nombreTipoPermLic: json["nombre_tipo_perm_lic"] == null ? null : json["nombre_tipo_perm_lic"],
        codigoTipoPermLic: json["codigo_tipo_perm_lic"] == null ? null : json["codigo_tipo_perm_lic"],
        idTipoInstAtencion: json["id_tipo_inst_atencion"] == null ? null : json["id_tipo_inst_atencion"],
        nombreInst: json["nombre_inst"] == null ? null : json["nombre_inst"],
        codigocitt: json["codigocitt"] == null ? null : json["codigocitt"],
        adjuntocitt: json["adjuntocitt"] == null ? null : json["adjuntocitt"],
        adjuntovoucher: json["adjuntovoucher"] == null ? null : json["adjuntovoucher"],
        codigonit: json["codigonit"] == null ? null : json["codigonit"],
        adjuntonit: json["adjuntonit"] == null ? null : json["adjuntonit"],
        codigoviva: json["codigoviva"] == null ? null : json["codigoviva"],
        adjuntoviva: json["adjuntoviva"] == null ? null : json["adjuntoviva"],
        numdocumento: json["numdocumento"] == null ? null : json["numdocumento"],
        tipoPermLic: json["tipo_perm_lic"] == null ? null : json["tipo_perm_lic"],
        codigoTipoPerLic: json["codigo_tipo_per_lic"] == null ? null : json["codigo_tipo_per_lic"],
        nombreConcepto: json["nombre_concepto"] == null ? null : json["nombre_concepto"],
        codigoConcepto: json["codigo_concepto"] == null ? null : json["codigo_concepto"],
        engrupo: json["engrupo"] == null ? null : json["engrupo"],
        tipoInstAtencion: json["tipo_inst_atencion"] == null ? null : json["tipo_inst_atencion"],
        codigoTipoInst: json["codigo_tipo_inst"] == null ? null : json["codigo_tipo_inst"],
        tipoSuspension: json["tipo_suspension"] == null ? null : json["tipo_suspension"],
        cantidadDetalle: json["cantidad_detalle"] == null ? null : json["cantidad_detalle"],
        goce: json["goce"] == null ? null : json["goce"],
    );

    Map<String, dynamic> toJson() => {
        "id_licencia_permiso": idLicenciaPermiso == null ? null : idLicenciaPermiso,
        "id_entidad": idEntidad == null ? null : idEntidad,
        "adjunto": adjunto == null ? null : adjunto,
        "id_concepto_perm_lic": idConceptoPermLic == null ? null : idConceptoPermLic,
        "nombre_corto_tipo_concepto": nombreCortoTipoConcepto == null ? null : nombreCortoTipoConcepto,
        "id_depto": idDepto == null ? null : idDepto,
        "area": area == null ? null : area,
        "motivo": motivo == null ? null : motivo,
        "nombre": nombre == null ? null : nombre,
        "nombre_corto": nombreCorto == null ? null : nombreCorto,
        "convenio": convenio == null ? null : convenio,
        "conveniosinfirmar": conveniosinfirmar == null ? null : conveniosinfirmar,
        "conconvenio": conconvenio == null ? null : conconvenio,
        "fecha_desde": fechaDesde == null ? null : fechaDesde,
        "nomperiodo": nomperiodo == null ? null : nomperiodo,
        "fecha_hasta": fechaHasta == null ? null : fechaHasta,
        "hora_inicio": horaInicio == null ? null : horaInicio,
        "hora_fin": horaFin == null ? null : horaFin,
        "periodo": periodo == null ? null : periodo,
        "dias": dias == null ? null : dias,
        "horas": horas == null ? null : horas,
        "estado_nombre": estadoNombre == null ? null : estadoNombre,
        "id_estado_lica_per": idEstadoLicaPer == null ? null : idEstadoLicaPer,
        "formato": formato == null ? null : formato,
        "tipo": tipo == null ? null : tipo,
        "id_tipo_perm_lic": idTipoPermLic == null ? null : idTipoPermLic,
        "nombre_tipo_perm_lic": nombreTipoPermLic == null ? null : nombreTipoPermLic,
        "codigo_tipo_perm_lic": codigoTipoPermLic == null ? null : codigoTipoPermLic,
        "id_tipo_inst_atencion": idTipoInstAtencion == null ? null : idTipoInstAtencion,
        "nombre_inst": nombreInst == null ? null : nombreInst,
        "codigocitt": codigocitt == null ? null : codigocitt,
        "adjuntocitt": adjuntocitt == null ? null : adjuntocitt,
        "adjuntovoucher": adjuntovoucher == null ? null : adjuntovoucher,
        "codigonit": codigonit == null ? null : codigonit,
        "adjuntonit": adjuntonit == null ? null : adjuntonit,
        "codigoviva": codigoviva == null ? null : codigoviva,
        "adjuntoviva": adjuntoviva == null ? null : adjuntoviva,
        "numdocumento": numdocumento == null ? null : numdocumento,
        "tipo_perm_lic": tipoPermLic == null ? null : tipoPermLic,
        "codigo_tipo_per_lic": codigoTipoPerLic == null ? null : codigoTipoPerLic,
        "nombre_concepto": nombreConcepto == null ? null : nombreConcepto,
        "codigo_concepto": codigoConcepto == null ? null : codigoConcepto,
        "engrupo": engrupo == null ? null : engrupo,
        "tipo_inst_atencion": tipoInstAtencion == null ? null : tipoInstAtencion,
        "codigo_tipo_inst": codigoTipoInst == null ? null : codigoTipoInst,
        "tipo_suspension": tipoSuspension == null ? null : tipoSuspension,
        "cantidad_detalle": cantidadDetalle == null ? null : cantidadDetalle,
        "goce": goce == null ? null : goce,
    };
}
