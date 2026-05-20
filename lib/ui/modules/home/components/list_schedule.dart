import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/justification/justification_service.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

void showModalSchedule(DateTime fecha) async {
  JustificationService justificationService = JustificationService();
  final userPreferences = UserPreferences();
  Map<String, String> params = {
    'fecha': DateFormat('y-MM-dd').format(fecha),
    'id_trabajador': userPreferences.idWorker.toString(),
    'id_entidad': userPreferences.idEntity.toString()
    // 'id_depto': userPreferences.idDeparment.toString()
  };
  Get.dialog(
      AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Image.asset('assets/icons/close.png',
                    height: 40, width: 40, color: ColorsApp.primary),
                onPressed: () => Get.back()),
          ),
          contentPadding: const EdgeInsets.all(Spacing.sm),
          titlePadding: EdgeInsets.zero,
          scrollable: false,
          content: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: Spacing.sm),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.h3('Horario programado', color: ColorsApp.primary),
                    AppText.label(
                        '${capitalize(DateFormat.EEEE('es').format(fecha))} ${DateFormat('dd|MM|yyyy').format(fecha)}',
                        color: ColorsApp.primary),
                    const SizedBox(height: Spacing.sm),
                    const Divider(height: 1, color: ColorsApp.primary),
                    const SizedBox(height: Spacing.sm),
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
                                            AppText.label('Entrada:', color: ColorsApp.primary),
                                            const SizedBox(height: Spacing.xs),
                                            AppText.body(
                                                DateFormat('dd|MM|yyyy hh:mm a')
                                                    .format(DateTime.parse(item
                                                        .fechahoraEntrada
                                                        .toString()))
                                                    .toLowerCase(),
                                                color: ColorsApp.primary),
                                            const SizedBox(height: Spacing.sm),
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
                                                      AppText.label(
                                                          'Salida al refrigerio:',
                                                          color: ColorsApp.primary),
                                                      const SizedBox(
                                                          height: Spacing.xs),
                                                      AppText.body(
                                                          DateFormat(
                                                                  'dd|MM|yyyy hh:mm a')
                                                              .format(DateTime
                                                                  .parse(item
                                                                      .fechahoraSalidaRef
                                                                      .toString()))
                                                              .toLowerCase(),
                                                          color: ColorsApp.primary),
                                                      const SizedBox(
                                                          height: Spacing.sm),
                                                      AppText.label(
                                                          'Entrada después del refrigerio:',
                                                          color: ColorsApp.primary),
                                                      const SizedBox(
                                                          height: Spacing.xs),
                                                      AppText.body(
                                                          DateFormat(
                                                                  'dd|MM|yyyy hh:mm a')
                                                              .format(DateTime
                                                                  .parse(item
                                                                      .fechahoraEntradaRef
                                                                      .toString()))
                                                              .toLowerCase(),
                                                          color: ColorsApp.primary),
                                                      const SizedBox(
                                                          height: Spacing.sm),
                                                    ],
                                                  )
                                                : Container(),
                                            AppText.label('Salida:', color: ColorsApp.primary),
                                            const SizedBox(height: Spacing.xs),
                                            AppText.body(
                                                DateFormat('dd|MM|yyyy hh:mm a')
                                                    .format(DateTime.parse(item
                                                        .fechahoraSalida
                                                        .toString()))
                                                    .toLowerCase(),
                                                color: ColorsApp.primary),
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
                              return Padding(
                                padding: const EdgeInsets.all(Spacing.md),
                                child: Center(
                                    child: AppText.body(
                                        'No se encontró información para mostrar',
                                        color: ColorsApp.neutral600)),
                              );
                            }
                          } catch (e) {
                            return Padding(
                              padding: const EdgeInsets.all(Spacing.md),
                              child: Center(
                                  child: AppText.body(
                                      'No se encontró información para mostrar',
                                      color: ColorsApp.neutral600)),
                            );
                          }
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(Spacing.md),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                  ],
                ),
              ),
            ),
          )),
      barrierDismissible: true);
}
