import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/models/general/date_model.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/account_status/account_status_service.dart';

import 'detail.dart';

class DepositedHelpTravel extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ');
  final String title;
  final dynamic data;
  final Function(bool) onChange;
  final DateModel dateModel;
  final String code;
  DepositedHelpTravel(
      {Key? key,
      required this.title,
      required this.data,
      required this.onChange,
      required this.dateModel,
      required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map dataMap = data != null ? data as Map : {};
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      color: ColorsApp.info,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0)),
            SizedBox(height: 8.0),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text('Informadas',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                        ),
                        Row(
                          children: [
                            Text(
                                format
                                    .format(double.parse(
                                        dataMap.containsKey('ingresos')
                                            ? dataMap['ingresos'].toString()
                                            : '0'))
                                    .toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.primary)),
                            IconButton(
                                onPressed: () {
                                  onChange(true);
                                  _getItemsIncome(context);
                                },
                                icon: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorsApp.warning,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Image.asset(
                                    'assets/icons/search.png',
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text('Adelanto',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                        ),
                        Row(
                          children: [
                            Text(
                                format
                                    .format(double.parse(
                                        dataMap.containsKey('descuentos')
                                            ? dataMap['descuentos'].toString()
                                            : '0'))
                                    .toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.primary)),
                            IconButton(
                                onPressed: () {
                                  onChange(true);
                                  _getItemsDiscount(context);
                                },
                                icon: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorsApp.success,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Image.asset(
                                    'assets/icons/search.png',
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                              (double.parse(dataMap.containsKey('sub_total')
                                          ? dataMap['sub_total'].toString()
                                          : '0')) >
                                      0
                                  ? 'Depositado'
                                  : 'Descontado',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 45),
                          child: Text(
                              format
                                  .format(double.parse(
                                      dataMap.containsKey('sub_total')
                                          ? dataMap['sub_total'].toString()
                                          : '0'))
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsApp.primary)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text('Saldo final',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsApp.primary)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 45),
                          child: Text(
                              format
                                  .format(double.parse(
                                      dataMap.containsKey('total')
                                          ? dataMap['total'].toString()
                                          : '0'))
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsApp.primary)),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  void _getItemsIncome(BuildContext context) async {
    AccountStatusService _accountStatusService = new AccountStatusService();
    UserPreferences _userPreferences = new UserPreferences();
    final Map<String, String> params = {
      'id_entidad': _userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': _userPreferences.idPerson.toString(),
      'id_cta_cte': _userPreferences.nroDocument.toString()
    };
    var resp;
    if (code == 'help') {
      resp = await _accountStatusService.getHelpsIncomes(params);
    } else if (code == 'travel') {
      resp = await _accountStatusService.getTravelsIncomes(params);
    }
    List detail = [];
    Map data = {};
    if (resp != null) {
      data = resp as Map;
      if (data.containsKey('total') && data.containsKey('items')) {
        detail.add({
          'title': 'Total ingresos',
          'total': data['total'],
          'items': data['items']
        });
      } else {
        detail.add({'title': 'Total ingresos', 'total': '0', 'items': []});
      }
    }
    onChange(false);
    _showModalDetail(context, detail);
  }

  void _getItemsDiscount(BuildContext context) async {
    AccountStatusService _accountStatusService = new AccountStatusService();
    UserPreferences _userPreferences = new UserPreferences();
    final Map<String, String> params = {
      'id_entidad': _userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': _userPreferences.idPerson.toString(),
      'id_cta_cte': _userPreferences.nroDocument.toString()
    };
    var resp;
    if (code == 'help') {
      resp = await _accountStatusService.getHelpsDiscounts(params);
    } else if (code == 'travel') {
      resp = await _accountStatusService.getTravelsDiscounts(params);
    }
    List detail = [];
    Map data = {};
    if (resp != null) {
      data = resp as Map;
      if (data.containsKey('total') && data.containsKey('items')) {
        detail.add({
          'title': 'Total adelanto',
          'total': data['total'],
          'items': data['items']
        });
      } else {
        detail.add({'title': 'Total adelanto', 'total': '0', 'items': []});
      }
    }
    onChange(false);
    _showModalDetail(context, detail);
  }

  void _showModalDetail(BuildContext context, List data) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              elevation: 0,
              backgroundColor: ColorsApp.info,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              contentPadding: EdgeInsets.all(0.0),
              titlePadding: EdgeInsets.zero,
              scrollable: false,
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.highlight_off)),
                      ),
                      Detail(listData: data, isModal: true),
                    ],
                  ),
                ),
              ));
        });
  }
}
