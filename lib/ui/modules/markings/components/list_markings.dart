import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/models.dart';

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
                  height: 8,
                ),
                _createItemMarking(
                    item.fecha!,
                    item.horaEntradaReal != null
                        ? item.horaEntradaReal.toString()
                        : '',
                    _getColorEnt(item)),
                const SizedBox(
                  height: 6,
                ),
                const Divider(
                    height: 1, color: ColorsApp.primary, thickness: 1),
                const SizedBox(
                  height: 6,
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
                  height: 8,
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
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }

  Color _getColorEnt(MarkingModel item) {
    Color color = ColorsApp.success;
    if (item.horaBaseEnt == null) {
      color = ColorsApp.info;
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: Text(Jiffy(fecha, 'dd/MM/yyyy').format('dd'),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 18.0)),
              ),
              const SizedBox(width: 12.0),
              Text(
                '${capitalize(DateFormat.MMMM('es').format(fecha))}, ${Jiffy(fecha, 'dd/MM/yyyy').format('yyyy')}',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    color: ColorsApp.primary,
                    fontSize: 15.0),
              )
            ],
          ),
          Text(
            horaMarking.isNotEmpty
                ? DateFormat('hh:mm a').format(DateTime.parse(
                    '${DateFormat('y-MM-dd').format(DateTime.now())} $horaMarking'))
                : '      ---     ',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                color: ColorsApp.primary,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
