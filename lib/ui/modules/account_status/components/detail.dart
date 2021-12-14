import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';

class Detail extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ');
  final List listData;
  final String? title;
  final bool isModal;
  Detail({Key? key, required this.listData, this.title, this.isModal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: ColorsApp.info,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            title != null
                ? Container(
                    alignment: Alignment.centerRight,
                    child: Text(title!,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            color: ColorsApp.primary)),
                  )
                : Container(),
            title != null ? const SizedBox(height: 12.0) : Container(),
            Text('Detalle',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.primary,
                    fontSize: 18.0)),
                    const SizedBox(height: 8.0),
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
                                            child: Text(
                                                item.containsKey('title')
                                                    ? item['title'].toString()
                                                    : '',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorsApp.primary,
                                                    fontSize: 14.0)),
                                          ),
                                          Text(
                                              format
                                                  .format(double.parse(item
                                                          .containsKey('total')
                                                      ? item['total'].toString()
                                                      : '0'))
                                                  .toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsApp.primary,
                                                  fontSize: 18.0)),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              item.containsKey('title')
                                                  ? item['title'].toString()
                                                  : '',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsApp.primary,
                                                  fontSize: 14.0)),
                                          const SizedBox(height: 4.0),
                                          Text(
                                              format
                                                  .format(double.parse(item
                                                          .containsKey('total')
                                                      ? item['total'].toString()
                                                      : '0'))
                                                  .toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorsApp.primary,
                                                  fontSize: 16.0)),
                                        ],
                                      ),
                                const SizedBox(height: 16.0),
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
                                              color: ColorsApp.primary,thickness: 1);
                                        },
                                        itemBuilder: (context, index) {
                                          final Map dataItem = items[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0,top: 8.0),
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
                                                        child: Text(
                                                            (index + 1).toString(),
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16.0)),
                                                        backgroundColor:
                                                            ColorsApp.primary,
                                                      ),
                                                      const SizedBox(width: 4.0),
                                                      Flexible(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 4.0),
                                                          child: Text(
                                                              dataItem.containsKey(
                                                                      'comentario')
                                                                  ? capitalize(dataItem[
                                                                          'comentario']
                                                                      .toString())
                                                                  : '',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                    fontSize: 14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: ColorsApp
                                                                          .primary)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6.0),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        format
                                                            .format(double.parse(
                                                                dataItem.containsKey(
                                                                        'valor')
                                                                    ? dataItem[
                                                                            'valor']
                                                                        .toString()
                                                                    : '0'))
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.montserrat(
                                                              fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                color: ColorsApp
                                                                    .primary)),
                                                    Text(
                                                        dataItem.containsKey(
                                                                'fecha')
                                                            ? Jiffy(
                                                                    dataItem[
                                                                            'fecha']
                                                                        .toString(),
                                                                    'dd/MM/yyyy')
                                                                .format(
                                                                    'dd|MM|yyyy')
                                                            : '',
                                                        style:
                                                            GoogleFonts.montserrat(
                                                                fontWeight:
                                                                    FontWeight.w500,
                                                                color: ColorsApp
                                                                    .primary,
                                                                fontSize: 10.0))
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        })
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                          child: Text(
                                              'No se encontró información para mostrar.',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorsApp.primary)),
                                        ),
                                      )
                              ]);
                        })
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text('No se encontró información para mostrar.',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary)),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
