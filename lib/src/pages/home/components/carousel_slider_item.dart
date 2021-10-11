import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';

class CarouselSliderItem extends StatelessWidget {
  final BoxConstraints constraints;
  final Function() onPressedList;
  final Function()? onPressedRequest;
  final String title;
  final List<dynamic>? detail;
  final int indexItem;
  final int itemCount;
  final List<Widget> textButton;
  CarouselSliderItem(
      {Key? key,
      required this.title,
      this.detail,
      required this.constraints,
      required this.onPressedList,
      required this.indexItem,
      required this.itemCount,
      required this.textButton,
      this.onPressedRequest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 0, top: 4.0, left: 4.0, right: 4.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: 115,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))),
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(itemCount, (index) {
                          return Icon(
                            Icons.circle_rounded,
                            size: 10,
                            color: index == indexItem
                                ? Colors.black
                                : Colors.black12,
                          );
                        }),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.0,
                            color: ColorsApp.primary),
                      ),
                      SizedBox(height: 8.0),
                      Column(
                          children: List<Widget>.generate(
                              detail != null ? detail!.length : 0, (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              detail![index]['cantidad']
                                      .toString()
                                      .padLeft(2, '0') +
                                  ' ',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                  color: ColorsApp.primary),
                            ),
                            Text(
                              detail![index]['nombre'].toString() + ' hasta ',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: ColorsApp.primary),
                            ),
                            Text(
                              'hoy',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: ColorsApp.primary),
                            ),
                          ],
                        );
                      })),
                    ],
                  ),
                ),
                Container(
                  height: 25.0,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25.0)),
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
                onTap: () {
                  onPressedList();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/icons/search.png',
                      height: 35, width: 35, color: ColorsApp.primary),
                )),
          ),
          Positioned(
            bottom: 15,
            right: 0,
            left: 0,
            child: InkWell(
              onTap: onPressedRequest != null
                  ? () {
                      onPressedRequest!();
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorsApp.success,
                      borderRadius: BorderRadius.circular(25)),
                  child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: textButton,
                    ),
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
