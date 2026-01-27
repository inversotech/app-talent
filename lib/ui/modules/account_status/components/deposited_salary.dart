import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final colorScheme = Theme.of(buildContext).colorScheme;
    final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRow(
              colorScheme: colorScheme,
              format: format,
              label: 'Ingresos',
              amount: dataMap.containsKey('l_ingresos')
                  ? dataMap['l_ingresos'].toString()
                  : '0',
              icon: Icons.trending_up,
              buttonColor: ColorsApp.success,
              onPressed: () {
                onChange(true);
                _getItemsIncome(buildContext);
              },
            ),
            const Divider(height: 24),
            _buildRow(
              colorScheme: colorScheme,
              format: format,
              label: 'Descuentos',
              amount: dataMap.containsKey('l_descuentos_total')
                  ? dataMap['l_descuentos_total'].toString()
                  : '0',
              icon: Icons.trending_down,
              buttonColor: ColorsApp.warning,
              onPressed: () {
                onChange(true);
                _getItemsDiscount(buildContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required ColorScheme colorScheme,
    required NumberFormat format,
    required String label,
    required String amount,
    required IconData icon,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: buttonColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: buttonColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12)),
              const SizedBox(height: 2),
              Text(format.format(double.parse(amount)).toString(),
                  style: GoogleFonts.montserratAlternates(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 16)),
            ],
          ),
        ),
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
    );
  }

  void _getItemsIncome(BuildContext buildContext) async {
    final accountStatusService = AccountStatusService();
    final userPreferences = UserPreferences();
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_persona': userPreferences.idPerson.toString()
    };
    final resp = await accountStatusService.getIncomes(params);
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
    _showModalDetail(detail);
  }

  void _getItemsDiscount(BuildContext buildContext) async {
    final accountStatusService = AccountStatusService();
    final userPreferences = UserPreferences();
    final Map<String, String> params = {
      'id_entidad': userPreferences.idEntity.toString(),
      'id_anho': dateModel.year.toString(),
      'id_mes': dateModel.month.toString(),
      'id_cta_cte': userPreferences.nroDocument.toString(),
      'id_persona': userPreferences.idPerson.toString()
    };
    final resp = await accountStatusService.getDiscounts(params);
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
    _showModalDetail(detail);
  }

  void _showModalDetail(List data) async {
    await Get.dialog(AlertDialog(
        elevation: 0,
        backgroundColor: ColorsApp.info,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        contentPadding: const EdgeInsets.all(0.0),
        titlePadding: EdgeInsets.zero,
        scrollable: false,
        content: SizedBox(
          width: Get.width
          // MediaQuery.of(context).size.width
          ,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () => Get.back()
                      // Navigator.of(context).pop()
                      ,
                      icon: const Icon(Icons.highlight_off)),
                ),
                Detail(listData: data, isModal: true),
              ],
            ),
          ),
        )));
    /* await showDialog(
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

class CreateCardItem extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconTheme(
                      data: IconThemeData(color: color, size: 20),
                      child: icon,
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search, size: 18),
                        const SizedBox(width: 6),
                        Text('Ver detalle',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500, fontSize: 12.0)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text(format.format(double.parse(amount)).toString(),
                  style: GoogleFonts.montserratAlternates(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
}
