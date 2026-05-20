import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/license-permit/license_permit.dart';
import 'package:lamb_talent/resources/models/license-permit/license_permit_group.dart';
import 'package:lamb_talent/resources/models/license-permit/state_license_permit.dart';
import 'package:lamb_talent/resources/services/license_permit/license_permit_service.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/visor_pdf_img.dart';
import 'package:path_provider/path_provider.dart';

class ListLicensePermit extends StatelessWidget {
  final List<LicensePermitGroupModel> listData;
  final BoxConstraints constraints;
  final void Function() onChangeList;
  final bool isJefeArea;
  final bool isDth;
  final bool approve;
  const ListLicensePermit(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.onChangeList,
      this.isJefeArea = false,
      this.isDth = false,
      this.approve = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            final itemFather = listData[index];
            List<LicensePermitModel> children = listData[index].children!;
            return Column(
              children: [
                approve
                    ? AppText.h3(itemFather.apellidonombre.toString(),
                        color: ColorsApp.primary)
                    : Container(),
                ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    primary: false,
                    itemBuilder: (context, index) {
                      final item = children[index];
                      return TextButton(
                        onPressed: () {
                          _showModalDetail(
                              context,
                              item.idTrabajador.toString(),
                              item.idLicenciaPermiso.toString(),
                              item.idEstadoLicaPer.toString());
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                    backgroundColor: ColorsApp.neutral200,
                                    child: AppText.labelLarge(
                                        item.codigoTipoPermLic != null
                                            ? item.codigoTipoPermLic
                                                .toString()[0]
                                            : ' ',
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4.0),
                                        AppText.h3(
                                          capitalize(item
                                              .nombreCortoTipoConcepto
                                              .toString()),
                                          color: ColorsApp.primary,
                                        ),
                                        _dateWidget(item)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              _fileAndProcessWidget(item, false, context)
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        color: ColorsApp.primary,
                        thickness: 0.8,
                      );
                    },
                    itemCount: children.length),
              ],
            );
          },
          itemCount: listData.length);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AppText.body('No se encontró información para mostrar.',
              color: ColorsApp.primary),
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
                    loadingIndicator(onlyLoading: true, opacity: true);
                    Map<String, String> params = {
                      'directorio': 'benefits/licenciaPermiso',
                      'name': item.adjunto.toString(),
                      'type': 'F'
                    };
                    final licensePermitService = LicensePermitService();
                    final resp =
                        await licensePermitService.geFileRequest(params);

                    if (resp.success) {
                      final dir = await getTemporaryDirectory();
                      File file = File(dir.path + item.adjunto.toString());
                      Uint8List bytes = base64.decode(resp.data['file']);
                      await file.writeAsBytes(bytes);

                      Get.back();
                      Get.to(VisorPdfImgPage(
                          title: 'Adjunto', filePath: file.path));
                    } else {
                      Get.back();
                    }
                  },
                  child: Row(
                    children: [
                      !detail ? const SizedBox(width: 45.0) : Container(),
                      Image.asset('assets/icons/file.png',
                          height: 25, width: 25, color: ColorsApp.primary),
                      Flexible(
                        child: AppText.label(item.adjunto.toString().toLowerCase(),
                            color: ColorsApp.primary),
                      )
                    ],
                  ),
                ),
              )
            : const Flexible(child: Text(' ')),
        Column(
          children: [
            !detail
                ? AppText.label(
                    item.estadoNombre.toString(),
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
                                        : Colors.black,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.label('Tipo: ', color: ColorsApp.primary),
                      AppText.label(item.tipoPermLic.toString(),
                          color: ColorsApp.primary),
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
                  ? AppText.label(
                      'Fecha: ${Jiffy.parse(item.fechaDesde!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                      color: ColorsApp.primary)
                  : Container(),
              item.periodo.toString() == 'H'
                  ? AppText.label(
                      'Hora: ${Jiffy.parse(item.horaInicio!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}-${Jiffy.parse(item.horaFin!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}',
                      color: ColorsApp.primary)
                  : Container(),
              item.periodo.toString() == 'D'
                  ? AppText.label(
                      'Fecha: ${Jiffy.parse(item.fechaDesde!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}-${Jiffy.parse(item.fechaHasta!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                      color: ColorsApp.primary)
                  : Container()
            ],
          ),
        ),
        item.periodo != null
            ? AppText.label(
                'Tiempo: ${item.periodo! == 'D' ? '${item.dias!} días' : item.periodo! == 'H' ? '${item.horas!} horas' : ''}',
                color: ColorsApp.primary)
            : Container()
      ],
    );
  }

  void _showModalDetail(BuildContext context, String idTrabajador, String id,
      String idEstado) async {
    final pref = UserPreferences();

    await Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Image.asset('assets/icons/close.png',
                    height: 40, width: 40, color: ColorsApp.primary),
                onPressed: () => Get.back()),
          ),
          contentPadding: const EdgeInsets.all(8.0),
          titlePadding: EdgeInsets.zero,
          scrollable: false,
          content: SizedBox(
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
                            child: AppText.h3(
                                capitalize(data.nombreConcepto.toString()),
                                color: ColorsApp.primary),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: _dateWidget(data),
                          ),
                          const SizedBox(height: 8.0),
                          _fileAndProcessWidget(data, true, context),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: data.motivo != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText.labelLarge('Motivo',
                                          color: ColorsApp.primary),
                                      AppText.label(data.motivo.toString(),
                                          color: ColorsApp.primary)
                                    ],
                                  )
                                : Container(),
                          ),
                          const SizedBox(height: 8.0),
                          const Divider(height: 1, color: ColorsApp.primary),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText.labelLarge('Proceso: ',
                                    color: ColorsApp.primary),
                                Flexible(
                                  child: AppText.body(
                                    data.estadoNombre.toString(),
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
                                                        : Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          _processJustif(listProcess),
                          const SizedBox(height: 12.0)
                        ],
                      );
                    } catch (e) {
                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                            child: AppText.body(
                                'No se encontró información para mostrar',
                                color: ColorsApp.primary)),
                      );
                    }
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          actions: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  idEstado == '01' && !pref.isWorkerChild && !approve
                      ? TextButton(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Anular',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                          ),
                          onPressed: () {
                            _showModalAnularRefuse(
                                context, idTrabajador, id, '00', 'Anular');
                          },
                        )
                      : Container(),
                  (idEstado == '01' && isJefeArea) ||
                          (idEstado == '02' && isDth)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextButton(
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return ColorsApp
                                      .danger; // Use the component's default.
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('Rechazar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () {
                              _showModalAnularRefuse(
                                  context, idTrabajador, id, '04', 'Rechazar');
                            },
                          ),
                        )
                      : Container(),
                  (idEstado == '01' && isJefeArea) ||
                          (idEstado == '02' && isDth)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextButton(
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return ColorsApp
                                      .success; // Use the component's default.
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                  idEstado == '01' && isJefeArea
                                      ? 'Aprobación Area'
                                      : idEstado == '02' && isDth
                                          ? 'Aprobación DTH'
                                          : '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () {
                              _showModalApprove(
                                  context, idTrabajador, id, idEstado);
                            },
                          ),
                        )
                      : Container()
                ],
              ),
            )
          ],
        ));
  }

  Widget _processJustif(List<StateLicensePermitModel> listProcess) {
    List<Step> steps = [];
    for (var val in listProcess) {
      if (val.idLicenciaPermiso != null) {
        steps.add(Step(
            isActive: val.idLicenciaPermiso != null ? true : false,
            state: val.idLicenciaPermiso != null
                ? val.idEstadoLicaPer == '00' || val.idEstadoLicaPer == '04'
                    ? StepState.error
                    : StepState.complete
                : StepState.disabled,
            title: AppText.labelLarge(val.nombre.toString(),
                color: ColorsApp.primary),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                val.email != null
                    ? AppText.bodySmall(
                        '${val.email}: ${Jiffy.parse(val.fecha.toString(), pattern: "dd/MM/yyyy HH:mm").format(pattern: 'dd|MM|yyyy hh:mm a')}',
                        color: ColorsApp.primary)
                    : Container(),
                val.comentario != null
                    ? AppText.bodySmall(val.comentario.toString(),
                        color: ColorsApp.primary)
                    : Container()
              ],
            ),
            content: Container()));
      }
    }
    return listProcess.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: [
                        InkWell(
                            onTap: controls.onStepContinue, child: Container()),
                        InkWell(
                            onTap: controls.onStepCancel, child: Container()),
                      ],
                    );
                  },
                  physics: const ScrollPhysics(),
                  steps: steps,
                  type: StepperType.vertical,
                ),
              ],
            ),
          )
        : Container();
  }

  void _showModalApprove(BuildContext context, String idTrabajador, String id,
      String idEstado) async {
    await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          titlePadding: EdgeInsets.zero,
          scrollable: true,
          titleTextStyle: GoogleFonts.montserrat(
              color: ColorsApp.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text((idEstado == '01' && isJefeArea
                      ? 'Aprobación Area'
                      : idEstado == '02' && isDth
                          ? 'Aprobación DTH'
                          : '')
                  .toUpperCase()),
            ),
          ),
          content: Column(children: [
            Image.asset('assets/icons/check.png',
                height: 50, width: 50, color: ColorsApp.success),
            AppText.labelLarge('¿Desea aprobar el/la permiso/licencia?',
                color: ColorsApp.primary)
          ]),
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
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Cerrar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () => Get.back()),
            TextButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return ColorsApp.success; // Use the component's default.
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Estoy de acuerdo!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              onPressed: () {
                changeRequestStatus(
                    '',
                    context,
                    idTrabajador,
                    id,
                    idEstado == '01' && isJefeArea
                        ? '02'
                        : idEstado == '02' && isDth
                            ? '03'
                            : idEstado);
              },
            )
          ],
        ));
  }

  void _showModalAnularRefuse(BuildContext context, String idTrabajador,
      String id, String idEstado, String text) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController inputFieldCtrl = TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.neutral200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            titleTextStyle: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(text.toUpperCase()),
            )),
            content: TextFormField(
              controller: inputFieldCtrl,
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Get.back()),
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
                  child: Text(text,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  changeRequestStatus(
                      inputFieldCtrl.value.text.isNotEmpty
                          ? inputFieldCtrl.value.text
                          : '',
                      context,
                      idTrabajador,
                      id,
                      idEstado);
                },
              )
            ],
          );
        });
  }

  void changeRequestStatus(String text, BuildContext context,
      String idTrabajador, String id, String idEstado) async {
    final licensePermitService = LicensePermitService();
    Map<String, String> params = {
      'id_trabajador': idTrabajador.toString(),
      'id_estado_lica_per': idEstado,
      'motivo_anula': text
    };
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final create =
        await licensePermitService.chageStatusLicensePermit(id, params);

    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      final userPref = UserPreferences();
      userPref.resultChange = true;
      Get.until((route) => Get.currentRoute == '/LicensePermitPage');
      onChangeList();
    }
  }

  Future<Map<String, dynamic>> _getDataLicensePermit(String id) async {
    Map<String, dynamic> data = {
      'request': null,
      'markings': null,
      'proccess': null
    };
    final LicensePermitService licensePermitService = LicensePermitService();
    final resp = await licensePermitService.getLicensesPermit(id);
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
