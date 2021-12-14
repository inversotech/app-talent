import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';
import 'package:lamb_talent/resources/services/account_status/account_status_service.dart';

import 'detail.dart';


class DepositedSalary extends StatelessWidget {
  final dynamic data;
  final Function(bool) onChange;
  final DateModel dateModel;
  const DepositedSalary(
      {Key? key,
      required this.data,
      required this.dateModel,
      required this.onChange})
      : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    final dataMap = data != null ? data as Map : {};
    return Column(
      children: [
        CreateCardItem(
          title: 'Ingresos',
          amount: dataMap.containsKey('l_ingresos')
              ? dataMap['l_ingresos'].toString()
              : '0',
          color: ColorsApp.success,
          onPressed: () {
            onChange(true);
            _getItemsIncome(buildContext);
          },
          icon: const Icon(Icons.equalizer),
        ),
        const SizedBox(height: 4.0),
        CreateCardItem(
          title: 'Descuentos',
          amount: dataMap.containsKey('l_descuentos_total')
              ? dataMap['l_descuentos_total'].toString()
              : '0',
          color: ColorsApp.warning,
          onPressed: () {
            onChange(true);
            _getItemsDiscount(buildContext);
          },
          icon: const Icon(Icons.bar_chart),
        )
      ],
    );
  }

  void _getItemsIncome(BuildContext buildContext) async {
    final _accountStatusService =  AccountStatusService();
    final _userPreferences =  UserPreferences();
    final Map<String, String> params = {
      'id_entidad': _userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': _userPreferences.idPerson.toString()
    };
    final resp = await _accountStatusService.getIncomes(params);
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
    _showModalDetail(buildContext, detail);
  }

  void _getItemsDiscount(BuildContext buildContext) async {
    final _accountStatusService = AccountStatusService();
    final _userPreferences = UserPreferences();
    final Map<String, String> params = {
      'id_entidad': _userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_cta_cte': _userPreferences.nroDocument.toString(),
      'id_persona': _userPreferences.idPerson.toString()
    };
    final resp = await _accountStatusService.getDiscounts(params);
    List detail = [];
    Map data = {};
    if (resp != null) {
      data = resp as Map;
      if (data.containsKey('discounts') && data.containsKey('advancements')) {
        detail.add({
          'title': 'Total descuento',
          'total': data['discounts']['total'],
          'items': data['discounts']['items']
        });
        detail.add({
          'title': 'Total adelanto',
          'total': data['advancements']['total'],
          'items': data['advancements']['items']
        });
      } else {
        detail.add({'title': 'Total descuento', 'total': '0', 'items': []});
        detail.add({'title': 'Total adelanto', 'total': '0', 'items': []});
      }
    }
    onChange(false);
    _showModalDetail(buildContext, detail);
  }

  void _showModalDetail(BuildContext buildContext, List data) async {
    await showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              elevation: 0,
              backgroundColor: ColorsApp.info,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              contentPadding: const EdgeInsets.all(0.0),
              titlePadding: EdgeInsets.zero,
              scrollable: false,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child:  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.highlight_off)),
                      ),
                      Detail(listData: data, isModal: true),
                    ],
                  ),
                ),
              ));
        });
  }
}

class CreateCardItem extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ');
  final String title;
  final String amount;
  final Color color;
  final Widget icon;
  final Function() onPressed;
  CreateCardItem(
      {Key? key,
      required this.title,
      required this.amount,
      required this.color,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  height: 25.0,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(25.0)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18.0, bottom: 16.0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      icon,
                      Text(title,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              color: ColorsApp.primary)),
                      const SizedBox(height: 8.0),
                      Text(format.format(double.parse(amount)).toString(),
                          style: GoogleFonts.montserratAlternates(
                              fontWeight: FontWeight.w400,
                              color: ColorsApp.primary,
                              fontSize: 18.0)),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 0,
              right: 12,
              child: InkWell(
                onTap: () {
                  onPressed();
                },
                child: Container(
                  width: 150,
                  height: 35,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/search.png',
                  height: 30, width: 30, color: Colors.white),
                      Text('Ver detalle',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12.0))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
