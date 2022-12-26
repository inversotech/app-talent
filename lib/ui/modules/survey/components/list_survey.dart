import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';

class ListSurvey extends StatelessWidget {
  final List<Survey> listData;
  final BoxConstraints constraints;
  final void Function(Survey) onPressed;
  final void Function() onChangeList;
  const ListSurvey(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.onPressed,
      required this.onChangeList})
      : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    if (listData.isNotEmpty) {
      return Stack(
        children: [
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              primary: false,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    onPressed(listData[index]);
                    /*   _showModalDetail(
                        buildContext,
                        listData[index].idSolicJustif.toString(),
                        listData[index].idEstadoJustif.toString()); */
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        listData[index].aprobado == '1'
                                            ? ColorsApp.success
                                            : ColorsApp.danger,
                                    child: Text((index + 1).toString(),
                                        style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                            fontSize: 22.0)),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10.0),
                                        Text(
                                          capitalize(listData[index]
                                              .nombre
                                              .toString()),
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsApp.primary,
                                              fontSize: 16.0),
                                        ),
                                        Text(
                                            'Fecha: ${DateFormat('dd|MM|yyyy').format(listData[index].fecha!)}',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /* listData[index].idEstadoJustif == '01'
                                ? TextButton(
                                    onPressed: () {
                                      onPressed(listData[index]);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: ColorsApp.primary,
                                        ),
                                        Text(
                                          'editar',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w300,
                                              color: ColorsApp.primary,
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  )
                                : Container() */
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1, color: ColorsApp.primary);
              },
              itemCount: listData.length),
        ],
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
