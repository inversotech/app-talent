import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';

class ButtonMarkingController extends GetxController {
  final String hourMarking;
  final int minutosTolerancia;
  final String descripcionMarcacion;
  final String idDescripcionMarcacion;
  Timer? _timer;
  RxString titleMarking = '¡Felicitaciones!'.obs;
  RxString subTitleMarking = 'Estas a tiempo para marcar tu asistencia de'.obs;
  RxString textMarking = Jiffy().format('hh:mm:ss a').obs;
  Color colorButtonMarking = ColorsApp.success;
  ButtonMarkingController(
      {required this.hourMarking,
      required this.minutosTolerancia,
      required this.descripcionMarcacion,
      required this.idDescripcionMarcacion});
  @override
  void onReady() {
    _timeInterval();
    super.onReady();
  }

  @override
  void onClose() {
    _timer!.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void _timeInterval() {
    DateTime timeMarking = DateTime.parse(hourMarking);
    DateTime timeNow =
        DateTime.parse(Jiffy().format('yyyy-MM-dd HH:mm').toString());
    DateTime timeTolerancia =
        timeMarking.add(Duration(minutes: minutosTolerancia));
    RxBool nowAfterMarking = timeNow.isAfter(timeMarking).obs;
    RxBool toleranceAfterNow = timeTolerancia.isAfter(timeNow).obs;
    if (nowAfterMarking.value &&
        (idDescripcionMarcacion == '01' || idDescripcionMarcacion == '03')) {
      if (nowAfterMarking.value && toleranceAfterNow.value) {
        titleMarking = '¡Apresúrate!'.obs;
        subTitleMarking =
            'Estás en el tiempo de telerancia para marcar tu asistencia de'.obs;
        colorButtonMarking = ColorsApp.warning;
      } else {
        titleMarking = '¡Atención!'.obs;
        subTitleMarking = 'Falta marcar tu asistencia de '.obs;
        colorButtonMarking = ColorsApp.danger;
      }
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      textMarking.value = Jiffy().format('hh:mm:ss a');
      DateTime timeMarking = DateTime.parse(hourMarking);
      DateTime timeNow =
          DateTime.parse(Jiffy().format('yyyy-MM-dd HH:mm').toString());
      DateTime timeTolerancia =
          timeMarking.add(Duration(minutes: minutosTolerancia));
      RxBool nowAfterMarking = timeNow.isAfter(timeMarking).obs;
      RxBool toleranceAfterNow = timeTolerancia.isAfter(timeNow).obs;
      if (nowAfterMarking.value &&
          (idDescripcionMarcacion == '01' || idDescripcionMarcacion == '03')) {
        if (nowAfterMarking.value && toleranceAfterNow.value) {
          titleMarking = '¡Apresúrate!'.obs;
          subTitleMarking =
              'Estás en el tiempo de telerancia para marcar tu asistencia de'
                  .obs;
          colorButtonMarking = ColorsApp.warning;
        } else {
          titleMarking = '¡Atención!'.obs;
          subTitleMarking = 'Falta marcar tu asistencia de '.obs;
          colorButtonMarking = ColorsApp.danger;
        }
      }
    });
  }
}
