import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';
import 'package:lamb_talent/resources/models/quiz/quiz_item.dart';
import 'package:lamb_talent/resources/services/survey/survey_service.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';

class DetailSurvey extends StatefulWidget {
  final String idPerson;
  final String idEntidad;
  final String idEncuesta;
  final String fecha;
  const DetailSurvey(
      {Key? key,
      required this.idPerson,
      required this.idEntidad,
      required this.idEncuesta,
      required this.fecha})
      : super(key: key);

  @override
  _DetailSurveyState createState() => _DetailSurveyState();
}

class _DetailSurveyState extends State<DetailSurvey> {
  final ScrollController _scrollController = ScrollController();
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Survey _survey = Survey();
  List<SurveyItem> _surveyItems = [];

  String idPerson = '';
  @override
  void initState() {
    super.initState();
    _getSurveyCovidDetail();
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
              child: Column(
                children: [
                  AppBar(
                      centerTitle: true,
                      leading: Transform.translate(
                        offset: const Offset(-15, -4),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(buildContext);
                          },
                          iconSize: 40,
                          icon: const Icon(Icons.chevron_left,
                              color: ColorsApp.primary, size: 30.0),
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.white,
                      toolbarHeight: 40.0,
                      title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _survey.nombre != null
                                ? _survey.nombre.toString()
                                : '',
                            style: GoogleFonts.montserrat(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: ColorsApp.primary),
                          ))),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                          'Fecha: ' +
                              Jiffy(widget.fecha, 'yyyy-MM-dd')
                                  .format('dd|MM|yyyy')
                                  .toString(),
                          style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: ColorsApp.primary))),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12.0),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            primary: false,
                            itemCount: _surveyItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              SurveyItem surveyItem = _surveyItems[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // if you need this
                                  side: BorderSide(
                                    color: ColorsApp.primary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        color: ColorsApp.primary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(surveyItem.titulo.toString(),
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                              surveyItem.descripcion != null
                                                  ? Text(
                                                      '(' +
                                                          surveyItem.descripcion
                                                              .toString() +
                                                          ')',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white))
                                                  : Container(),
                                            ],
                                          ),
                                        )),
                                    surveyItem.tipoComponente == 'INPUT'
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: _createInputItem(
                                                buildContext,
                                                surveyItem,
                                                surveyItem,
                                                1))
                                        : surveyItem.tipoItemCodigo == 'SE'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: _widgetSurveyItems(
                                                    buildContext,
                                                    surveyItem,
                                                    1))
                                            : Container(),
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  )
                ],
              )),
          if (loading) ...[
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                top: 0.0,
                child: Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    child: const Center(child: CircularProgressIndicator())))
          ]
        ]);
      }),
    );
  }

  Container _createInputItem(BuildContext buildContext, SurveyItem surveyItem,
      SurveyItem parent, int level) {
    return Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(surveyItem.titulo.toString() + ':',
                style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.primary)),
            Text(surveyItem.respuesta.toString(),
                style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: ColorsApp.primary)),
          ],
        ));
  }

  Widget _widgetSurveyItems(
      BuildContext buildContext, SurveyItem surveyItem, int level) {
    List<Widget> _list = [];
    surveyItem.items!.forEach(((element) {
      _list.add(_widgetSurveyItem(buildContext, element, surveyItem));
    }));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _list),
    );
  }

  Widget _widgetSurveyItem(
      BuildContext buildContext, SurveyItem surveyItem, SurveyItem parent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        surveyItem.tipoComponente != 'INPUT'
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Wrap(
                  children: [
                    Text(
                        surveyItem.titulo.toString() +
                            (surveyItem.descripcion != null ? '' : ':'),
                        style: GoogleFonts.montserrat(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: ColorsApp.primary)),
                    surveyItem.descripcion != null
                        ? Text('(' + surveyItem.descripcion.toString() + '):',
                            style: GoogleFonts.montserrat(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ColorsApp.primary))
                        : Container(),
                  ],
                ),
              )
            : Container(),
        surveyItem.tipoComponente == 'INPUT'
            ? _createInputItem(buildContext, surveyItem, parent, 1)
            : Container(),
        surveyItem.tipoItemCodigo == 'PR' &&
                surveyItem.tipoComponente != 'INPUT'
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _list,
      ),
    );
  }

  Widget _widgetAlternative(SurveyItem surveyItem, SurveyItem parent) {
    return Text(surveyItem.titulo.toString(),
        style: GoogleFonts.montserrat(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ColorsApp.primary));
  }

  void _getSurveyCovidDetail() async {
    setState(() {
      loading = true;
    });
    final _surveyService = SurveyService();
    Map<String, String> params = {
      'id_encuesta': widget.idEncuesta,
      'id_persona': widget.idPerson,
      'id_entidad': widget.idEntidad,
      'fecha': widget.fecha
    };
    final _apiResponse = await _surveyService.getQuizAnswerCovidDetail(params);
    if (_apiResponse.success) {
      _survey = Survey.fromJson(_apiResponse.data);
      _surveyItems = _survey.items ?? [];
    }
    setState(() {
      loading = false;
    });
  }
}
