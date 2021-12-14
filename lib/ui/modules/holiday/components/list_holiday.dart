import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/holiday/holiday.dart';

class ListHoliday extends StatelessWidget {
  final List<HolidayModel> listData;
  final BoxConstraints constraints;
  const ListHoliday(
      {Key? key,
      required this.listData,
      required this.constraints})
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
                final data = listData[index];
                return TextButton(
                  onPressed: () async {
                    
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4.0),
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
                                  const SizedBox(width: 40.0),
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
                return const Divider(height: 1, color: ColorsApp.primary,thickness: 0.8,);
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
}
