import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/survey/survey_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/resources/models/general/person.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';
import 'package:lamb_talent/resources/services/general/worker_service.dart';
import 'package:lamb_talent/shared/components/app_screen.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/search_delegate.dart';

import 'components/list_survey.dart';

class SurveyPage extends StatelessWidget {
  SurveyPage({Key? key}) : super(key: key);
  final controller = Get.put(SurveyController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(
        init: SurveyController(),
        didUpdateWidget: (_, stateBuilder) {
          stateBuilder.controller!.onInit();
        },
        builder: (_) {
          return Obx(() => controller.loadingDataInit.value
              ? AppScreen(
                  codePage: '16120103',
                  refreshController: controller.refreshController,
                  scrollController: controller.scrollController,
                  enablePullDown: true,
                  enablePullUp: true,
                  showTabs: true,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  floatingActionButton: controller.actions
                              .where((element) =>
                                  element.clave.toString().toUpperCase() ==
                                  'ADD')
                              .isNotEmpty &&
                          !controller.preferences.isWorkerChild
                      ? Material(
                          color: ColorsApp.success,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          child: InkWell(
                            onTap: () async {
                              controller
                                  .goToFormSurvey(controller.idPerson.value);
                            },
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.lg,
                                  vertical: Spacing.sm),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.activeButtonAddQuiz.value
                                      ? const Icon(Icons.person,
                                          color: ColorsApp.white)
                                      : const Icon(Icons.person_add,
                                          color: ColorsApp.white),
                                  const SizedBox(width: Spacing.sm),
                                  Text(
                                    controller.activeButtonAddQuiz.value
                                        ? 'Realizar encuesta'
                                        : 'Encuestar nueva persona',
                                    style: const TextStyle(
                                        color: ColorsApp.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : null,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Column(
                      children: [
                        const SizedBox(height: Spacing.sm),
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
                                                  final workerService =
                                                      WorkerService();
                                                  final list =
                                                      await workerService
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
                                              'id': searchResult["id_persona"]
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
                                            color: ColorsApp.primary, size: 25),
                                      ),
                                    ),
                                  )
                                ]
                              : null,
                          elevation: 0,
                          backgroundColor: ColorsApp.white,
                          toolbarHeight: 40.0,
                          title: Padding(
                            padding:
                                const EdgeInsets.only(left: Spacing.sm),
                            child: AppText.h1(
                              'Auto reporte diario',
                              color: ColorsApp.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.xl / 2),
                        _widgetFilters(context),
                        const SizedBox(height: Spacing.sm),
                        _widgetBody(constraints, context)
                      ],
                    );
                  }),
                )
              : Container());
        });
  }

  Container _widgetFilters(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  controller.selectDate();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Spacing.sm, horizontal: Spacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(children: [Text('')]),
                      Row(
                        children: [
                          AppText.label(
                              '${controller.dateModel.value.nameMonth}, ${controller.dateModel.value.year}',
                              color: ColorsApp.primary),
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
                  label: AppText.label(controller.personSelect.name,
                      color: ColorsApp.primary),
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
