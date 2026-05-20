import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';
import 'package:lamb_talent/resources/services/account_status/account_status_service.dart';
import 'package:lamb_talent/shared/components/app_card.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

import 'detail.dart';

class DepositedHelpTravel extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
  final String title;
  final dynamic data;
  final Function(bool) onChange;
  final DateModel dateModel;
  final String code;
  DepositedHelpTravel({
    super.key,
    required this.title,
    required this.data,
    required this.onChange,
    required this.dateModel,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final Map dataMap = data != null ? data as Map : {};

    return AppCard(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3(title),
          const SizedBox(height: Spacing.md),
          // Card interna — filas informadas/adelanto
          AppCard.neutral(
            padding: const EdgeInsets.all(Spacing.md),
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
                const SizedBox(height: Spacing.sm),
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
                const Divider(height: 24, color: ColorsApp.neutral200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.bodySmall(
                      (double.parse(dataMap.containsKey('sub_total')
                                  ? dataMap['sub_total'].toString()
                                  : '0')) >
                              0
                          ? 'Depositado'
                          : 'Descontado',
                      color: ColorsApp.neutral500,
                    ),
                    AppText.h3(
                      format
                          .format(double.parse(
                              dataMap.containsKey('sub_total')
                                  ? dataMap['sub_total'].toString()
                                  : '0'))
                          .toString(),
                      color: ColorsApp.neutral800,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // Card saldo final con fondo primary
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: ColorsApp.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.body(
                  'Saldo final',
                  color: ColorsApp.primary,
                ),
                AppText.h3(
                  format
                      .format(double.parse(dataMap.containsKey('total')
                          ? dataMap['total'].toString()
                          : '0'))
                      .toString(),
                  color: ColorsApp.primary,
                ),
              ],
            ),
          ),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.bodySmall(label, color: ColorsApp.neutral500),
        Row(
          children: [
            AppText.body(value, color: ColorsApp.neutral800),
            const SizedBox(width: Spacing.sm),
            IconButton.filled(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: ColorsApp.white,
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
    _showModalDetail(detail);
  }

  void _showModalDetail(List data) async {
    await Get.dialog(
        barrierDismissible: true,
        AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.neutral200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg)),
            contentPadding: const EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.zero,
            scrollable: false,
            content: SizedBox(
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.highlight_off)),
                    ),
                    Detail(listData: data, isModal: true),
                  ],
                ),
              ),
            )));
  }
}
