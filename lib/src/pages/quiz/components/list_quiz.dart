import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart'
    show ApiResponse, JustificationModel, MarkingWorkerModel, ProcessJustifcationModel, Survey;
import 'package:intl/intl.dart';
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/providers/utils/functions/capitalize.dart';
import 'package:upn_financiero_mobil/src/services/justification/index.dart';
import 'package:upn_financiero_mobil/src/shared/components/visor_pdf_img.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/widgets.dart';

class ListQuiz extends StatelessWidget {
  final List<Survey> listData;
  final BoxConstraints constraints;
  final bool loading;
  final void Function(Survey) onPressed;
  final void Function() onChangeList;
  ListQuiz(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.loading,
      required this.onPressed,
      required this.onChangeList})
      : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    if (listData.isNotEmpty) {
      return Stack(
        children: [
          ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              primary: false,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                  /*   _showModalDetail(
                        buildContext,
                        listData[index].idSolicJustif.toString(),
                        listData[index].idEstadoJustif.toString()); */
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 2.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10.0),
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
                                            'Fecha: ' +
                                                DateFormat('dd|MM|yyyy').format(
                                                        listData[index]
                                                            .fecha!),
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
                return Divider(height: 1, color: ColorsApp.primary);
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
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }
}


