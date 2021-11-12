import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/general/menu.dart';
import 'package:upn_financiero_mobil/src/pages/account_status/account_status_page.dart';
import 'package:upn_financiero_mobil/src/pages/home/home_page.dart';
import 'package:upn_financiero_mobil/src/pages/quiz/quiz_page.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/shared/components/change_entity.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart';

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
    UserPreferences userPreferences = UserPreferences();
    List<Widget> tabs = [];
    List<Menu> menu = userPreferences.menu ?? [];
    int index = 0;
    menu.forEach((element) {
      tabs.add(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
    });
    String fullname = '';
    if (userPreferences.fullnamePerson != null) {
      final split = userPreferences.fullnamePerson.toString().split(' ');
      fullname = split[0];
    }
    return Container(
      decoration: BoxDecoration(
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
            toolbarHeight: showTitleHeader ? 90.0 : null,
            title: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset('assets/icons/logo.png',
                          height: 40.0, fit: BoxFit.cover),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
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
                                      child: Text(
                                          userPreferences.nameEntity != null
                                              ? userPreferences.nameEntity
                                                  .toString()
                                              : '',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0)),
                                    ),
                                    Icon(Icons.arrow_drop_down, size: 30)
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    userPreferences.nameEntity != null
                                        ? capitalize(userPreferences.nameDeparment
                                            .toString())
                                        : '',
                                        overflow: TextOverflow.fade,
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0)),
                              ),
                              showTitleHeader
                                  ? Wrap(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        DateTime.now().hour > 12
                                            ? Text('Buenas tardes, ',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w400))
                                            : Text('Buenos días, ',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                        Text(fullname + '!',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'login');
                          },
                          icon: Icon(Icons.logout)),
                    ],
                  ),
                  SizedBox(height: 12)
                ],
              ),
            ),
          ),
          body: !principalPage
              ? Card(
                  shape: RoundedRectangleBorder(
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
                          header: WaterDropMaterialHeader(),
                          footer: CustomFooterLoading(),
                          scrollController: scrollController,
                          physics: ScrollPhysics(),
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
                  header: WaterDropMaterialHeader(),
                  footer: CustomFooterLoading(),
                  scrollController: scrollController,
                  physics: ScrollPhysics(),
                  child: SingleChildScrollView(child: child)),
          bottomNavigationBar: showTabs
              ? TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: ColorsApp.primary,
                  onTap: (val) {
                    if (val == 0) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else if (val == 1) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountStatusPage()));
                    } else if (val == 2) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => QuizPage()));
                    }
                  },
                  labelPadding: EdgeInsets.symmetric(vertical: 8.0),
                  tabs: tabs,
                )
              : null,
          bottomSheet: bottomSheet != null ? bottomSheet : null,
          floatingActionButton:
              floatingActionButton != null ? floatingActionButton : null,
        ),
      ),
    );
  }
}
