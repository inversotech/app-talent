import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show ApiResponse, Survey, SurveyAnswer, SurveyItem;
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/quiz/quiz_service.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/app_screen.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/checkbox_app.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';

class FormQuiz extends StatefulWidget {
  final String idPerson;
  FormQuiz({Key? key, this.idPerson = ''}) : super(key: key);

  @override
  _FormQuizState createState() => _FormQuizState();
}

class _FormQuizState extends State<FormQuiz> {
  final ScrollController _scrollController = ScrollController();
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Survey _survey = new Survey();
  List<SurveyItem> _surveyItems = [];

  List<SurveyAnswer> _surveyAnswers = [];
  int id = 1;
  bool saveData = false;
  String messageSave = '';
  String idPerson = '';
  double _puntaje = 100.00;
  @override
  void initState() {
    super.initState();
    if (widget.idPerson.isNotEmpty) {
      idPerson = widget.idPerson;
    }
    _getSurveyCovid();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return AppScreen(
      scrollController: _scrollController,
      enablePullDown: false,
      enablePullUp: false,
      showTitleHeader: false,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(alignment: Alignment.center, children: [
          Form(
            key: _formKey,
            child: _survey.idEncuesta != null && !saveData
                ? Column(
                    children: [
                      AppBar(
                          centerTitle: true,
                          leading: Transform.translate(
                            offset: Offset(-15, -4),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(buildContext);
                              },
                              iconSize: 40,
                              icon: Icon(Icons.chevron_left,
                                  color: ColorsApp.primary, size: 30.0),
                            ),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          toolbarHeight: 40.0,
                          title: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                _survey.nombre.toString(),
                                style: GoogleFonts.montserrat(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: ColorsApp.primary),
                              ))),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_survey.terminos.toString(),
                                style: GoogleFonts.montserrat(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red)),
                            SizedBox(height: 12.0),
                            _surveyItems.length > 0
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    primary: false,
                                    itemCount: _surveyItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      SurveyItem surveyItem =
                                          _surveyItems[index];
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
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
                                                width: double.infinity,
                                                color: ColorsApp.primary,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          surveyItem.titulo
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white)),
                                                      surveyItem.descripcion !=
                                                              null
                                                          ? Text(
                                                              '(' +
                                                                  surveyItem
                                                                      .descripcion
                                                                      .toString() +
                                                                  ')',
                                                              style: GoogleFonts.montserrat(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white))
                                                          : Container(),
                                                    ],
                                                  ),
                                                )),
                                            surveyItem.tipoComponente == 'INPUT'
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: _createInputItem(
                                                        buildContext,
                                                        surveyItem,
                                                        surveyItem,
                                                        1))
                                                : surveyItem.tipoItemCodigo ==
                                                        'SE'
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child:
                                                            _widgetSurveyItems(
                                                                buildContext,
                                                                surveyItem,
                                                                1))
                                                    : Container(),
                                          ],
                                        ),
                                      );
                                    })
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          'No se encontró información para mostrar.',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.primary)),
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
                              onPressed: () {
                                _saveSurveyAnswers(buildContext);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/save.png',
                                      height: 30,
                                      width: 30,
                                      color: Colors.white),
                                  Text(
                                    'Guardar encuesta',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )))
                    ],
                  )
                : saveData
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 100.0),
                          _puntaje < 100.0
                              ? Icon(Icons.thumb_down,
                                  color: ColorsApp.danger, size: 100)
                              : Icon(Icons.thumb_up,
                                  color: ColorsApp.success, size: 100),
                          Text(
                            messageSave.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                color: ColorsApp.primary),
                          ),
                          SizedBox(height: 8.0),
                          TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return ColorsApp
                                        .primary; // Use the component's default.
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
                              onPressed: () {
                                Navigator.of(buildContext)
                                    .pop({'change': true});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, color: Colors.white),
                                  Text(
                                    'Regresar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ))
                        ],
                      )
                    : Container(
                        height: 200,
                      ),
          ),
          if (loading) ...[
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                top: 0.0,
                child: Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    child: Center(child: CircularProgressIndicator())))
          ]
        ]);
      }),
    );
  }

  Container _createInputItem(BuildContext buildContext, SurveyItem surveyItem,
      SurveyItem parent, int level) {
    if (surveyItem.valorInicial != null &&
        surveyItem.valorInicial!.isNotEmpty) {
      _addAnswer(
          surveyItem: surveyItem,
          parent: parent,
          respuesta: surveyItem.valorInicial.toString(),
          tipoPreguntaCodigo: surveyItem.tipoPreguntaCodigo.toString(),
          delete: false);
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
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
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: ColorsApp.primary),
            labelText: surveyItem.titulo,
            suffixIcon: surveyItem.valorInicial != null &&
                    surveyItem.valorInicial!.isNotEmpty
                ? Icon(Icons.check, color: ColorsApp.success)
                : null),
        style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: ColorsApp.primary),
        onSaved: (val) {},
        onChanged: (val) {
          _addAnswer(
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
      BuildContext buildContext, SurveyItem surveyItem, int level) {
    List<Widget> _list = [];
    surveyItem.items!.forEach(((element) {
      _list.add(_widgetSurveyItem(buildContext, element, surveyItem));
    }));
    return Column(children: _list);
  }

  Widget _widgetSurveyItem(
      BuildContext buildContext, SurveyItem surveyItem, SurveyItem parent) {
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
                            child: _widgetAlternatives(surveyItem),
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
        surveyItem.tipoComponente == 'INPUT'
            ? _createInputItem(buildContext, surveyItem, parent, 1)
            : Container(),
        surveyItem.tipoItemCodigo == 'PR' &&
                surveyItem.tipoComponente != 'INPUT' &&
                surveyItem.childrenAlign != 'RIGHT'
            ? _widgetAlternatives(surveyItem)
            : Container(),
        surveyItem.tipoItemCodigo == 'SE'
            ? _widgetSurveyItems(buildContext, surveyItem, 1)
            : Container()
      ],
    );
  }

  Widget _widgetAlternatives(SurveyItem surveyItem) {
    List<Widget> _list = [];
    surveyItem.items!.forEach(((element) {
      _list.add(_widgetAlternative(element, surveyItem));
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

  Widget _widgetAlternative(SurveyItem surveyItem, SurveyItem parent) {
    if (parent.tipoItemCodigo == 'PR' && parent.tipoComponente != 'INPUT') {
      if (parent.tipoComponente == 'RADIO' &&
          parent.valorInicial == surveyItem.idItem) {
        _addAnswer(
            surveyItem: surveyItem,
            parent: parent,
            tipoPreguntaCodigo: parent.tipoPreguntaCodigo.toString(),
            deleteAllParent: true);
      } else if (parent.tipoComponente == 'CHECKBOX' &&
          surveyItem.valorInicial == surveyItem.idItem) {
        _addAnswer(
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
                  setState(() {
                    parent.valorInicial = value ?? '';
                  });
                  _addAnswer(
                      surveyItem: surveyItem,
                      parent: parent,
                      tipoPreguntaCodigo: parent.tipoPreguntaCodigo.toString(),
                      deleteAllParent: true);
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
                      _addAnswer(
                          surveyItem: surveyItem,
                          parent: parent,
                          tipoPreguntaCodigo:
                              parent.tipoPreguntaCodigo.toString(),
                          delete: surveyItem.valorInicial == 'true');
                    }
                  })
            ],
          );
  }

  void _addAnswer(
      {required SurveyItem surveyItem,
      required SurveyItem parent,
      String respuesta = '',
      bool delete: false,
      String tipoPreguntaCodigo: '',
      bool deleteAllParent: false}) {
    if (deleteAllParent) {
      _surveyAnswers
          .removeWhere((element) => element.idPregunta == parent.idItem);
    } else {
      _surveyAnswers.removeWhere((element) =>
          element.idAlternativa == surveyItem.idItem &&
          element.idPregunta == parent.idItem);
    }
    if (!delete && surveyItem.idItem != null) {
      _surveyAnswers.add(SurveyAnswer(
          idAlternativa: surveyItem.idItem,
          idPregunta: parent.idItem,
          tipoPreguntaCodigo: tipoPreguntaCodigo,
          respuesta: respuesta,
          tipo: surveyItem.tipo));
    }
  }

  void _getSurveyCovid() async {
    setState(() {
      loading = true;
    });
    QuizService _quizService = QuizService();
    Map<String, String> params = {'id_persona': idPerson};
    ApiResponse _apiResponse = await _quizService.getQuizCovid(params);
    if (_apiResponse.success) {
      _survey = Survey.fromJson(_apiResponse.data);
      _surveyItems = _survey.items ?? [];
    }
    setState(() {
      loading = false;
    });
  }

  void _saveSurveyAnswers(BuildContext buildContext) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    ShowLoadingIndicator.showLoadingIndicator(
        text: 'Guardando ...', context: buildContext);
    QuizService _quizService = QuizService();
    UserPreferences userPref = UserPreferences();
    Map<String, String> params = {
      'id_persona': idPerson,
      'id_entidad': userPref.idEntity.toString(),
      'id_encuesta': _survey.idEncuesta.toString(),
      'answers': json.encode(_surveyAnswers.toList()).toString()
    };
    ApiResponse _apiResponse = await _quizService.saveAnswers(params);
    if (_apiResponse.success) {
      saveData = true;
      messageSave = _apiResponse.data['message'].toString();
      _puntaje = double.parse(_apiResponse.data['puntaje'].toString());
      setState(() {});
      Navigator.pop(buildContext);
      //Navigator.of(buildContext).pop();
    } else {
      Navigator.pop(buildContext);
    }
  }
}
