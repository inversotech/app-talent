import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show ApiResponse, LicensePermitModel, StateLicensePermitModel;
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/license-permit/index.dart';
import 'package:upn_financiero_mobil/src/shared/components/visor_pdf_img.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';

class ListLicensePermit extends StatelessWidget {
  final List<LicensePermitModel> listData;
  final BoxConstraints constraints;
  final bool loading;
  final void Function() onChangeList;
  ListLicensePermit(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.loading,
      required this.onChangeList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return Stack(
        children: [
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              primary: false,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    _showModalDetail(
                        context,
                        listData[index].idLicenciaPermiso.toString(),
                        listData[index].idEstadoLicaPer.toString());
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: Text(
                                  listData[index].codigoTipoPermLic != null
                                      ? listData[index]
                                          .codigoTipoPermLic
                                          .toString()[0]
                                      : ' ',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 22.0)),
                              backgroundColor: ColorsApp.info,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.0),
                                  Text(
                                    capitalize(listData[index]
                                        .nombreCortoTipoConcepto
                                        .toString()),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsApp.primary,
                                        fontSize: 16.0),
                                  ),
                                  _dateWidget(listData[index])
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        _fileAndProcessWidget(listData[index], false, context)
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: ColorsApp.primary,thickness: 0.8,);
              },
              itemCount: listData.length),
          if (loading) ...[
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                top: 0.0,
                child: Container(
                  width: constraints.maxWidth,
                  child: Center(child: CircularProgressIndicator()),
                ))
          ]
        ],
      );
    } else if (loading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }

  Widget _fileAndProcessWidget(
      LicensePermitModel item, bool detail, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        item.adjunto != null
            ? Flexible(
                child: InkWell(
                  onTap: () async {
                    ShowLoadingIndicator.showLoadingIndicator(
                        context: context, onlyLoading: true, opacity: true);
                    Map<String, String> params = {
                      'directorio': 'benefits/licenciaPermiso',
                      'name': item.adjunto.toString(),
                      'type': 'F'
                    };
                    LicensePermitService _licensePermitService =
                        LicensePermitService();
                    ApiResponse resp =
                        await _licensePermitService.geFileRequest(params);
                    if (resp.success) {
                      final dir = await getTemporaryDirectory();
                      File file = new File(dir.path + item.adjunto.toString());
                      Uint8List bytes = base64.decode(resp.data['file']);
                      await file.writeAsBytes(bytes);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisorPdfImgPage(
                                  title: 'Adjunto', filePath: file.path)));
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Row(
                    children: [
                      !detail ? SizedBox(width: 45.0) : Container(),
                      Image.asset('assets/icons/file.png',
                          height: 25, width: 25, color: ColorsApp.primary),
                      Flexible(
                        child: Text(item.adjunto.toString().toLowerCase(),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: ColorsApp.primary,
                                fontSize: 12.0)),
                      )
                    ],
                  ),
                ),
              )
            : Flexible(child: Text(' ')),
        Column(
          children: [
            !detail
                ? Text(
                    item.estadoNombre.toString(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: item.idEstadoLicaPer == '01'
                            ? ColorsApp.primary
                            : item.idEstadoLicaPer == '02'
                                ? ColorsApp.basic
                                : item.idEstadoLicaPer == '03'
                                    ? ColorsApp.success
                                    : item.idEstadoLicaPer == '04'
                                        ? ColorsApp.danger
                                        : item.idEstadoLicaPer == '00'
                                            ? ColorsApp.danger
                                            : Colors.black),
                  )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipo: ',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                              color: ColorsApp.primary)),
                      Text(item.tipoPermLic.toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                              color: ColorsApp.primary)),
                    ],
                  )
          ],
        )
      ],
    );
  }

  Widget _dateWidget(LicensePermitModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.periodo.toString() == 'H'
                  ? Text(
                      'Fecha: ' +
                          Jiffy(item.fechaDesde!, 'dd/MM/yyyy')
                              .format('dd|MM|yyyy'),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.periodo.toString() == 'H'
                  ? Text(
                      'Hora: ' +
                          Jiffy(item.horaInicio!, 'HH:mm').format('hh:mm a') +
                          '-' +
                          Jiffy(item.horaFin!, 'HH:mm').format('hh:mm a'),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.periodo.toString() == 'D'
                  ? Text(
                      'Fecha: ' +
                          Jiffy(item.fechaDesde!, 'dd/MM/yyyy')
                              .format('dd|MM|yyyy') +
                          '-' +
                          Jiffy(item.fechaHasta!, 'dd/MM/yyyy')
                              .format('dd|MM|yyyy'),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container()
            ],
          ),
        ),
        item.periodo != null
            ? Text(
                'Tiempo: ' +
                    (item.periodo! == 'D'
                        ? item.dias! + ' días'
                        : item.periodo! == 'H'
                            ? item.horas! + ' horas'
                            : ''),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 12.0))
            : Container()
      ],
    );
  }

  void _showModalDetail(
      BuildContext context, String id, String idEstado) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            title: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Image.asset('assets/icons/close.png',
                      height: 40, width: 40, color: ColorsApp.primary),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            contentPadding: EdgeInsets.all(8.0),
            titlePadding: EdgeInsets.zero,
            scrollable: false,
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _getDataLicensePermit(id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      try {
                        LicensePermitModel data = snapshot.data['request'];
                        List<StateLicensePermitModel> listProcess =
                            snapshot.data['proccess'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  capitalize(data.nombreConcepto.toString()),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsApp.primary,
                                      fontSize: 16.0)),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: _dateWidget(data),
                            ),
                            SizedBox(height: 8.0),
                            _fileAndProcessWidget(data, true, context),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: data.motivo != null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Motivo',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsApp.primary,
                                                fontSize: 13.0)),
                                        Text(data.motivo.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0))
                                      ],
                                    )
                                  : Container(),
                            ),
                            SizedBox(height: 8.0),
                            Divider(height: 1, color: ColorsApp.primary),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Proceso: ',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          color: ColorsApp.primary,
                                          fontSize: 13.0)),
                                  Flexible(
                                    child: Text(
                                      data.estadoNombre.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: data.idEstadoLicaPer == '01'
                                              ? ColorsApp.primary
                                              : data.idEstadoLicaPer == '02'
                                                  ? ColorsApp.basic
                                                  : data.idEstadoLicaPer == '03'
                                                      ? ColorsApp.success
                                                      : data.idEstadoLicaPer == '04'
                                                          ? ColorsApp.danger
                                                          : data.idEstadoLicaPer ==
                                                                  '00'
                                                              ? ColorsApp.danger
                                                              : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _processJustif(listProcess),
                            SizedBox(height: 12.0)
                          ],
                        );
                      } catch (e) {
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text('No se encontró información para mostrar',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: ColorsApp.primary))),
                        );
                      }
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            actions: idEstado == '01'
                ? [
                    TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return ColorsApp
                                .primaryVariant; // Use the component's default.
                          },
                        ),
                        shape: MaterialStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                          (Set<MaterialState> states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25)); // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Anular',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                      onPressed: () {
                        _showModalAnular(context, id);
                      },
                    )
                  ]
                : null,
          );
        });
  }

  void _showModalAnular(BuildContext context, String id) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController _inputFieldCtrl = new TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            content: TextFormField(
              controller: _inputFieldCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                labelText: 'Comentario (opcional)',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primaryVariant; // Use the component's default.
                      },
                    ),
                    shape: MaterialStateProperty.resolveWith<
                        RoundedRectangleBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25)); // Use the component's default.
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp
                          .primaryVariant; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Anular',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  changeRequestStatus(
                      _inputFieldCtrl.value.text.isNotEmpty
                          ? _inputFieldCtrl.value.text
                          : '',
                      context,
                      id);
                },
              )
            ],
          );
        });
  }

  Widget _processJustif(List<StateLicensePermitModel> listProcess) {
    List<Step> steps = [];
    listProcess.forEach((val) {
      if (val.idLicenciaPermiso != null) {
        steps.add(Step(
            isActive: val.idLicenciaPermiso != null ? true : false,
            state: val.idLicenciaPermiso != null
                ? val.idEstadoLicaPer == '00' || val.idEstadoLicaPer == '04'
                    ? StepState.error
                    : StepState.complete
                : StepState.disabled,
            title: Text(val.nombre.toString(),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 14.0)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                val.email != null
                    ? Text(
                        val.email.toString() +
                            ': ' +
                            Jiffy(val.fecha.toString(), "dd/MM/yyyy HH:mm")
                                .format('dd|MM|yyyy hh:mm a')
                                .toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: ColorsApp.primary,
                            fontSize: 12.0))
                    : Container(),
                val.comentario != null
                    ? Text(val.comentario.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: ColorsApp.primary,
                            fontSize: 12.0))
                    : Container()
              ],
            ),
            content: Container()));
      }
    });
    return listProcess.length > 0
        ? Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Stepper(
                  controlsBuilder: (BuildContext context,
                      {VoidCallback? onStepContinue,
                      VoidCallback? onStepCancel}) {
                    return Container();
                  },
                  physics: ScrollPhysics(),
                  steps: steps,
                  type: StepperType.vertical,
                ),
              ],
            ),
          )
        : Container();
  }

  void changeRequestStatus(String text, BuildContext context, String id) async {
    final LicensePermitService licensePermitService =
        new LicensePermitService();
    Map<String, String> params = {
      'id_estado_lica_per': '00',
      'motivo_anula': text
    };
    ShowLoadingIndicator.showLoadingIndicator(
        text: 'Guardando ...', context: context);
    ApiResponse create =
        await licensePermitService.chageStatusLicensePermit(id, params);

    if (create.success) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      onChangeList();
    }
  }

  Future<Map<String, dynamic>> _getDataLicensePermit(String id) async {
    Map<String, dynamic> data = {
      'request': null,
      'markings': null,
      'proccess': null
    };
    final LicensePermitService licensePermitService =
        new LicensePermitService();
    ApiResponse resp = await licensePermitService.getLicensesPermit(id);
    if (resp.success) {
      LicensePermitModel request = LicensePermitModel.fromJson(resp.data);
      data['request'] = request;
    }
    List<StateLicensePermitModel> listProcess =
        await licensePermitService.getProcessLicensePermit(id);
    data['proccess'] = listProcess;
    return data;
  }
}
