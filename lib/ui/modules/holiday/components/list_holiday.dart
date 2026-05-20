import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/resources/models/holiday/holiday.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

class ListHoliday extends StatelessWidget {
  final List<HolidayModel> listData;
  final BoxConstraints constraints;
  const ListHoliday(
      {Key? key, required this.listData, required this.constraints})
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
              onPressed: () async {},
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: ColorsApp.neutral200,
                          child: AppText.h2((index + 1).toString(),
                              color: Colors.white),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: Spacing.xs),
                              AppText.h3(
                                capitalize(data.nombrePeriodo.toString()),
                                color: ColorsApp.primary,
                              ),
                              AppText.label(
                                  'Fecha: ${Jiffy.parse(data.fechaIni!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')} - ${Jiffy.parse(data.fechaFin!, pattern: 'dd/MM/yyyy').format(pattern: 'dd|MM|yyyy')}',
                                  color: ColorsApp.primary),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: Spacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 40.0),
                              AppText.label(
                                data.estadoTrab.toString(),
                                color: data.idEstadoVacTrab == '01'
                                    ? ColorsApp.primary
                                    : data.idEstadoVacTrab == '02'
                                        ? ColorsApp.success
                                        : data.idEstadoVacTrab == '03'
                                            ? ColorsApp.warning
                                            : Colors.black,
                              ),
                            ],
                          ),
                          AppText.label(
                            'Duración: ${data.dias} días',
                            color: ColorsApp.primary,
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
            return const Divider(
              height: 1,
              color: ColorsApp.primary,
              thickness: 0.8,
            );
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
}
