import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/holiday/holiday.dart';
import 'package:lamb_talent/resources/models/holiday/worker_holiday.dart';
import 'package:lamb_talent/resources/services/holiday/holiday_service.dart';

class ListHolidayApprove extends StatelessWidget {
  final List<WorkerHolidayModel> listData;
  final BoxConstraints constraints;
  final bool isDth;
  final Function(BuildContext context, String text, String idEstado,
      String idWorker, String idPeriodoVacTrab) changeRequestStatus;
  const ListHolidayApprove(
      {Key? key,
      required this.listData,
      required this.constraints,
      this.isDth = false,
      required this.changeRequestStatus})
      : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    if (listData.isNotEmpty) {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            final data = listData[index];
            return TextButton(
              onPressed: () async {
                showModalDetail(buildContext, data);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: ColorsApp.info,
                          child: Text((index + 1).toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 22.0)),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0),
                              Text(
                                capitalize(data.nombres.toString()),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.primary,
                                    fontSize: 16.0),
                              ),
                              Text(
                                  'Periodo: ${Jiffy(data.periodoIni, 'dd/MM/yyyy').format('dd|MM|yyyy')} - ${Jiffy(data.periodoFin, 'dd/MM/yyyy').format('dd|MM|yyyy')}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsApp.primary,
                                      fontSize: 12.0)),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 40.0),
                              Text(
                                data.estado.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                    color: data.idEstadoVacTrab == '01'
                                        ? ColorsApp.primary
                                        : data.idEstadoVacTrab == '02'
                                            ? ColorsApp.success
                                            : data.idEstadoVacTrab == '03'
                                                ? ColorsApp.warning
                                                : Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            'Duración: ${data.totalDias} días',
                            style: GoogleFonts.montserratAlternates(
                                fontWeight: FontWeight.w500,
                                color: ColorsApp.primary,
                                fontSize: 12.0),
                          )
                        ],
                      ),
                    ),
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
          itemCount: listData.length);
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

  void showModalDetail(
      BuildContext buildContext, WorkerHolidayModel data) async {
    final Map<String, String> params = {
      'id_trabajador': data.idTrabajador.toString(),
      'id_periodo_vac_trab': data.idPeriodoVacTrab.toString(),
      'id_persona': data.idPersona.toString()
    };
    List<HolidayModel> listData = [];
    final holidayService = HolidayService();
    await Get.dialog(
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
              onPressed: () => Get.back()),
        ),
        contentPadding: const EdgeInsets.all(8.0),
        titlePadding: EdgeInsets.zero,
        scrollable: false,
        content: SizedBox(
          width: Get.width,
          // width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: holidayService.getHolidays(params),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  try {
                    int totalPro = 0;
                    int totalGo = 0;
                    listData = snapshot.data;
                    for (var element in listData) {
                      totalPro = totalPro + int.parse(element.dias.toString());
                      totalGo =
                          totalGo + int.parse(element.diasEfect.toString());
                    }
                    return listData.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text('Programación:',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsApp.primary,
                                        fontSize: 16.0)),
                              ),
                              const SizedBox(height: 4.0),
                              ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    final data = listData[index];
                                    return TextButton(
                                      onPressed: () async {},
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      ColorsApp.white,
                                                  child: Text(
                                                      (index + 1).toString(),
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: ColorsApp
                                                                  .primary,
                                                              fontSize: 22.0)),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 4.0),
                                                      Text(
                                                        capitalize(data
                                                            .nombrePeriodo
                                                            .toString()),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: ColorsApp
                                                                    .primary,
                                                                fontSize: 16.0),
                                                      ),
                                                      Text(
                                                          'Fecha: ${Jiffy(data.fechaIni, 'dd/MM/yyyy').format('dd|MM|yyyy')} - ${Jiffy(data.fechaFin, 'dd/MM/yyyy').format('dd|MM|yyyy')}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: ColorsApp
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                          width: 40.0),
                                                      Text(
                                                        data.estadoTrab
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12.0,
                                                                color: data.idEstadoVacTrab ==
                                                                        '01'
                                                                    ? ColorsApp
                                                                        .primary
                                                                    : data.idEstadoVacTrab ==
                                                                            '02'
                                                                        ? ColorsApp
                                                                            .success
                                                                        : data.idEstadoVacTrab ==
                                                                                '03'
                                                                            ? ColorsApp.warning
                                                                            : Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Duración: ${data.dias} días',
                                                    style: GoogleFonts
                                                        .montserratAlternates(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorsApp
                                                                .primary,
                                                            fontSize: 12.0),
                                                  )
                                                ],
                                              ),
                                            ),
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
                                  itemCount: listData.length),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Total días programados',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsApp.primary),
                                            ),
                                            Text(
                                              totalPro.toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsApp.primary),
                                            )
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Total días gozados',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsApp.primary),
                                            ),
                                            Text(
                                              totalGo.toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorsApp.primary),
                                            )
                                          ]),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                                    'No se encontró información para mostrar',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary))),
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
        actions: data.idEstadoVacTrab != '02' && isDth
            ? [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return ColorsApp
                                        .warning; // Use the component's default.
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
                                child: Text('Observar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () {
                                _showModalAnularRefuse(
                                    buildContext,
                                    '03',
                                    'Observar',
                                    data.nombres.toString(),
                                    data.idTrabajador.toString(),
                                    data.idPeriodoVacTrab.toString());
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
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
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Aprobar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () {
                                _showModalApprove(
                                    buildContext,
                                    '02',
                                    data.nombres.toString(),
                                    int.parse((data.totalDias ?? 0).toString()),
                                    data.idTrabajador.toString(),
                                    data.idPeriodoVacTrab.toString());
                              },
                            ),
                          )
                        ]),
                  ),
                )
              ]
            : null,
      ),
      barrierDismissible: true,
    );

    /* await showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (context) {
          List<HolidayModel> listData = [];
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
            contentPadding: const EdgeInsets.all(8.0),
            titlePadding: EdgeInsets.zero,
            scrollable: false,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: holidayService.getHolidays(params),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      try {
                        int totalPro = 0;
                        int totalGo = 0;
                        listData = snapshot.data;
                        for (var element in listData) {
                          totalPro =
                              totalPro + int.parse(element.dias.toString());
                          totalGo =
                              totalGo + int.parse(element.diasEfect.toString());
                        }
                        return listData.isNotEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Programación:',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary,
                                            fontSize: 16.0)),
                                  ),
                                  const SizedBox(height: 4.0),
                                  ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        final data = listData[index];
                                        return TextButton(
                                          onPressed: () async {},
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 18,
                                                      backgroundColor:
                                                          ColorsApp.white,
                                                      child: Text(
                                                          (index + 1)
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: ColorsApp
                                                                      .primary,
                                                                  fontSize:
                                                                      22.0)),
                                                    ),
                                                    const SizedBox(width: 8.0),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 4.0),
                                                          Text(
                                                            capitalize(data
                                                                .nombrePeriodo
                                                                .toString()),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: ColorsApp
                                                                        .primary,
                                                                    fontSize:
                                                                        16.0),
                                                          ),
                                                          Text(
                                                              'Fecha: ${Jiffy(data.fechaIni, 'dd/MM/yyyy').format('dd|MM|yyyy')} - ${Jiffy(data.fechaFin, 'dd/MM/yyyy').format('dd|MM|yyyy')}',
                                                              style: GoogleFonts.montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: ColorsApp
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0)),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 40.0),
                                                          Text(
                                                            data.estadoTrab
                                                                .toString(),
                                                            style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12.0,
                                                                color: data.idEstadoVacTrab == '01'
                                                                    ? ColorsApp.primary
                                                                    : data.idEstadoVacTrab == '02'
                                                                        ? ColorsApp.success
                                                                        : data.idEstadoVacTrab == '03'
                                                                            ? ColorsApp.warning
                                                                            : Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Duración: ${data.dias} días',
                                                        style: GoogleFonts
                                                            .montserratAlternates(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: ColorsApp
                                                                    .primary,
                                                                fontSize: 12.0),
                                                      )
                                                    ],
                                                  ),
                                                ),
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
                                      itemCount: listData.length),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total días programados',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                ),
                                                Text(
                                                  totalPro.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                )
                                              ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total días gozados',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                ),
                                                Text(
                                                  totalGo.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: ColorsApp.primary),
                                                )
                                              ]),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                    child: Text(
                                        'No se encontró información para mostrar',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            color: ColorsApp.primary))),
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
            actions: data.idEstadoVacTrab != '02' && isDth
                ? [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        return ColorsApp
                                            .warning; // Use the component's default.
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Observar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  onPressed: () {
                                    _showModalAnularRefuse(
                                        context,
                                        '03',
                                        'Observar',
                                        data.nombres.toString(),
                                        data.idTrabajador.toString(),
                                        data.idPeriodoVacTrab.toString());
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: TextButton(
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
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
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Aprobar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  onPressed: () {
                                    _showModalApprove(
                                        context,
                                        '02',
                                        data.nombres.toString(),
                                        int.parse(
                                            (data.totalDias ?? 0).toString()),
                                        data.idTrabajador.toString(),
                                        data.idPeriodoVacTrab.toString());
                                  },
                                ),
                              )
                            ]),
                      ),
                    )
                  ]
                : null,
          );
        }); */
  }

  void _showModalApprove(BuildContext context, String idEstado, String nombres,
      int totalDias, String idWorker, String idPeriodoVacTrab) async {
    if (totalDias == 30) {
      await Get.dialog(
          barrierDismissible: false,
          AlertDialog(
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
                child: Text(('Aprobar').toUpperCase()),
              ),
            ),
            content: Column(children: [
              Image.asset('assets/icons/check.png',
                  height: 50, width: 50, color: ColorsApp.success),
              Text('¿Desea aprobar la vacación programada de: $nombres?',
                  style: GoogleFonts.montserrat(
                      color: ColorsApp.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  textAlign: TextAlign.center)
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
                      context, '', idEstado, idWorker, idPeriodoVacTrab);
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
                  child: Text(('Aprobar').toUpperCase()),
                ),
              ),
              content: Column(children: [
                Image.asset('assets/icons/check.png',
                    height: 50, width: 50, color: ColorsApp.success),
                Text('¿Desea aprobar la vacación programada de: $nombres?',
                    style: GoogleFonts.montserrat(
                        color: ColorsApp.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    textAlign: TextAlign.center)
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () => Navigator.of(context).pop()),
                TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Estoy de acuerdo!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () {
                    changeRequestStatus(
                        context, '', idEstado, idWorker, idPeriodoVacTrab);
                  },
                )
              ],
            );
          }); */
    } else {
      Get.snackbar('Mensaje:',
          'Actualmente se programó sólo $totalDias días, debe completar los 30 días',
          duration: const Duration(seconds: 8),
          colorText: ColorsApp.white,
          backgroundColor: ColorsApp.warning);
    }
  }

  void _showModalAnularRefuse(
      BuildContext context,
      String idEstado,
      String text,
      String nombres,
      String idWorker,
      String idPeriodoVacTrab) async {
    TextEditingController inputFieldCtrl = TextEditingController();
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
            child: Text(text.toUpperCase()),
          )),
          content: TextFormField(
            controller: inputFieldCtrl,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
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
                    context,
                    inputFieldCtrl.value.text.isNotEmpty
                        ? inputFieldCtrl.value.text
                        : '',
                    idEstado,
                    idWorker,
                    idPeriodoVacTrab);
              },
            )
          ],
        ));

    /* await showDialog(
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
                      context,
                      inputFieldCtrl.value.text.isNotEmpty
                          ? inputFieldCtrl.value.text
                          : '',
                      idEstado,
                      idWorker,
                      idPeriodoVacTrab);
                },
              )
            ],
          );
        }); */
  }
}
