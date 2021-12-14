import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/survey/survey_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/general/person.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';
import 'package:lamb_talent/resources/services/general/worker_service.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/search_delegate.dart';

import 'components/list_survey.dart';

class SurveyPage extends StatelessWidget {
  SurveyPage({Key? key}) : super(key: key);
  final controller = Get.put(SurveyController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(
        init: SurveyController(),
        didUpdateWidget: (_, _stateBuilder) {
          _stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return Obx(() => controller.loadingDataInit.value
              ? AppScreen(
                  initialIndex: 2,
                  refreshController: controller.refreshController,
                  scrollController: controller.scrollController,
                  enablePullDown: true,
                  enablePullUp: true,
                  showTabs: true,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        const SizedBox(height: 8.0),
                        AppBar(
                          centerTitle: false,
                          automaticallyImplyLeading: false,
                          actions: controller.actions
                                      .where((element) =>
                                          element.clave
                                              .toString()
                                              .toUpperCase() ==
                                          'SEARCH')
                                      .isNotEmpty &&
                                  !controller.preferences.isWorkerChild
                              ? [
                                  Transform.translate(
                                    offset: const Offset(-15, -8),
                                    child: Tooltip(
                                      message: 'Buscar persona',
                                      child: IconButton(
                                        iconSize: 30,
                                        onPressed: () async {
                                          final searchResult = await showSearch(
                                            context: context,
                                            delegate: SearchDelgateCustom(
                                                listData: (query) async {
                                                  dynamic listPersons = [];
                                                  controller.isSearching.value =
                                                      true;
                                                  Map<String, String> params = {
                                                    'id_entidad': controller
                                                        .preferences.idEntity
                                                        .toString(),
                                                    // 'id_depto': userPreferences.idDeparment.toString(),
                                                    'id_acceso_nivel':
                                                        controller
                                                                .preferences
                                                                .idNivelAcceso
                                                                .isNotEmpty
                                                            ? controller
                                                                .preferences
                                                                .idNivelAcceso
                                                                .toString()
                                                            : '',
                                                    'search_option': 'FREE',
                                                    'restringido': 'N',
                                                    'per_page': '15',
                                                    'page': '1',
                                                    'search': query.toString()
                                                  };
                                                  final _workerService =
                                                      WorkerService();
                                                  final list =
                                                      await _workerService
                                                          .getMyWorkers(params);
                                                  controller.isSearching.value =
                                                      false;
                                                  listPersons = list.data;
                                                  return listPersons;
                                                },
                                                fieldLabel: 'Buscar persona',
                                                nameTitle: 'nombreapellido',
                                                nameSubTitle: 'num_documento',
                                                nameImg: 'foto_url'),
                                            //query: 'Hola'
                                          );
                                          if (searchResult != null) {
                                            controller.idPerson.value =
                                                searchResult['id_persona']
                                                    .toString();
                                            controller.personSelect =
                                                Person.fromJson({
                                              'entity': controller
                                                  .preferences.idEntity
                                                  .toString(),
                                              'doc_number':
                                                  searchResult["num_documento"]
                                                      .toString(),
                                              'foto_url':
                                                  searchResult["foto_url"]
                                                      .toString(),
                                              'id':
                                                  searchResult["id_persona"]
                                                      .toString(),
                                              'name':
                                                  searchResult["nombreapellido"]
                                                      .toString(),
                                            });
                                            controller
                                                .getListDataInitialOtherPerson();
                                          }
                                        },
                                        icon: const Icon(Icons.person_search,
                                            color: ColorsApp.primary,size: 25),
                                      ),
                                    ),
                                  )
                                ]
                              : null,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          toolbarHeight: 40.0,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Auto reporte diario',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _widgetFilters(context),
                        const SizedBox(height: 8.0),
                        _widgetBody(constraints, context)
                      ],
                    );
                  }),
                  floatingActionButton: controller.actions
                              .where((element) =>
                                  element.clave.toString().toUpperCase() ==
                                  'ADD')
                              .isNotEmpty &&
                          !controller.preferences.isWorkerChild
                      ? TextButton(
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
                          onPressed: () async {
                            controller
                                .goToFormSurvey(controller.idPerson.value);
                          },
                          child: SizedBox(
                            width: 200.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.activeButtonAddQuiz.value
                                    ? const Icon(Icons.person,
                                        color: Colors.white)
                                    : const Icon(Icons.person_add,
                                        color: Colors.white),
                                Text(
                                  controller.activeButtonAddQuiz.value
                                      ? 'Realizar encuesta'
                                      : 'Encuestar nueva persona',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ))
                      : null,
                )
              : Container());
        });
  }

  Container _widgetFilters(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  controller.selectDate();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text(''),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              controller.dateModel.value.nameMonth +
                                  ', ' +
                                  controller.dateModel.value.year.toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _widgetBody(BoxConstraints constraints, BuildContext builContext) {
    return SizedBox(
      width: constraints.maxWidth,
      child: Column(
        children: [
          controller.idPerson.value.isNotEmpty
              ? Chip(
                  avatar: CircleAvatar(
                    child: controller.personSelect.fotoUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: controller.personSelect.fotoUrl,
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/user-default.png'),
                            ),
                            errorWidget: (context, url, error) {
                              return const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/img/user-default.png'));
                            },
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                          )
                        : const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/user-default.png'),
                          ),
                  ),
                  label: Text(controller.personSelect.name,
                      style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: ColorsApp.primary)),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    controller.idPerson.value = '';
                    controller.personSelect = Person();
                    controller.listData = [];
                    controller.activeButtonAddQuiz.value = false;
                    controller.getListData();
                  },
                )
              : Container(),
          ListSurvey(
            constraints: constraints,
            listData: controller.listData,
            onPressed: (Survey survey) {
              controller.goToDetail(survey);
            },
            onChangeList: () {
              // getListData(context);
            },
          ),
        ],
      ),
    );
  }
}
