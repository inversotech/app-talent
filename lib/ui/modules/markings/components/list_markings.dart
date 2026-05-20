import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

class ListMarking extends StatelessWidget {
  final List<MarkingModel> listData;
  final BoxConstraints constraints;
  final void Function(MarkingModel) onPressed;
  const ListMarking(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            final item = listData[index];

            return Column(
              children: [
                const SizedBox(
                  height: Spacing.sm,
                ),
                _createItemMarking(
                    item.fecha!,
                    item.horaEntradaReal != null
                        ? item.horaEntradaReal.toString()
                        : '',
                    _getColorEnt(item)),
                const SizedBox(
                  height: Spacing.xs,
                ),
                const Divider(
                    height: 1, color: ColorsApp.primary, thickness: 1),
                const SizedBox(
                  height: Spacing.xs,
                ),
                item.horaBaseSalRef != null && item.horaBaseEntRef != null
                    ? Column(
                        children: [
                          _createItemMarking(
                              item.fecha!,
                              item.horaSalidaRefReal != null
                                  ? item.horaSalidaRefReal.toString()
                                  : '',
                              _getColorSalRef(item)),
                          const SizedBox(
                            height: 6,
                          ),
                          const Divider(
                              height: 1,
                              color: ColorsApp.primary,
                              thickness: 1),
                          const SizedBox(
                            height: 6,
                          ),
                          _createItemMarking(
                              item.fecha!,
                              item.horaEntradaRefReal != null
                                  ? item.horaEntradaRefReal.toString()
                                  : '',
                              _getColorEntRef(item)),
                          const SizedBox(
                            height: 6,
                          ),
                          const Divider(
                              height: 1,
                              color: ColorsApp.primary,
                              thickness: 1),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      )
                    : Container(),
                _createItemMarking(
                    item.fecha!,
                    item.horaSalidaReal != null
                        ? item.horaSalidaReal.toString()
                        : '',
                    _getColorSal(item)),
                const SizedBox(
                  height: Spacing.sm,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
                height: 1, color: ColorsApp.primary, thickness: 2);
          },
          itemCount: listData.length);
    } else {
      return Padding(
        padding: const EdgeInsets.all(Spacing.sm),
        child: Center(
          child: AppText.body('No se encontró información para mostrar.',
              color: ColorsApp.primary),
        ),
      );
    }
  }

  Color _getColorEnt(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaBaseEnt == null) {
      color = ColorsApp.neutral200;
    } else if (item.horaEntJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarEnt.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarEnt.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSalRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = Colors.white;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSalRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorEntRef(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaEntRefJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaEntradaRefReal == null &&
        item.horaBaseSalRef != null &&
        item.horaBaseEntRef != null) {
      color = ColorsApp.danger;
    } else if (item.horaBaseSalRef == null && item.horaBaseEntRef == null) {
      color = Colors.white;
    } else if (double.parse(item.numMinutosTarRef.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarRef.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Color _getColorSal(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaSalJust == '1') {
      color = ColorsApp.primary;
    } else if (item.horaSalidaReal == null) {
      color = ColorsApp.danger;
    } else if (double.parse(item.numMinutosTarSal.toString()) > 0) {
      color = ColorsApp.warning;
    } else if (double.parse(item.numMinutosTarSal.toString()) == 0) {
      color = ColorsApp.success;
    } else {
      color = ColorsApp.danger;
    }
    return color;
  }

  Padding _createItemMarking(DateTime fecha, String horaMarking, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: AppText.h2(
                    Jiffy.parseFromDateTime(fecha).format(pattern: 'dd'),
                    color: Colors.white),
              ),
              const SizedBox(width: Spacing.md),
              AppText.bodyLarge(
                '${capitalize(DateFormat.MMMM('es').format(fecha))}, ${Jiffy.parseFromDateTime(fecha).format(pattern: 'yyyy')}',
                color: ColorsApp.primary,
              )
            ],
          ),
          AppText.bodyLarge(
            horaMarking.isNotEmpty
                ? DateFormat('hh:mm a').format(DateTime.parse(
                    '${DateFormat('y-MM-dd').format(DateTime.now())} $horaMarking'))
                : '      ---     ',
            color: ColorsApp.primary,
          ),
        ],
      ),
    );
  }
}
