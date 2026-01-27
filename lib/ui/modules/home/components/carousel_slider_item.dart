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
  final List<Widget>? detailWidget;
  final bool isDetailWidget;
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
      this.detailWidget,
      this.onPressedRequest,
      this.onPressedNotify,
      this.showButtonRequest = true,
      this.isDetailWidget = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Top row with buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Notification Badge Button
              if (cantidadAprobar > 0)
                IconButton.filledTonal(
                  onPressed: onPressedNotify,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    foregroundColor: Colors.white,
                  ),
                  icon: Badge(
                    label: Text(
                      cantidadAprobar.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: ColorsApp.danger,
                    child: const Icon(Icons.notifications_outlined, size: 24),
                  ),
                )
              else
                const SizedBox(width: 48),

              // List Button
              IconButton.filledTonal(
                onPressed: onPressedList,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.format_list_numbered_rounded, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // Detail Content
          if (isDetailWidget && detailWidget != null)
            ...detailWidget!
          else if (detail != null && detail!.isNotEmpty)
            ...List<Widget>.generate(detail!.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        detail![index]['cantidad'].toString().padLeft(2, '0'),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${detail![index]['nombre']} hasta ',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      'hoy',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 16),

          // Request Button
          if (showButtonRequest)
            FilledButton(
              onPressed: onPressedRequest,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: ColorsApp.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: textButton,
              ),
            ),
        ],
      ),
    );
  }
}
