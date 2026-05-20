import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/shared/components/app_text.dart';

class Detail extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
  final List listData;
  final String? title;
  final bool isModal;
  Detail({super.key, required this.listData, this.title, this.isModal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          title != null
              ? Container(
                  alignment: Alignment.centerRight,
                  child: AppText.body(
                    title!,
                    color: ColorsApp.primary,
                  ),
                )
              : const SizedBox.shrink(),
          title != null
              ? const SizedBox(height: Spacing.sm)
              : const SizedBox.shrink(),
          AppText.h2('Detalle'),
          const SizedBox(height: Spacing.sm),
          Stack(
            children: [
              listData.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      primary: false,
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        final Map item = listData[index] as Map;
                        final List items = item['items'] as List;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              !isModal
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: AppText.body(
                                            item.containsKey('title')
                                                ? item['title'].toString()
                                                : '',
                                            color: ColorsApp.primary,
                                          ),
                                        ),
                                        AppText.h2(
                                          format
                                              .format(double.parse(item
                                                      .containsKey('total')
                                                  ? item['total'].toString()
                                                  : '0'))
                                              .toString(),
                                          color: ColorsApp.primary,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        AppText.body(
                                          item.containsKey('title')
                                              ? item['title'].toString()
                                              : '',
                                          color: ColorsApp.primary,
                                        ),
                                        const SizedBox(height: Spacing.xs),
                                        AppText.bodyLarge(
                                          format
                                              .format(double.parse(item
                                                      .containsKey('total')
                                                  ? item['total'].toString()
                                                  : '0'))
                                              .toString(),
                                          color: ColorsApp.primary,
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: Spacing.md),
                              items.isNotEmpty
                                  ? ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      primary: false,
                                      itemCount: items.length,
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                            height: 1,
                                            color: ColorsApp.neutral300,
                                            thickness: 1);
                                      },
                                      itemBuilder: (context, index) {
                                        final Map dataItem = items[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Spacing.sm),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 16,
                                                      backgroundColor:
                                                          ColorsApp.primary,
                                                      child: AppText.bodyLarge(
                                                        (index + 1).toString(),
                                                        color: ColorsApp.white,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: Spacing.xs),
                                                    Flexible(
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            top: Spacing.xs),
                                                        child: AppText.body(
                                                          dataItem.containsKey(
                                                                  'comentario')
                                                              ? capitalize(dataItem[
                                                                      'comentario']
                                                                  .toString())
                                                              : '',
                                                          color:
                                                              ColorsApp.primary,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: Spacing.sm),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  AppText.bodyLarge(
                                                    format
                                                        .format(double.parse(
                                                            dataItem.containsKey(
                                                                    'valor')
                                                                ? dataItem[
                                                                        'valor']
                                                                    .toString()
                                                                : '0'))
                                                        .toString(),
                                                    color: ColorsApp.primary,
                                                  ),
                                                  AppText.labelSmall(
                                                    dataItem.containsKey(
                                                            'fecha')
                                                        ? Jiffy.parse(
                                                                dataItem['fecha']
                                                                    .toString(),
                                                                pattern:
                                                                    'dd/MM/yyyy')
                                                            .format(
                                                                pattern:
                                                                    'dd|MM|yyyy')
                                                        : '',
                                                    color: ColorsApp.primary,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : Padding(
                                      padding:
                                          const EdgeInsets.all(Spacing.xs),
                                      child: Center(
                                        child: AppText.body(
                                          'No se encontró información para mostrar.',
                                          color: ColorsApp.primary,
                                        ),
                                      ),
                                    )
                            ]);
                      })
                  : Padding(
                      padding: const EdgeInsets.all(Spacing.xs),
                      child: Center(
                        child: AppText.body(
                          'No se encontró información para mostrar.',
                          color: ColorsApp.primary,
                        ),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
