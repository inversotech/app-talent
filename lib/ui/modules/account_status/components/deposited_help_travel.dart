import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';
import 'package:lamb_talent/resources/services/account_status/account_status_service.dart';

import 'detail.dart';

class DepositedHelpTravel extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
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
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: colorScheme.surfaceContainerLowest,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildRowItem(
                      context,
                      label: 'Informadas',
                      value: format
                          .format(double.parse(dataMap.containsKey('ingresos')
                              ? dataMap['ingresos'].toString()
                              : '0'))
                          .toString(),
                      buttonColor: ColorsApp.warning,
                      onPressed: () {
                        onChange(true);
                        _getItemsIncome(context);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildRowItem(
                      context,
                      label: 'Adelanto',
                      value: format
                          .format(double.parse(dataMap.containsKey('descuentos')
                              ? dataMap['descuentos'].toString()
                              : '0'))
                          .toString(),
                      buttonColor: ColorsApp.success,
                      onPressed: () {
                        onChange(true);
                        _getItemsDiscount(context);
                      },
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            (double.parse(dataMap.containsKey('sub_total')
                                        ? dataMap['sub_total'].toString()
                                        : '0')) >
                                    0
                                ? 'Depositado'
                                : 'Descontado',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 13)),
                        Text(
                            format
                                .format(double.parse(
                                    dataMap.containsKey('sub_total')
                                        ? dataMap['sub_total'].toString()
                                        : '0'))
                                .toString(),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Saldo final',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 14)),
                    Text(
                        format
                            .format(double.parse(dataMap.containsKey('total')
                                ? dataMap['total'].toString()
                                : '0'))
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 16)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurfaceVariant,
                fontSize: 13)),
        Row(
          children: [
            Text(value,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.search, size: 18),
            ),
          ],
        )
      ],
    );
  }

  void _getItemsIncome(BuildContext context) async {
    final accountStatusService = AccountStatusService();
    final userPreferences = UserPreferences();
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': userPreferences.idPerson.toString(),
      'id_cta_cte': userPreferences.nroDocument.toString()
    };
    // ignore: prefer_typing_uninitialized_variables
    var resp;
    if (code == 'help') {
      resp = await accountStatusService.getHelpsIncomes(params);
    } else if (code == 'travel') {
      resp = await accountStatusService.getTravelsIncomes(params);
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
    // _showModalDetail(context, detail); // by pedro
    _showModalDetail(detail);
  }

  void _getItemsDiscount(BuildContext context) async {
    final accountStatusService = AccountStatusService();
    final userPreferences = UserPreferences();
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': userPreferences.idPerson.toString(),
      'id_cta_cte': userPreferences.nroDocument.toString()
    };
    // ignore: prefer_typing_uninitialized_variables
    var resp;
    if (code == 'help') {
      resp = await accountStatusService.getHelpsDiscounts(params);
    } else if (code == 'travel') {
      resp = await accountStatusService.getTravelsDiscounts(params);
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
    // _showModalDetail(context, detail);
    _showModalDetail(detail);
  }

  void _showModalDetail(List data) async {
    await Get.dialog(
        barrierDismissible: true,
        AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            contentPadding: const EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.zero,
            scrollable: false,
            content: SizedBox(
              width: Get.width
              //MediaQuery.of(context).size.width
              ,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () => Get.back(),

                          // Navigator.of(context).pop(),
                          icon: const Icon(Icons.highlight_off)),
                    ),
                    Detail(listData: data, isModal: true),
                  ],
                ),
              ),
            )));

    /* await showDialog(
        context: context,
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
                  child: Column(
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
        }); */
  }
}
