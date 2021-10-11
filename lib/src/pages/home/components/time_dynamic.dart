import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';

class MarkingWidget extends StatefulWidget {
  final Function() onPressed;
  final String hourMarking;
  final int minutosTolerancia;
  final String descripcionMarcacion;
  const MarkingWidget(
      {Key? key,
      required this.onPressed,
      required this.hourMarking,
      required this.minutosTolerancia,
      required this.descripcionMarcacion})
      : super(key: key);

  @override
  State<MarkingWidget> createState() => _MarkingWidgetState();
}

class _MarkingWidgetState extends State<MarkingWidget> {
  String text = Jiffy().format('hh:mm:ss a');
  String title = '¡Felicitaciones!';
  String subtitle = 'Estas a tiempo para marcar tu asistencia de';
  Timer? timer;
  Color colorButton = ColorsApp.success;
  @override
  void initState() {
    super.initState();
    _timeInterval();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        color: ColorsApp.info,
        child: Column(
          children: [
            Text(title,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500, color: ColorsApp.primary)),
            SizedBox(height: 4.0),
            Text(
              subtitle +
                  ' ' +
                  (widget.descripcionMarcacion.isNotEmpty
                      ? widget.descripcionMarcacion.toLowerCase()
                      : ''),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Text(text.toLowerCase(),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: colorButton,
                    fontSize: 22.0)),
            _buttonAssistanceMarking(context),
          ],
        ),
      ),
    );
  }

  Container _buttonAssistanceMarking(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.primary; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10)); // Use the component's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_box_outlined, color: Colors.white),
              Text(
                'marcar asistencia',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, color: Colors.white),
              ),
            ],
          ),
          onPressed: () {
            widget.onPressed();
          },
        ));
  }

  void _timeInterval() {
    DateTime timeMarking = DateTime.parse(widget.hourMarking);
    DateTime timeNow =
        DateTime.parse(Jiffy().format('yyyy-MM-dd HH:mm').toString());
    DateTime timeTolerancia =
        timeMarking.add(Duration(minutes: widget.minutosTolerancia));
    if (timeTolerancia.isBefore(timeNow) && timeNow.isAfter(timeMarking)) {
      if (timeNow.isAfter(timeTolerancia)) {
        title = '¡Atención!';
        subtitle = 'Falta marcar tu asistencia de ';
        colorButton = ColorsApp.danger;
      } else {
        title = '¡Apresúrate!';
        subtitle =
            'Estás en el tiempo de telerancia para marcar tu asistencia de';
        colorButton = ColorsApp.warning;
      }
    }
    setState(() {});
    timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      text = Jiffy().format('hh:mm:ss a');
      DateTime timeMarking = DateTime.parse(widget.hourMarking);
      DateTime timeNow =
          DateTime.parse(Jiffy().format('yyyy-MM-dd HH:mm').toString());
      DateTime timeTolerancia =
          timeMarking.add(Duration(minutes: widget.minutosTolerancia));
      if (timeTolerancia.isBefore(timeNow) && timeNow.isAfter(timeMarking)) {
        if (timeNow.isAfter(timeTolerancia)) {
          title = '¡Atención!';
          subtitle = 'Falta marcar tu asistencia de';
          colorButton = ColorsApp.danger;
        } else {
          title = '¡Apresúrate!';
          subtitle =
              'Estás en el tiempo de telerancia para marcar tu asistencia de ';
          colorButton = ColorsApp.warning;
        }
      }
      setState(() {});
    });
  }
}
