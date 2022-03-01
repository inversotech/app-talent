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
  RxString subTitleMarking = 'Ya puedes marcar tu asistencia'.obs;
  RxString textMarking = Jiffy().format('hh:mm:ss a').obs;
  Color colorButtonMarking = ColorsApp.success;
  ButtonMarkingController(
      {required this.hourMarking,
      required this.minutosTolerancia,
      required this.descripcionMarcacion,
      required this.idDescripcionMarcacion});
  @override
  void onReady() {
    if(idDescripcionMarcacion=='02'){
      subTitleMarking = 'Es hora de almorzar, ya puedes marcar tu salida'.obs;
    }else if(idDescripcionMarcacion=='03'){
      subTitleMarking = 'Ya puedes marcar tu retorno'.obs;
    }else if(idDescripcionMarcacion=='04'){
      subTitleMarking = 'Es momento de ir a casa, ya puedes marcar tu salida'.obs;
    }
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
        idDescripcionMarcacion == '01') {
      if (nowAfterMarking.value && toleranceAfterNow.value) {
        subTitleMarking =
            'Upps estás un poco tarde, pero aún puedes marcar'.obs;
        colorButtonMarking = ColorsApp.warning;
      } else {
        subTitleMarking = 'Upps estás tarde, pero puedes marcar'.obs;
        colorButtonMarking = ColorsApp.danger;
      }
    }
    if (nowAfterMarking.value && idDescripcionMarcacion == '03') {
      if (nowAfterMarking.value && toleranceAfterNow.value) {
        subTitleMarking =
            'Upps estás un poco tarde, pero aún puedes marcar tu retorno'.obs;
        colorButtonMarking = ColorsApp.warning;
      } else {
        subTitleMarking = 'Upps estás tarde, pero puedes marcar tu retorno'.obs;
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
          idDescripcionMarcacion == '01') {
        if (nowAfterMarking.value && toleranceAfterNow.value) {
          subTitleMarking =
              'Upps estás un poco tarde, pero aún puedes marcar'
                  .obs;
          colorButtonMarking = ColorsApp.warning;
        } else {
          subTitleMarking = 'Upps estás tarde, pero puedes marcar'.obs;
          colorButtonMarking = ColorsApp.danger;
        }
      }
      if (nowAfterMarking.value && idDescripcionMarcacion == '03') {
        if (nowAfterMarking.value && toleranceAfterNow.value) {
          subTitleMarking =
              'Upps estás un poco tarde, pero aún puedes marcar tu retorno'
                  .obs;
          colorButtonMarking = ColorsApp.warning;
        } else {
          subTitleMarking = 'Upps estás tarde, pero puedes marcar tu retorno'.obs;
          colorButtonMarking = ColorsApp.danger;
        }
      }
    });
  }
}
