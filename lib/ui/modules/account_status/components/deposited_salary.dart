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

class DepositedSalary extends StatelessWidget {
  final dynamic data;
  final Function(bool) onChange;
  final DateModel dateModel;
  const DepositedSalary({
    super.key,
    required this.data,
    required this.dateModel,
    required this.onChange,
  });

  @override
  Widget build(BuildContext buildContext) {
    final dataMap = data != null ? data as Map : {};
    final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');

    return AppCard.neutral(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        children: [
          _buildRow(
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
          const Divider(height: 24, color: ColorsApp.neutral200),
          _buildRow(
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
    );
  }

  Widget _buildRow({
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
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: buttonColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: buttonColor, size: 20),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodySmall(label, color: ColorsApp.neutral500),
              AppText.bodyLarge(
                format.format(double.parse(amount)).toString(),
                color: ColorsApp.neutral800,
              ),
            ],
          ),
        ),
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

class CreateCardItem extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
  final String title;
  final String amount;
  final Color color;
  final Widget icon;
  final Function() onPressed;
  CreateCardItem({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
      child: AppCard.neutral(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: color, size: 20),
                    child: icon,
                  ),
                ),
                // Botón "Ver detalle" con color personalizado
                Material(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: InkWell(
                    onTap: onPressed,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.sm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search,
                              size: 16, color: ColorsApp.white),
                          const SizedBox(width: Spacing.xs),
                          AppText.label(
                            'Ver detalle',
                            color: ColorsApp.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            AppText.bodySmall(title, color: ColorsApp.neutral500),
            const SizedBox(height: Spacing.xs),
            AppText.h1(
              format.format(double.parse(amount)).toString(),
              color: ColorsApp.neutral800,
            ),
          ],
        ),
      ),
    );
  }
}
