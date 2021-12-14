import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/justification/justification_service.dart';

void showModalSchedule(DateTime fecha) async {
  JustificationService justificationService = JustificationService();
  Map<String, String> params = {
    'fecha': DateFormat('y-MM-dd').format(fecha),
  };
  final styleTitle = GoogleFonts.montserrat(
      fontWeight: FontWeight.w600, color: ColorsApp.primary, fontSize: 13.0);

  final styleSubTitle = GoogleFonts.montserrat(
      fontWeight: FontWeight.w400, color: ColorsApp.primary, fontSize: 13.0);
  Get.dialog(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Horario programado',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: ColorsApp.primary,
                            fontSize: 16.0)),
                    Text(
                        capitalize(DateFormat.EEEE('es').format(fecha)) +
                            ' ' +
                            DateFormat('dd|MM|yyyy').format(fecha),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: ColorsApp.primary,
                            fontSize: 13.0)),
                    const SizedBox(height: 8.0),
                    const Divider(height: 1, color: ColorsApp.primary),
                    const SizedBox(height: 8.0),
                    FutureBuilder(
                      future: justificationService.getScheduleWorker(params),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          try {
                            List<ScheduleWorkerModel> listData = snapshot.data;
                            if (listData.isNotEmpty) {
                              return Stack(
                                children: [
                                  ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        final item = listData[index];
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Entrada:', style: styleTitle),
                                            const SizedBox(height: 4.0),
                                            Text(
                                                DateFormat('dd|MM|yyyy hh:mm a')
                                                    .format(DateTime.parse(item
                                                        .fechahoraEntrada
                                                        .toString()))
                                                    .toLowerCase(),
                                                style: styleSubTitle),
                                            const SizedBox(height: 8.0),
                                            item.fechahoraSalidaRef != null &&
                                                    item.fechahoraEntradaRef !=
                                                        null
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Salida al refrigerio:',
                                                          style: styleTitle),
                                                      const SizedBox(
                                                          height: 4.0),
                                                      Text(
                                                          DateFormat(
                                                                  'dd|MM|yyyy hh:mm a')
                                                              .format(DateTime
                                                                  .parse(item
                                                                      .fechahoraSalidaRef
                                                                      .toString()))
                                                              .toLowerCase(),
                                                          style: styleSubTitle),
                                                      const SizedBox(
                                                          height: 8.0),
                                                      Text(
                                                          'Entrada después del refrigerio:',
                                                          style: styleTitle),
                                                      const SizedBox(
                                                          height: 4.0),
                                                      Text(
                                                          DateFormat(
                                                                  'dd|MM|yyyy hh:mm a')
                                                              .format(DateTime
                                                                  .parse(item
                                                                      .fechahoraEntradaRef
                                                                      .toString()))
                                                              .toLowerCase(),
                                                          style: styleSubTitle),
                                                      const SizedBox(
                                                          height: 8.0),
                                                    ],
                                                  )
                                                : Container(),
                                            Text('Salida:', style: styleTitle),
                                            const SizedBox(height: 4.0),
                                            Text(
                                                DateFormat('dd|MM|yyyy hh:mm a')
                                                    .format(DateTime.parse(item
                                                        .fechahoraSalida
                                                        .toString()))
                                                    .toLowerCase(),
                                                style: styleSubTitle),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                            height: 1,
                                            color: ColorsApp.primary);
                                      },
                                      itemCount: listData.length),
                                ],
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(12.0),
                                child: const Center(
                                    child: Text(
                                        'No se encontró información para mostrar')),
                              );
                            }
                          } catch (e) {
                            return Container(
                              padding: const EdgeInsets.all(12.0),
                              child: const Center(
                                  child: Text(
                                      'No se encontró información para mostrar')),
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
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}
