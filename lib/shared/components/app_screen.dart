import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/menu.dart';
import 'package:lamb_talent/resources/services/general/worker_service.dart';
import 'package:lamb_talent/shared/components/search_delegate.dart';
import 'package:lamb_talent/ui/modules/account_status/account_status_page.dart';
import 'package:lamb_talent/ui/modules/home/home_page.dart';
import 'package:lamb_talent/ui/modules/survey/survey_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'change_entity.dart';
import 'custom_footer_loading.dart';

class AppScreen extends StatelessWidget {
  final Widget child;
  final int initialIndex;
  final RefreshController? refreshController;
  final Function()? onRefresh;
  final Function()? onLoading;
  final ScrollController scrollController;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool showTabs;
  final bool principalPage;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final bool showTitleHeader;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final userPreferences = UserPreferences();
  AppScreen(
      {this.initialIndex = 0,
      required this.child,
      this.refreshController,
      this.onRefresh,
      this.onLoading,
      required this.scrollController,
      this.enablePullDown = false,
      this.enablePullUp = false,
      this.showTabs = false,
      this.principalPage = false,
      this.showTitleHeader = true,
      this.floatingActionButton,
      this.bottomSheet,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    List<Menu> menu = userPreferences.menu ?? [];
    int index = 0;
    for (var element in menu) {
      tabs.add(Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: initialIndex == index ? Colors.white : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image.asset(element.icon.toString(),
                    height: 30.0,
                    fit: BoxFit.cover,
                    color: initialIndex == index
                        ? ColorsApp.primary
                        : Colors.white),
                Text(element.title.toString())
              ]),
        ),
      ));
      index++;
    }
    String fullname = '';
    if (userPreferences.fullnamePerson != null) {
      if (!userPreferences.isWorkerChild) {
        final split = userPreferences.fullnamePerson.toString().split(' ');
        fullname = split[0] + '!';
      } else {
        fullname = userPreferences.fullnamePerson.toString();
      }
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorsApp.primary, ColorsApp.primaryVariant],
        ),
      ),
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: tabs.length,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: showTitleHeader ? 80.0 : null,
            title: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                      top: 5,
                      left: 0,
                      child: userPreferences.cantEntities > 1 ||
                              userPreferences.cantDeptos > 1
                          ? InkWell(
                              onTap: () {
                                showModalChangeEntity(context);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                          userPreferences.nameEntity != null
                                              ? userPreferences.nameEntity
                                                  .toString()
                                              : '',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0)),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down, size: 30)
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  userPreferences.nameEntity != null
                                      ? userPreferences.nameEntity.toString()
                                      : '',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0)),
                            )),
                  Center(
                      child: Column(
                    children: [
                      Image.asset('assets/icons/logo.png',
                          height: 40.0, fit: BoxFit.cover),
                      showTitleHeader
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  !userPreferences.isWorkerChild
                                      ? DateTime.now().hour > 12
                                          ? const Text('Buenas tardes, ',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400))
                                          : Text('Buenos días, ',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400))
                                      : Container(),
                                  Text(fullname,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  )),
                  Positioned(
                      top: -10,
                      right: 0,
                      child: Row(
                        children: [
                          userPreferences.searchPerson
                              ? IconButton(
                                  onPressed: () {
                                    _searchWorker(context);
                                  },
                                  icon: const Icon(Icons.person_search))
                              : Container(),
                          !userPreferences.isWorkerChild
                              ? IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, 'login');
                                  },
                                  icon: const Icon(Icons.logout))
                              : IconButton(
                                  onPressed: () {
                                    _backToHome();
                                  },
                                  icon: const Icon(Icons.home)),
                        ],
                      )),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          body: !principalPage
              ? Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SmartRefresher(
                          enablePullDown: enablePullDown,
                          enablePullUp: enablePullUp,
                          controller: refreshController != null
                              ? refreshController!
                              : _refreshController,
                          onRefresh: enablePullDown ? onRefresh : null,
                          onLoading: enablePullUp ? onLoading : null,
                          scrollDirection: Axis.vertical,
                          header: const WaterDropMaterialHeader(),
                          footer: const CustomFooterLoading(),
                          scrollController: scrollController,
                          physics: const ScrollPhysics(),
                          child: SingleChildScrollView(child: child));
                    }),
                  ),
                )
              : SmartRefresher(
                  enablePullDown: enablePullDown,
                  enablePullUp: enablePullUp,
                  controller: refreshController != null
                      ? refreshController!
                      : _refreshController,
                  onRefresh: enablePullDown ? onRefresh : null,
                  onLoading: enablePullUp ? onLoading : null,
                  scrollDirection: Axis.vertical,
                  header: const WaterDropMaterialHeader(),
                  footer: const CustomFooterLoading(),
                  scrollController: scrollController,
                  physics: const ScrollPhysics(),
                  child: SingleChildScrollView(child: child)),
          bottomNavigationBar: showTabs
              ? TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: ColorsApp.primary,
                  onTap: (val) {
                    if (val == 0) {
                      Get.offAll(() => HomePage(),
                          transition: Transition.size,
                          duration: const Duration(seconds: 1));
                    } else if (val == 1) {
                      Get.offAll(() => AccountStatusPage(),
                          transition: Transition.size,
                          duration: const Duration(seconds: 1));
                    } else if (val == 2) {
                      Get.offAll(() => SurveyPage(),
                          transition: Transition.size,
                          duration: const Duration(seconds: 1));
                    }
                  },
                  labelPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  tabs: tabs,
                )
              : null,
          bottomSheet: bottomSheet,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }

  void _searchWorker(BuildContext buildContext) async {
    final searchResult = await showSearch(
      context: buildContext,
      delegate: SearchDelgateCustom(
          listData: (query) async {
            dynamic listPersons = [];
            Map<String, String> params = {
              'id_entidad': userPreferences.idEntity.toString(),
              // 'id_depto': userPreferences.idDeparment.toString(),
              'id_acceso_nivel': userPreferences.idNivelAcceso.isNotEmpty
                  ? userPreferences.idNivelAcceso.toString()
                  : '',
              'search_option': userPreferences.searchOption.toString(),
              'restringido': 'S',
              'per_page': '15',
              'page': '1',
              'search': query.toString()
            };
            final _workerService = WorkerService();
            final list = await _workerService.getMyWorkers(params);
            listPersons = list.data;
            return listPersons;
          },
          fieldLabel: 'Buscar trabajador',
          nameTitle: 'nombreapellido',
          nameSubTitle: 'num_documento',
          nameImg: 'foto_url'),
      //query: 'Hola'
    );
    if (searchResult != null) {
      userPreferences.isWorkerChild = true;

      userPreferences.idWorker = int.parse(searchResult['id_trabajador'] != null
          ? searchResult['id_trabajador'].toString()
          : '-1');
      userPreferences.nroDocument = searchResult['num_documento'];
      /* userPreferences.idEntity =
          int.parse(searchResult['id_entidad'].toString());
      userPreferences.idDeparment = searchResult['id_depto'].toString(); */
      userPreferences.idPerson =
          int.parse(searchResult['id_persona'].toString());
      userPreferences.fullnamePerson = searchResult['nombreapellido'].toString();
      Get.forceAppUpdate();
    }
  }

  void _backToHome() {
    userPreferences.isWorkerChild = false;
    userPreferences.idEntity = userPreferences.idEntityFather;
    userPreferences.idDeparment = userPreferences.idDeparmentFathher;
    userPreferences.idPerson = userPreferences.idPersonFather;
    userPreferences.nroDocument = userPreferences.nroDocumentFather;
    userPreferences.idWorker = userPreferences.idWorkerFather;
    userPreferences.fullnamePerson = userPreferences.fullnamePersonFather;
    Get.forceAppUpdate();
  }
}
