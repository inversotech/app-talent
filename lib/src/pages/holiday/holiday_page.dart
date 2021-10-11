import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/pages/holiday/components.dart/list_holiday.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart'
    show AppScreen, ShowLoadingIndicator;

class HolidayPage extends StatefulWidget {
  const HolidayPage({Key? key}) : super(key: key);

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserPreferences userPreferences = UserPreferences();
  HolidayService holidayService = HolidayService();
  int _selectYear = DateTime.now().year;
  bool loading = false;
  List<HolidayModel> listData = [];

  int totalPro = 0;
  int totalGo = 0;
  @override
  void initState() {
    super.initState();
    getListDataInitial();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
        refreshController: _refreshController,
        scrollController: _scrollController,
        enablePullDown: false,
        enablePullUp: false,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              SizedBox(height: 8.0),
              AppBar(
                centerTitle: true,
                leading: Transform.translate(
                  offset: Offset(-15, -8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconSize: 40,
                    icon: Icon(Icons.chevron_left, color: ColorsApp.primary),
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 40.0,
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Vacaciones',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.0,
                        fontWeight: FontWeight.w700, color: ColorsApp.primary),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                width: 140,
                decoration: BoxDecoration(
                    color: ColorsApp.primary,
                    border: Border.all(color: ColorsApp.primary),
                    borderRadius: BorderRadius.circular(25.0)),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                    onTap: () {
                      _selectYearPicker(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/calendar.png',
                              height: 30, width: 30, color: Colors.white),
                          SizedBox(width: 8.0),
                          Text(
                            _selectYear.toString(),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.white)
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 12.0),
              Container(
                  child: Column(
                children: [
                  ListHoliday(
                      constraints: constraints,
                      listData: listData,
                      loading: loading),
                  listData.length > 0
                      ? Padding(
                        padding: const EdgeInsets.only(left:40.0),
                        child: Column(
                            children: [
                              SizedBox(height: 8.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total días programados',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary),
                                      ),
                                      Text(
                                        totalPro.toString(),
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary),
                                      )
                                    ]),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total días gozados',
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary),
                                      ),
                                      Text(
                                        totalGo.toString(),
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            color: ColorsApp.primary),
                                      )
                                    ]),
                              )
                            ],
                          ),
                      )
                      : Container(),
                ],
              )),
            ],
          );
        }));
  }

  void _selectYearPicker(BuildContext buildContext) async {
    final dialog = await showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleccionar año"),
          content: Container(
            // Need to use container to add size constraint.
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              // save the selected date to _selectedDate DateTime variable.
              // It's used to set the previous selected date when
              // re-showing the dialog.
              selectedDate: DateTime(_selectYear, 1, 1),
              onChanged: (DateTime dateTime) {
                // close the dialog when year is selected.
                Navigator.of(context).pop(dateTime);

                // Do something with the dateTime selected.
                // Remember that you need to use dateTime.year to get the year
              },
            ),
          ),
        );
      },
    );
    if (dialog != null) {
      _selectYear = dialog.year;
      setState(() {});
      getListData(buildContext);
    }
  }

  void getListData(BuildContext buildContext) async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_anho': _selectYear.toString()
    };
    ShowLoadingIndicator.showLoadingIndicator(
        context: buildContext, onlyLoading: true, opacity: false);
    listData = await holidayService.getHolidays(params);
    totalPro = 0;
    totalGo = 0;
    listData.forEach((element) {
      totalPro = totalPro + int.parse(element.dias.toString());
      totalGo = totalGo + int.parse(element.diasEfect.toString());
    });
    Navigator.pop(buildContext);
  }

  void getListDataInitial() async {
    final Map<String, String> params = {
      'id_trabajador': userPreferences.idWorker != null
          ? userPreferences.idWorker.toString()
          : '',
      'id_anho': _selectYear.toString()
    };

    setState(() {
      loading = true;
    });
    listData = await holidayService.getHolidays(params);
    totalPro = 0;
    totalGo = 0;
    listData.forEach((element) {
      totalPro = totalPro + int.parse(element.dias.toString());
      totalGo = totalGo + int.parse(element.diasEfect.toString());
    });
    setState(() {
      loading = false;
    });
  }
}
