import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/quiz/quiz.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

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
                    padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
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
                                    child: AppText.h2((index + 1).toString(),
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: Spacing.sm),
                                        AppText.h3(
                                          capitalize(listData[index]
                                              .nombre
                                              .toString()),
                                          color: ColorsApp.primary,
                                        ),
                                        AppText.label(
                                            'Fecha: ${DateFormat('dd|MM|yyyy').format(listData[index].fecha!)}',
                                            color: ColorsApp.primary),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /* Código comentado - botón de edición */
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
        padding: const EdgeInsets.all(Spacing.sm),
        child: Center(
          child: AppText.body('No se encontró información para mostrar.',
              color: ColorsApp.primary),
        ),
      );
    }
  }
}
