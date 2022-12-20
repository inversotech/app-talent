import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/survey/form_survey_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/quiz/quiz_item.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/checkbox_app.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FormSurveyPerson extends StatelessWidget {
  final String idPerson;
  const FormSurveyPerson({Key? key, required this.idPerson}) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    return GetBuilder<FormSurveyController>(
        init: FormSurveyController(idPerson: idPerson),
        builder: (controller) {
          return AppScreen(
            codePage: '16120103',
            scrollController: controller.scrollController,
            enablePullDown: false,
            enablePullUp: false,
            showTitleHeader: false,
            paddingTop: 4,
            paddingLeft: 4,
            paddingRight: 4,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Obx(() => !controller.loadingData.value
                  ? Form(
                      key: controller.formKey,
                      child: controller.survey.idEncuesta != null &&
                              !controller.saveData.value
                          ? Column(
                              children: [
                                AppBar(
                                    centerTitle: true,
                                    leading: Transform.translate(
                                      offset: const Offset(-15, -4),
                                      child: IconButton(
                                        onPressed: () {
                                          controller.goToBack(false);
                                        },
                                        iconSize: 40,
                                        icon: const Icon(Icons.chevron_left,
                                            color: ColorsApp.primary,
                                            size: 30.0),
                                      ),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    toolbarHeight: 40.0,
                                    title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          controller.survey.nombre.toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: ColorsApp.primary),
                                        ))),
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      controller.survey.terminos != null
                                          ? Text(
                                              controller.survey.terminos
                                                  .toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red))
                                          : Container(),
                                      controller.survey.descripcionLink != null
                                          ? const SizedBox(height: 8.0)
                                          : Container(),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: controller
                                                    .survey.descripcionLink
                                                    .toString() +
                                                ' ',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${controller.survey.nombreLink != null ? controller.survey.nombreLink.toString() : ''} ',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (await canLaunchUrlString(
                                                    controller.survey.link
                                                        .toString())) {
                                                  await launchUrlString(
                                                      controller.survey.link
                                                          .toString());
                                                } else {}
                                              },
                                          ),
                                          TextSpan(
                                            text: ' y ',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text:
                                                '${controller.survey.nombreLinkOpcional != null ? controller.survey.nombreLinkOpcional.toString() : ''} ',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (await canLaunchUrlString(
                                                    controller
                                                        .survey.linkOpcional
                                                        .toString())) {
                                                  await launchUrlString(
                                                      controller
                                                          .survey.linkOpcional
                                                          .toString());
                                                } else {}
                                              },
                                          ),
                                        ]),
                                      ),
                                      const SizedBox(height: 12.0),
                                      controller.surveyItems.isNotEmpty
                                          ? ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              primary: false,
                                              itemCount:
                                                  controller.surveyItems.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final surveyItem = controller
                                                    .surveyItems[index];
                                                return Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5), // if you need this
                                                    side: BorderSide(
                                                      color: ColorsApp.primary
                                                          .withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          color:
                                                              ColorsApp.primary,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    surveyItem
                                                                        .titulo
                                                                        .toString(),
                                                                    style: GoogleFonts.montserrat(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .white)),
                                                                surveyItem.descripcion !=
                                                                        null
                                                                    ? Text(
                                                                        '(' +
                                                                            surveyItem.descripcion
                                                                                .toString() +
                                                                            ')',
                                                                        style: GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: Colors.white))
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          )),
                                                      surveyItem.tipoComponente ==
                                                              'INPUT'
                                                          ? Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: _createInputItem(
                                                                  surveyItem,
                                                                  surveyItem,
                                                                  1,
                                                                  controller))
                                                          : surveyItem.tipoItemCodigo ==
                                                                  'SE'
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: _widgetSurveyItems(
                                                                      surveyItem,
                                                                      1,
                                                                      controller))
                                                              : Container(),
                                                    ],
                                                  ),
                                                );
                                              })
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                    'No se encontró información para mostrar.',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ColorsApp
                                                                .primary)),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 200,
                                    alignment: Alignment.center,
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
                                          shape:
                                              MaterialStateProperty.resolveWith<
                                                  RoundedRectangleBorder>(
                                            (Set<MaterialState> states) {
                                              return RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)); // Use the component's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          controller
                                              .saveSurveyAnswers(buildContext);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset('assets/icons/save.png',
                                                height: 30,
                                                width: 30,
                                                color: Colors.white),
                                            const Text(
                                              'Guardar encuesta',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )))
                              ],
                            )
                          : controller.saveData.value
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 100.0),
                                    controller.puntaje.value < 100.0
                                        ? const Icon(Icons.thumb_down,
                                            color: ColorsApp.danger, size: 100)
                                        : const Icon(Icons.thumb_up,
                                            color: ColorsApp.success,
                                            size: 100),
                                    Text(
                                      controller.messageSave.value.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: ColorsApp.primary),
                                    ),
                                    const SizedBox(height: 8.0),
                                    TextButton(
                                        style: ButtonStyle(
                                          alignment: Alignment.center,
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              return ColorsApp
                                                  .primary; // Use the component's default.
                                            },
                                          ),
                                          shape:
                                              MaterialStateProperty.resolveWith<
                                                  RoundedRectangleBorder>(
                                            (Set<MaterialState> states) {
                                              return RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)); // Use the component's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          controller.goToBack(true);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            Text(
                                              'Regresar',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                              : Container(
                                  height: 200,
                                ),
                    )
                  : Container());
            }),
          );
        });
  }

  Container _createInputItem(SurveyItem surveyItem, SurveyItem parent,
      int level, FormSurveyController controller) {
    if (surveyItem.valorInicial != null &&
        surveyItem.valorInicial!.isNotEmpty) {
      controller.addAnswer(
          surveyItem: surveyItem,
          parent: parent,
          respuesta: surveyItem.valorInicial.toString(),
          tipoPreguntaCodigo: surveyItem.tipoPreguntaCodigo.toString(),
          delete: false);
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        enabled: surveyItem.valorInicial != null &&
                surveyItem.valorInicial!.isNotEmpty &&
                (surveyItem.tipoPreguntaCodigo == 'NOMBRE' ||
                    surveyItem.tipoPreguntaCodigo == 'APPAT' ||
                    surveyItem.tipoPreguntaCodigo == 'APMAT' ||
                    surveyItem.tipoPreguntaCodigo == 'DOC')
            ? false
            : true,
        initialValue: surveyItem.valorInicial ?? '',
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: surveyItem.titulo,
            suffixIcon: surveyItem.valorInicial != null &&
                    surveyItem.valorInicial!.isNotEmpty
                ? const Icon(Icons.check, color: ColorsApp.success)
                : null),
        style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: ColorsApp.primary),
        onSaved: (val) {},
        onChanged: (val) {
          controller.addAnswer(
              surveyItem: surveyItem,
              parent: parent,
              respuesta: val,
              tipoPreguntaCodigo: surveyItem.tipoPreguntaCodigo.toString(),
              delete: val.isEmpty);
        },
        validator: (value) {
          if (value!.isEmpty && surveyItem.obligatorio == '1') {
            return 'Campo requerido.';
          }
          return null;
        },
      ),
    );
  }

  Column _widgetSurveyItems(
      SurveyItem surveyItem, int level, FormSurveyController controller) {
    List<Widget> _list = [];
    surveyItem.items!.forEach(((element) {
      _list.add(_widgetSurveyItem(element, surveyItem, controller));
    }));
    return Column(children: _list);
  }

  Widget _widgetSurveyItem(SurveyItem surveyItem, SurveyItem parent,
      FormSurveyController controller) {
    return Column(
      children: [
        surveyItem.tipoComponente != 'INPUT'
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Wrap(
                        children: [
                          Text(surveyItem.titulo.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsApp.primary)),
                          surveyItem.descripcion != null
                              ? Text(
                                  '(' + surveyItem.descripcion.toString() + ')',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsApp.primary))
                              : Container(),
                        ],
                      ),
                    ),
                    surveyItem.tipoItemCodigo == 'PR' &&
                            surveyItem.tipoComponente != 'INPUT' &&
                            surveyItem.childrenAlign == 'RIGHT'
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: _widgetAlternatives(surveyItem, controller),
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
        surveyItem.tipoComponente == 'INPUT'
            ? _createInputItem(surveyItem, parent, 1, controller)
            : Container(),
        surveyItem.tipoItemCodigo == 'PR' &&
                surveyItem.tipoComponente != 'INPUT' &&
                surveyItem.childrenAlign != 'RIGHT'
            ? _widgetAlternatives(surveyItem, controller)
            : Container(),
        surveyItem.tipoItemCodigo == 'SE'
            ? _widgetSurveyItems(surveyItem, 1, controller)
            : Container()
      ],
    );
  }

  Widget _widgetAlternatives(
      SurveyItem surveyItem, FormSurveyController controller) {
    List<Widget> _list = [];
    surveyItem.items!.forEach(((element) {
      _list.add(_widgetAlternative(element, surveyItem, controller));
    }));
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: surveyItem.orientacion == 'H'
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: surveyItem.childrenAlign == 'BOTTOM_LEFT'
                  ? MainAxisAlignment.start
                  : surveyItem.childrenAlign == 'BOTTOM_RIGHT'
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
              children: _list,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: surveyItem.childrenAlign == 'BOTTOM_LEFT'
                  ? MainAxisAlignment.start
                  : surveyItem.childrenAlign == 'BOTTOM_RIGHT'
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
              children: _list,
            ),
    );
  }

  Widget _widgetAlternative(SurveyItem surveyItem, SurveyItem parent,
      FormSurveyController controller) {
    if (parent.tipoItemCodigo == 'PR' && parent.tipoComponente != 'INPUT') {
      if (parent.tipoComponente == 'RADIO' &&
          parent.valorInicial == surveyItem.idItem) {
        controller.addAnswer(
            surveyItem: surveyItem,
            parent: parent,
            tipoPreguntaCodigo: parent.tipoPreguntaCodigo.toString(),
            deleteAllParent: true);
      } else if (parent.tipoComponente == 'CHECKBOX' &&
          surveyItem.valorInicial == surveyItem.idItem) {
        controller.addAnswer(
            surveyItem: surveyItem,
            parent: parent,
            tipoPreguntaCodigo: parent.tipoPreguntaCodigo.toString(),
            deleteAllParent: true);
      }
    }
    return parent.tipoComponente == 'RADIO'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(surveyItem.titulo.toString(),
                  style: GoogleFonts.montserrat(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: ColorsApp.primary)),
              Radio<String>(
                value: surveyItem.idItem.toString(),
                groupValue: parent.valorInicial,
                onChanged: (String? value) {
                  parent.valorInicial = value ?? '';
                  controller.addAnswer(
                      surveyItem: surveyItem,
                      parent: parent,
                      tipoPreguntaCodigo: parent.tipoPreguntaCodigo.toString(),
                      deleteAllParent: true);

                  controller.loadingData.value = true;
                  controller.loadingData.value = false;
                },
              )
            ],
          )
        : Row(
            children: [
              Text(surveyItem.titulo.toString(),
                  style: GoogleFonts.montserrat(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: ColorsApp.primary)),
              CheckboxApp(
                  size: 15,
                  value: surveyItem.valorInicial == 'true',
                  onChanged: (val) {
                    surveyItem.valorInicial = val ? 'true' : null;
                    if (val) {
                      controller.addAnswer(
                          surveyItem: surveyItem,
                          parent: parent,
                          tipoPreguntaCodigo:
                              parent.tipoPreguntaCodigo.toString(),
                          delete: surveyItem.valorInicial == 'true');
                    }
                    controller.loadingData.value = true;
                    controller.loadingData.value = false;
                  })
            ],
          );
  }
}
