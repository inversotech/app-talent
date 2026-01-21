import 'package:jiffy/jiffy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/overtime/overtime.dart';
import 'package:lamb_talent/resources/models/overtime/overtime_group.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/resources/models/overtime/process_overtime.dart';
import 'package:lamb_talent/resources/services/overtime/overtime_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

class ListOvertime extends StatelessWidget {
  final List<OvertimeGroup> listData;
  final BoxConstraints constraints;
  final void Function(OvertimeModel) onPressed;
  final void Function() onChangeList;
  final bool isWorker;
  final bool isJefeArea;
  final bool isDth;
  final bool approve;
  const ListOvertime({
    Key? key,
    required this.listData,
    required this.constraints,
    required this.onPressed,
    required this.onChangeList,
    this.isWorker = false,
    this.isJefeArea = false,
    this.isDth = false,
    this.approve = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return ListView.builder(
        itemCount: listData.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        primary: false,
        itemBuilder: (context, index) {
          final itemFather = listData[index];
          List<OvertimeModel> children = listData[index].children!;
          return Column(children: [
            approve
                ? Text(itemFather.apellidonombre.toString(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: ColorsApp.primary,
                        fontSize: 16.0))
                : Container(),
            ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  color: ColorsApp.primary,
                  thickness: 0.8,
                );
              },
              itemCount: children.length,
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
                          item.idSobretiempo.toString(),
                          item.idEstadoSobretiempo.toString());
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
                                    backgroundColor: ColorsApp.info,
                                    child: Text(
                                        item.codigoSobretiempo != null
                                            ? item.codigoSobretiempo.toString()
                                            : ' ',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 14)),
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
                                        Text(
                                          capitalize(
                                              item.tipoSobretiempo.toString()),
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsApp.primary,
                                              fontSize: 16.0),
                                        ),
                                        _dateWidget(item)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              _processWidget(item, false, context)
                            ])));
              },
            )
          ]);
        },
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

  Widget _dateWidget(OvertimeModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.codigoPeriodo.toString() == 'H'
                  ? Text(
                      'Fecha: ${Jiffy.parse(item.fecha!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.codigoPeriodo.toString() == 'H'
                  ? Text(
                      'Hora: ${Jiffy.parse(item.horaDesde!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}-${Jiffy.parse(item.horaHasta!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.codigoPeriodo.toString() == 'D'
                  ? Text(
                      'Fecha: ${Jiffy.parse(item.fecha!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container()
            ],
          ),
        ),
        item.codigoPeriodo != null && item.codigoPeriodo == 'H'
            ? Text('Tiempo: ${item.horas!} horas',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 12.0))
            : Container()
      ],
    );
  }

  Widget _dateWidgetDetail(OvertimeModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item.codigoPeriodo.toString() == 'H'
                  ? Text(
                      'Fecha: ${Jiffy.parse(item.fecha!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.codigoPeriodo.toString() == 'H'
                  ? Text(
                      'Hora: ${Jiffy.parse(item.horaDesde!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}-${Jiffy.parse(item.horaHasta!, pattern: 'HH:mm').format(pattern: 'hh:mm a')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container(),
              item.codigoPeriodo.toString() == 'D'
                  ? Text(
                      'Fecha: ${Jiffy.parse(item.fecha!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary,
                          fontSize: 12.0))
                  : Container()
            ],
          ),
        ),
        item.codigoPeriodo != null && item.codigoPeriodo == 'H'
            ? Text('Tiempo: ${item.horas!} horas',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 12.0))
            : Container()
      ],
    );
  }

  Widget _processWidget(OvertimeModel item, bool detail, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(),
        Column(
          children: [
            !detail
                ? Text(
                    item.estadoNombre.toString(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: item.idEstadoSobretiempo == '01'
                            ? ColorsApp.primary
                            : item.idEstadoSobretiempo == '02'
                                ? ColorsApp.success
                                : item.idEstadoSobretiempo == '03'
                                    ? ColorsApp.danger
                                    : item.idEstadoSobretiempo == '04'
                                        ? ColorsApp.success
                                        : item.idEstadoSobretiempo == '05'
                                            ? ColorsApp.success
                                            : item.idEstadoSobretiempo == '06'
                                                ? ColorsApp.danger
                                                : item.idEstadoSobretiempo ==
                                                        '00'
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
                      Text(item.tipoSobretiempo.toString(),
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

  void _showModalDetail(BuildContext context, String idTrabajador, String id,
      String idEstado) async {
    final pref = UserPreferences();
    await Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.info,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Image.asset('assets/icons/close.png',
                    height: 40, width: 40, color: ColorsApp.primary),
                onPressed: () => Navigator.of(context).pop()),
          ),
          contentPadding: const EdgeInsets.all(8.0),
          titlePadding: EdgeInsets.zero,
          scrollable: false,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _getDataOvertime(id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    try {
                      OvertimeModel data = snapshot.data['request'];
                      List<ProcessOvertimeModel> listProcess =
                          snapshot.data['proccess'];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                                capitalize(data.tipoSobretiempo.toString()),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.primary,
                                    fontSize: 16.0)),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: _dateWidgetDetail(data),
                          ),
                          const SizedBox(height: 8.0),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: data.motivo != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          const SizedBox(height: 8.0),
                          data.codigoSobretiempo == 'FE'
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                          text: 'Compensado: ',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsApp.primary,
                                              fontSize: 13.0),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: data.compensado,
                                                style: GoogleFonts.montserrat(
                                                    color: ColorsApp.primary,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      data.compensado
                                                  .toString()
                                                  .toUpperCase() ==
                                              'SI'
                                          ? Text(
                                              'Fecha: ${Jiffy.parse(data.fechaCompensar!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsApp.primary,
                                                  fontSize: 12.0))
                                          : Container(),
                                      data.compensado
                                                  .toString()
                                                  .toUpperCase() ==
                                              'SI'
                                          ? Text(
                                              'Comentario:  ${data.comentarioCompensar.toString()} ',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsApp.primary,
                                                  fontSize: 12.0))
                                          : Container(),
                                    ],
                                  ),
                                )
                              : Container(),
                          const SizedBox(height: 8.0),
                          const Divider(height: 1, color: ColorsApp.primary),
                          const SizedBox(height: 8.0),
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
                                        color: data.idEstadoSobretiempo == '01'
                                            ? ColorsApp.primary
                                            : data.idEstadoSobretiempo == '02'
                                                ? ColorsApp.success
                                                : data.idEstadoSobretiempo ==
                                                        '03'
                                                    ? ColorsApp.danger
                                                    : data.idEstadoSobretiempo ==
                                                            '04'
                                                        ? ColorsApp.success
                                                        : data.idEstadoSobretiempo ==
                                                                '05'
                                                            ? ColorsApp.success
                                                            : data.idEstadoSobretiempo ==
                                                                    '06'
                                                                ? ColorsApp
                                                                    .danger
                                                                : data.idEstadoSobretiempo ==
                                                                        '00'
                                                                    ? ColorsApp
                                                                        .danger
                                                                    : Colors
                                                                        .black),
                                  ),
                                )
                              ],
                            ),
                          ),
                          _processOvertime(listProcess),
                          const SizedBox(height: 12.0)
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
                          (idEstado == '04' && isDth)
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
                                  context, idTrabajador, id, '06', 'Rechazar');
                            },
                          ),
                        )
                      : Container(),
                  (idEstado == '01' && isJefeArea) ||
                          (idEstado == '04' && isDth)
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
                                      : idEstado == '04' && isDth
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

  Future<Map<String, dynamic>> _getDataOvertime(String id) async {
    Map<String, dynamic> data = {'request': null, 'proccess': null};
    final OvertimeService overtimeService = OvertimeService();
    final resp = await overtimeService.getOvertime(id);
    if (resp.success) {
      OvertimeModel request =
          OvertimeModel.fromJson(resp.data as Map<String, dynamic>);

      data['request'] = request;
    }
    List<ProcessOvertimeModel> listProcess =
        await overtimeService.getProcessOvertime(id);
    data['proccess'] = listProcess;
    return data;
  }

  Widget _processOvertime(List<ProcessOvertimeModel> listProcess) {
    List<Step> steps = [];
    for (var val in listProcess) {
      if (val.idSobretiempo != null) {
        steps.add(Step(
            isActive: val.idSobretiempo != null ? true : false,
            state: val.idSobretiempo != null
                ? val.idEstadoSobretiempo == '00' ||
                        val.idEstadoSobretiempo == '03' ||
                        val.idEstadoSobretiempo == '06'
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
                        '${val.email}: ${Jiffy.parse(val.fecha.toString(), pattern: "dd/MM/yyyy HH:mm").format(pattern: 'dd|MM|yyyy hh:mm a')}',
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

  void _showModalAnularRefuse(BuildContext context, String idTrabajador,
      String id, String idEstado, String text) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController inputFieldCtrl = TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
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
      String idTrabajador, String id, String idEstadoSobretiempo) async {
    final overtimeService = OvertimeService();
    Map<String, String> params = {
      'id_trabajador': idTrabajador.toString(),
      'id_estado_sobretiempo': idEstadoSobretiempo,
      'comentario': text
    };
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final create = await overtimeService.chageStatusOvertime(id, params);
    Get.until((route) => !Get.isDialogOpen!);
    if (create.success) {
      final userPref = UserPreferences();
      userPref.resultChange = true;
      Get.until((route) => Get.currentRoute == '/OvertimePage');
      onChangeList();
    }
  }

  void _showModalApprove(BuildContext context, String idTrabajador, String id,
      String idEstado) async {
    await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.info,
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
                      : idEstado == '04' && isDth
                          ? 'Aprobación DTH'
                          : '')
                  .toUpperCase()),
            ),
          ),
          content: Column(children: [
            Image.asset('assets/icons/check.png',
                height: 50, width: 50, color: ColorsApp.success),
            Text('¿Desea aprobar el sobretiempo?',
                style: GoogleFonts.montserrat(
                    color: ColorsApp.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14))
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
                onPressed: () => Get.back()
                // Navigator.of(context).pop()
                ),
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
                        ? '04'
                        : idEstado == '04' && isDth
                            ? '05'
                            : idEstado);
              },
            )
          ],
        ));

    /* await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
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
              Text('¿Desea aprobar el/la permiso/licencia?',
                  style: GoogleFonts.montserrat(
                      color: ColorsApp.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))
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
                  onPressed: () => Navigator.of(context).pop()),
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
          );
        }); */
  }
}
