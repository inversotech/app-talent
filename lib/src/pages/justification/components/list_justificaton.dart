import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show
        ApiResponse,
        JustificationModel,
        MarkingWorkerModel,
        ProcessJustifcationModel;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/justification/index.dart';
import 'package:upn_financiero_mobil/src/shared/components/visor_pdf_img.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart';

class ListJustification extends StatelessWidget {
  final List<JustificationModel> listData;
  final BoxConstraints constraints;
  final bool loading;
  final void Function(JustificationModel) onPressed;
  final void Function() onChangeList;
  ListJustification(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.loading,
      required this.onPressed,
      required this.onChangeList})
      : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
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
                        buildContext,
                        listData[index].idSolicJustif.toString(),
                        listData[index].idEstadoJustif.toString());
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    child: Text((index + 1).toString(),
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            fontSize: 22.0)),
                                    backgroundColor: ColorsApp.info,
                                  ),
                                  SizedBox(width: 8.0),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.0),
                                        Text(
                                          capitalize(listData[index]
                                              .motivo
                                              .toString()),
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsApp.primary,
                                              fontSize: 16.0),
                                        ),
                                        Text(
                                            'Fecha: ' +
                                                DateFormat('dd|MM|yyyy').format(
                                                    DateTime.parse(
                                                        listData[index]
                                                            .fecha!)),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /* listData[index].idEstadoJustif == '01'
                                ? TextButton(
                                    onPressed: () {
                                      onPressed(listData[index]);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: ColorsApp.primary,
                                        ),
                                        Text(
                                          'editar',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w300,
                                              color: ColorsApp.primary,
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  )
                                : Container() */
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            listData[index].evidenciaAdj != null
                                ? Flexible(
                                    child: InkWell(
                                      onTap: () async {
                                        ShowLoadingIndicator
                                            .showLoadingIndicator(
                                                context: buildContext,
                                                onlyLoading: true,
                                                opacity: true);
                                        Map<String, String> params = {
                                          'archivo': listData[index]
                                              .evidenciaAdj
                                              .toString()
                                        };
                                        JustificationService
                                            _justificationService =
                                            JustificationService();
                                        ApiResponse resp =
                                            await _justificationService
                                                .geFileRequest(params);
                                        if (resp.success) {
                                          final dir =
                                              await getTemporaryDirectory();
                                          File file = new File(dir.path +
                                              listData[index]
                                                  .evidenciaAdj
                                                  .toString());
                                          Uint8List bytes =
                                              base64.decode(resp.data);
                                          await file.writeAsBytes(bytes);
                                          Navigator.of(buildContext).pop();
                                          Navigator.push(
                                              buildContext,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VisorPdfImgPage(
                                                          title: 'Evidencia',
                                                          filePath:
                                                              file.path)));
                                        } else {
                                          Navigator.of(buildContext).pop();
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(width: 35.0),
                                          Image.asset('assets/icons/file.png',
                                              height: 25,
                                              width: 25,
                                              color: ColorsApp.primary),
                                          Text(
                                              listData[index]
                                                  .evidenciaAdj
                                                  .toString()
                                                  .toLowerCase(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsApp.primary,
                                                  fontSize: 12.0))
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Row(
                              children: [
                                Text(
                                  listData[index].estado.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: listData[index].idEstadoJustif ==
                                            '01'
                                        ? ColorsApp.primary
                                        : listData[index].idEstadoJustif == '02'
                                            ? ColorsApp.basic
                                            : listData[index].idEstadoJustif ==
                                                    '03'
                                                ? ColorsApp.success
                                                : listData[index]
                                                            .idEstadoJustif ==
                                                        '04'
                                                    ? ColorsApp.danger
                                                    : listData[index]
                                                                .idEstadoJustif ==
                                                            '00'
                                                        ? ColorsApp.danger
                                                        : Colors.black,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: ColorsApp.primary);
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

  void _showModalDetail(
      BuildContext buildContext, String id, String idEstado) async {
    await showDialog(
        context: buildContext,
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
                  future: _getDataJustification(id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      try {
                        JustificationModel data = snapshot.data['request'];
                        List<ProcessJustifcationModel> listProcessJustif =
                            snapshot.data['proccess'];
                        List<MarkingWorkerModel> listMarkings =
                            snapshot.data['markings'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(capitalize(data.motivo.toString()),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsApp.primary,
                                      fontSize: 16.0)),
                            ),
                            SizedBox(height: 4.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  'Fecha: ' +
                                      DateFormat('dd|MM|yyyy').format(
                                          DateTime.parse(
                                              data.fecha.toString())),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsApp.primary,
                                      fontSize: 12.0)),
                            ),
                            SizedBox(height: 4.0),
                            data.evidenciaAdj != null
                                ? InkWell(
                                    onTap: () async {
                                      ShowLoadingIndicator.showLoadingIndicator(
                                          context: buildContext,
                                          onlyLoading: true,
                                          opacity: true);
                                      Map<String, String> params = {
                                        'archivo': data.evidenciaAdj.toString()
                                      };
                                      JustificationService
                                          _justificationService =
                                          JustificationService();
                                      ApiResponse resp =
                                          await _justificationService
                                              .geFileRequest(params);
                                      if (resp.success) {
                                        final dir =
                                            await getTemporaryDirectory();
                                        File file = new File(dir.path +
                                            data.evidenciaAdj.toString());
                                        Uint8List bytes =
                                            base64.decode(resp.data);
                                        await file.writeAsBytes(bytes);
                                        Navigator.of(buildContext).pop();
                                        Navigator.push(
                                            buildContext,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VisorPdfImgPage(
                                                        title: 'Evidencia',
                                                        filePath: file.path)));
                                      } else {
                                        Navigator.of(buildContext).pop();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/file.png',
                                            height: 25,
                                            width: 25,
                                            color: ColorsApp.primary),
                                        Text(data.evidenciaAdj.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0))
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 8.0),
                            data.descripcion != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Motivo.',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsApp.primary,
                                                fontSize: 13.0)),
                                        Text(data.descripcion.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0))
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text('Marcaciones solicitadas:',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsApp.primary,
                                      fontSize: 13.0)),
                            ),
                            _markings(listMarkings),
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
                                      data.estado.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: data.idEstadoJustif == '01'
                                              ? ColorsApp.primary
                                              : data.idEstadoJustif == '02'
                                                  ? ColorsApp.basic
                                                  : data.idEstadoJustif == '03'
                                                      ? ColorsApp.success
                                                      : data.idEstadoJustif ==
                                                              '04'
                                                          ? ColorsApp.danger
                                                          : data.idEstadoJustif ==
                                                                  '00'
                                                              ? ColorsApp.danger
                                                              : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _processJustif(listProcessJustif),
                            SizedBox(height: 12.0)
                          ],
                        );
                      } catch (e) {
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(
                                  'No se encontró información para mostrar',
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
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
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

  Widget _markings(List<MarkingWorkerModel> listMarkings) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: listMarkings.length,
      itemBuilder: (BuildContext context, int index) {
        MarkingWorkerModel item = listMarkings[index];
        return Container(
          padding: const EdgeInsets.only(top: 4.0),
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset('assets/icons/check.png',
                            height: 25, width: 25, color: ColorsApp.primary),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4.0),
                            Text(item.nombreDescripMarcacion.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.primary,
                                    fontSize: 14.0)),
                            item.fechahora != null
                                ? Text(
                                    DateFormat('d|M|y hh:mm a')
                                            .format(DateTime.parse(
                                                item.fechahora.toString()))
                                            .toLowerCase() +
                                        ' (Registrado)',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary,
                                        fontSize: 14.0))
                                : Container(),
                            item.fechahoraManual != null
                                ? Text(
                                    DateFormat('d|M|y hh:mm a')
                                        .format(DateTime.parse(
                                            item.fechahoraManual.toString()))
                                        .toLowerCase(),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary,
                                        fontSize: 14.0))
                                : Container()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _processJustif(List<ProcessJustifcationModel> listProcessJustif) {
    List<Step> steps = [];
    listProcessJustif.forEach((val) {
      if (val.idSolicJustif != null) {
        steps.add(Step(
            isActive: val.idSolicJustif != null ? true : false,
            state: val.idSolicJustif != null
                ? val.idEstadoJustif == '00' || val.idEstadoJustif == '04'
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
    return listProcessJustif.length > 0
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

  void changeRequestStatus(String text, BuildContext context, String id) async {
    final JustificationService justificationService =
        new JustificationService();
    UserPreferences userPreferences = UserPreferences();
    Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker.toString(),
      'id_solic_justif': id,
      'id_estado_justif': '00',
      'comentario': text
    };
    ShowLoadingIndicator.showLoadingIndicator(
        text: 'Guardando ...', context: context);
    ApiResponse create = await justificationService.changeRequestStatus(params);

    if (create.success) {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      onChangeList();
    }
  }

  Future<Map<String, dynamic>> _getDataJustification(String id) async {
    Map<String, dynamic> data = {
      'request': null,
      'markings': null,
      'proccess': null
    };
    final JustificationService justificationService =
        new JustificationService();
    ApiResponse resp = await justificationService.getJustification(id);
    if (resp.success) {
      JustificationModel request = JustificationModel.fromJson(resp.data);
      data['request'] = request;
    }
    List<MarkingWorkerModel> listMarking =
        await justificationService.getJustificationMarkings(id);
    data['markings'] = listMarking;
    List<ProcessJustifcationModel> listProcessJustif =
        await justificationService.getProcessJustification(id);
    data['proccess'] = listProcessJustif;
    return data;
  }
}
