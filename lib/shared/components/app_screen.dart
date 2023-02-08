import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/menu.dart';
import 'package:lamb_talent/resources/services/general/worker_service.dart';
import 'package:lamb_talent/shared/components/search_delegate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'change_entity.dart';
import 'custom_footer_loading.dart';

class AppScreen extends StatelessWidget {
  final Widget child;
  final String codePage;
  final RefreshController? refreshController;
  final Function()? onRefresh;
  final Function()? onLoading;
  final ScrollController scrollController;
  final bool enablePullDown;
  final bool enablePullUp;
  final bool showTabs;
  final bool principalPage;
  final bool showSearchPerson;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final bool showTitleHeader;
  final double leftBeforeBackground;
  final double rightBeforeBackground;
  final double bottomBeforeBackground;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Color colorLoading;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final Color backgroundColor;

  final userPreferences = UserPreferences();
  AppScreen(
      {required this.codePage,
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
      this.showSearchPerson = true,
      this.floatingActionButton,
      this.bottomSheet,
      this.leftBeforeBackground = 4,
      this.rightBeforeBackground = 4,
      this.bottomBeforeBackground = 4,
      this.paddingLeft = 12,
      this.paddingRight = 12,
      this.paddingTop = 8,
      this.paddingBottom = 8,
      this.backgroundColor = ColorsApp.white,
      this.colorLoading = ColorsApp.primary,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    int initialIndex = 0;
    List<Widget> tabs = [];
    List<Menu> menu = userPreferences.menu ?? [];
    int index = 0;
    for (var element in menu) {
      if (codePage == element.code) {
        initialIndex = index;
      }
      tabs.add(Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color:
                codePage == element.code ? Colors.white : Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: element.code == '16120104' && userPreferences.cantNotify > 0
              ? Stack(
                  children: [
                    Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(element.icon.toString(),
                              height: 30.0,
                              fit: BoxFit.cover,
                              color: codePage == element.code
                                  ? ColorsApp.primary
                                  : Colors.white),
                          Text(element.title.toString())
                        ]),
                    Positioned(
                        top: 0.0,
                        left: 0.0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: ColorsApp.danger,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            userPreferences.cantNotify.toString(),
                            style: GoogleFonts.montserrat(
                                color: ColorsApp.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ))
                  ],
                )
              : Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                      Image.asset(element.icon.toString(),
                          height: 30.0,
                          fit: BoxFit.cover,
                          color: codePage == element.code
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
        fullname = '${split[0]}!';
      } else {
        fullname = userPreferences.fullnamePerson.toString();
      }
    }
    return Scaffold(
      body: Container(
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
                                                    fontWeight:
                                                        FontWeight.w400))
                                            : Text('Buenos días, ',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400))
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
                            userPreferences.searchPerson && showSearchPerson
                                ? IconButton(
                                    onPressed: () {
                                      _searchWorker(context);
                                    },
                                    icon: const Icon(Icons.person_search))
                                : Container(),
                            !userPreferences.isWorkerChild
                                ? IconButton(
                                    onPressed: () {
                                      // storage.remove('saveCredLamb');
                                      // storage.remove('usernameLamb');
                                      storage.remove('passwordLamb');
                                      storage.remove('tokenLamb');
                                     String tokenNotify = userPreferences.tokenNotify;
                                      userPreferences.clear();
                                      userPreferences.tokenNotify=tokenNotify;
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
                ? Container(
                    padding: EdgeInsets.only(
                        left: leftBeforeBackground,
                        right: rightBeforeBackground,
                        top: 0,
                        bottom: bottomBeforeBackground),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                          color: backgroundColor,
                          padding: EdgeInsets.only(
                              left: paddingLeft,
                              right: paddingRight,
                              top: 0,
                              bottom: paddingBottom),
                          child: SmartRefresher(
                              enablePullDown: enablePullDown,
                              enablePullUp: enablePullUp,
                              controller: refreshController != null
                                  ? refreshController!
                                  : _refreshController,
                              onRefresh: enablePullDown ? onRefresh : null,
                              onLoading: enablePullUp ? onLoading : null,
                              scrollDirection: Axis.vertical,
                              header: const WaterDropMaterialHeader(),
                              footer: CustomFooterLoading(
                                  colorLoading: colorLoading),
                              scrollController: scrollController,
                              physics: const ScrollPhysics(),
                              child: SingleChildScrollView(
                                  child: Padding(
                                padding: EdgeInsets.only(top: paddingTop),
                                child: child,
                              )))),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SmartRefresher(
                        enablePullDown: enablePullDown,
                        enablePullUp: enablePullUp,
                        controller: refreshController != null
                            ? refreshController!
                            : _refreshController,
                        onRefresh: enablePullDown ? onRefresh : null,
                        onLoading: enablePullUp ? onLoading : null,
                        scrollDirection: Axis.vertical,
                        header: const WaterDropMaterialHeader(),
                        footer: CustomFooterLoading(colorLoading: colorLoading),
                        scrollController: scrollController,
                        physics: const ScrollPhysics(),
                        child: SingleChildScrollView(child: child)),
                  ),
            bottomNavigationBar: showTabs
                ? TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: ColorsApp.primary,
                    onTap: (val) {
                      if (initialIndex != val) {
                        if (val == 0) {
                          Get.offAllNamed(
                              userPreferences.menu![0].url.toString());
                        } else if (val == 1) {
                          Get.offAllNamed(
                              userPreferences.menu![1].url.toString());
                        } else if (val == 2) {
                          Get.offAllNamed(
                              userPreferences.menu![2].url.toString());
                        } else if (val == 3) {
                          Get.offAllNamed(
                              userPreferences.menu![3].url.toString());
                        }
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
            final workerService = WorkerService();
            final list = await workerService.getMyWorkers(params);
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
      userPreferences.fullnamePerson =
          searchResult['nombreapellido'].toString();
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
    // reset data father
    userPreferences.idEntityFather = 0;
    userPreferences.idDeparmentFathher = '';
    userPreferences.idPersonFather = 0;
    userPreferences.nroDocumentFather = '';
    userPreferences.idWorkerFather = 0;
    userPreferences.fullnamePersonFather = '';
    Get.forceAppUpdate();
  }
}
