import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart' show HolidayModel;
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';

class ListHoliday extends StatelessWidget {
  final List<HolidayModel> listData;
  final BoxConstraints constraints;
  final bool loading;
  const ListHoliday(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.loading})
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
                final data = listData[index];
                return TextButton(
                  onPressed: () async {
                    
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: Text((index + 1).toString(),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 22.0)),
                              backgroundColor: ColorsApp.info,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.0),
                                  Text(
                                    capitalize(data.nombrePeriodo.toString()),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsApp.primary,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                      'Fecha: ' +
                                          Jiffy(data.fechaIni, 'dd/MM/yyyy')
                                              .format('dd|MM|yyyy') +
                                          ' - ' +
                                          Jiffy(data.fechaFin, 'dd/MM/yyyy')
                                              .format('dd|MM|yyyy'),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          color: ColorsApp.primary,
                                          fontSize: 12.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 40.0),
                                  Text(
                                    data.estadoTrab.toString(),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                        color: data.idEstadoVacTrab == '01'
                                            ? ColorsApp.primary
                                            : data.idEstadoVacTrab == '02'
                                                ? ColorsApp.success
                                                : data.idEstadoVacTrab == '03'
                                                    ? ColorsApp.warning
                                                    : Colors.black),
                                  ),
                                ],
                              ),
                              Text(
                                'Duración: ' + data.dias.toString() + ' días',
                                style: GoogleFonts.montserratAlternates(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.primary,
                                    fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 1, color: ColorsApp.primary,thickness: 0.8,);
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
          ],
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
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }
}
