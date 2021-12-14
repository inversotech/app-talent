import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/core/colors.dart';

class CarouselSliderItem extends StatelessWidget {
  final BoxConstraints constraints;
  final Function() onPressedList;
  final Function()? onPressedRequest;
  final Function()? onPressedNotify;
  final String title;
  final List<dynamic>? detail;
  final int indexItem;
  final int itemCount;
  final int cantidadAprobar;
  final List<Widget> textButton;
  final bool showButtonRequest;
  const CarouselSliderItem(
      {Key? key,
      required this.title,
      this.detail,
      required this.constraints,
      required this.onPressedList,
      required this.indexItem,
      required this.itemCount,
      required this.cantidadAprobar,
      required this.textButton,
      this.onPressedRequest,
      this.onPressedNotify,
      this.showButtonRequest = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.only(bottom: 0, top: 4.0, left: 4.0, right: 4.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: 115,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))),
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
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
                      const SizedBox(height: 8.0),
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 25.0,
                            color: ColorsApp.primary),
                      ),
                      const SizedBox(height: 8.0),
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
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25.0)),
                      color: Colors.white),
                ),
              ],
            ),
          ),
          // este comentario es si desea que se de click en la tarjeta
          /* TextButton(
            onPressed: () {
              onPressedList();
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith<EdgeInsets>(
              (Set<MaterialState> states) {
                return const EdgeInsets.all(0); // Use the component's default.
              },
            )), */
          cantidadAprobar > 0
              ? Positioned(
                  left: 5,
                  top: 8,
                  child: IconButton(
                    onPressed: () {
                      onPressedNotify!();
                    },
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications, size: 30),
                        Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: ColorsApp.danger,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                cantidadAprobar.toString(),
                                style:  GoogleFonts.montserrat(
                                  color: ColorsApp.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              : Container(),
          Positioned(
            right: 5,
            top: 4,
            child: IconButton(
              onPressed: () {
                onPressedList();
              },
              icon: const Icon(Icons.format_list_numbered, size: 30),
            ),
          ),
          showButtonRequest
              ? Positioned(
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
                )
              : Container(),
        ],
      ),
    );
  }
}
