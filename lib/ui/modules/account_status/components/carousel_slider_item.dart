import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/resources/models/general/date_model.dart';

class CarouselSliderItem extends StatelessWidget {
  final format = NumberFormat.currency(symbol: 'S/. ', locale: 'en_US');
  final String title;
  final String? titleContinue;
  final String amount;
  final Function() onPressed;
  final Function() onPressedDate;
  final int indexItem;
  final int itemCount;
  final DateModel dateModel;
  final bool showBoleta;
  CarouselSliderItem(
      {Key? key,
      required this.title,
      this.titleContinue = '',
      required this.amount,
      required this.onPressed,
      required this.onPressedDate,
      required this.indexItem,
      required this.itemCount,
      required this.dateModel,
      this.showBoleta = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _widgetFilters(context),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/icons/money.png',
                                height: 40,
                                width: 40,
                                color: ColorsApp.primary),
                            Text(title,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: ColorsApp.primary,
                                    fontSize: 20.0)),
                            Text(titleContinue ?? '',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w400,
                                    color: ColorsApp.primary,
                                    fontSize: 20.0)),
                          ],
                        ),
                        showBoleta
                            ? InkWell(
                                onTap: () {
                                  onPressed();
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/icons/pdf.png',
                                          height: 25,
                                          width: 25,
                                          color: ColorsApp.primary),
                                      Text('Ver boleta',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsApp.primary,
                                              fontSize: 14.0))
                                    ]),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(format.format(double.parse(amount)).toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            color: ColorsApp.primary,
                            fontSize: 40.0))
                  ]),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(itemCount, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Icon(
                Icons.circle_rounded,
                size: 10,
                color: index == indexItem ? Colors.white : Colors.white30,
              ),
            );
          }),
        ),
      ],
    );
  }

  Container _widgetFilters(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.primary, width: 1.8),
            borderRadius: BorderRadius.circular(25.0)),
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  onPressedDate();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/icons/calendar.png',
                              height: 30, width: 30, color: ColorsApp.primary),
                          const SizedBox(width: 8.0),
                          Text(
                              dateModel.nameMonth +
                                  ', ' +
                                  dateModel.year.toString(),
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  color: ColorsApp.primary))
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
