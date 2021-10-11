import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart' show MarkingModel;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';

class ListMarking extends StatelessWidget {
  final List<MarkingModel> listData;
  final BoxConstraints constraints;
  final bool loading;
  final void Function(MarkingModel) onPressed;
  ListMarking(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.loading,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listData.isNotEmpty) {
      return Stack(
        children: [
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              primary: false,
              itemBuilder: (context, index) {
                final item = listData[index];

                return Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    _createItemMarking(
                        item.fecha!,
                        item.horaEntradaReal != null
                            ? item.horaEntradaReal.toString()
                            : '',
                        _getColorEnt(item)),
                    SizedBox(
                      height: 6,
                    ),
                    Divider(height: 1, color: ColorsApp.primary,thickness: 1),
                    SizedBox(
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
                              SizedBox(
                                height: 6,
                              ),
                              Divider(height: 1, color: ColorsApp.primary,thickness: 1),
                              SizedBox(
                                height: 6,
                              ),
                              _createItemMarking(
                                  item.fecha!,
                                  item.horaEntradaRefReal != null
                                      ? item.horaEntradaRefReal.toString()
                                      : '',
                                  _getColorEntRef(item)),
                              SizedBox(
                                height: 6,
                              ),
                              Divider(height: 1, color: ColorsApp.primary,thickness: 1),
                              SizedBox(
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
                    SizedBox(
                      height: 8,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: ColorsApp.primary,thickness: 2);
              },
              itemCount: listData.length),
          if (loading) ...[
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                top: 0.0,
                child: Container(
                  width: constraints.maxWidth,
                  child: Center(child: CircularProgressIndicator()),
                ))
          ]
        ],
      );
    } else if (loading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No se encontró información para mostrar.',style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: ColorsApp.primary)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                child: Text(Jiffy(fecha, 'dd/MM/yyyy').format('dd'),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400, color: Colors.white,fontSize: 18.0)),
                backgroundColor: color,
              ),
              SizedBox(width: 12.0),
              Text(
                capitalize(DateFormat.MMMM('es').format(fecha)) +
                    ', ' +
                    Jiffy(fecha, 'dd/MM/yyyy').format('yy'),
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
                    DateFormat('y-MM-dd').format(DateTime.now()) +
                        ' ' +
                        horaMarking.toString()))
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
