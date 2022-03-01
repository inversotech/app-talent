import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';
import 'package:lamb_talent/resources/models/quiz/quiz_answer.dart';
import 'package:lamb_talent/resources/models/quiz/quiz_item.dart';
import 'package:lamb_talent/resources/services/survey/survey_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

class FormSurveyController extends GetxController {
  final scrollController = ScrollController();

  final formKey = GlobalKey<FormState>();
  final String idPerson;

  Survey survey = Survey();
  List<SurveyItem> surveyItems = [];

  List<SurveyAnswer> surveyAnswers = [];
  RxBool loadingData = true.obs;
  RxInt id = 1.obs;
  RxBool saveData = false.obs;
  RxString messageSave = ''.obs;
  RxDouble puntaje = 100.00.obs;
  FormSurveyController({required this.idPerson});
  @override
  void onReady() {
    _getSurveyCovid();
    super.onReady();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _getSurveyCovid() async {
    loadingIndicator(onlyLoading: true, opacity: false);
    final _surveyService = SurveyService();
    Map<String, String> params = {'id_persona': idPerson};
    final _apiResponse = await _surveyService.getQuizCovid(params);
    if (_apiResponse.success) {
      survey = Survey.fromJson(_apiResponse.data);
      surveyItems = survey.items ?? [];
    }
    loadingData.value = true;
    loadingData.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void addAnswer(
      {required SurveyItem surveyItem,
      required SurveyItem parent,
      String respuesta = '',
      bool delete = false,
      String tipoPreguntaCodigo = '',
      bool deleteAllParent = false}) {
    if (deleteAllParent) {
      surveyAnswers
          .removeWhere((element) => element.idPregunta == parent.idItem);
    } else {
      surveyAnswers.removeWhere((element) =>
          element.idAlternativa == surveyItem.idItem &&
          element.idPregunta == parent.idItem);
    }
    if (!delete && surveyItem.idItem != null) {
      surveyAnswers.add(SurveyAnswer(
          idAlternativa: surveyItem.idItem,
          idPregunta: parent.idItem,
          tipoPreguntaCodigo: tipoPreguntaCodigo,
          respuesta: respuesta,
          tipo: surveyItem.tipo));
    }
  }

  void saveSurveyAnswers(BuildContext buildContext) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    final _surveyService = SurveyService();
    final userPref = UserPreferences();
    Map<String, String> params = {
      'id_persona': idPerson,
      'id_entidad': userPref.idEntity.toString(),
      'id_encuesta': survey.idEncuesta.toString(),
      'answers': json.encode(surveyAnswers.toList()).toString()
    };
    final _apiResponse = await _surveyService.saveAnswers(params);
    if (_apiResponse.success) {
      saveData.value = true;
      messageSave.value = _apiResponse.data['message'].toString();
      puntaje.value = double.parse(_apiResponse.data['puntaje'].toString());
    }
    loadingData.value = true;
    loadingData.value = false;
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  void goToBack(bool change) {
    if (change) {
      Get.back(result: {'change': true, 'data': null});
    } else {
      Get.back();
    }
  }
}
