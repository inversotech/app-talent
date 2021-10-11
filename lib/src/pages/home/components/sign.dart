import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart' show HolidayModel;
import 'package:upn_financiero_mobil/src/providers/user_preferences/user_preferences.dart';
import 'package:upn_financiero_mobil/src/services/general/person_service.dart';
import 'package:upn_financiero_mobil/src/services/holiday/holiday_service.dart';

Future<bool> showModalSSign(
    BuildContext context, HolidayModel holiday, String type) async {
  UserPreferences userPreferences = UserPreferences();
  PersonService personService = PersonService();
  Map<String, String> params = {
    'id_persona': userPreferences.idPerson.toString(),
  };
  final sign = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.info,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop()),
          ),
          contentPadding: EdgeInsets.all(8.0),
          titlePadding: EdgeInsets.zero,
          scrollable: true,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  type == 'S'
                      ? 'Firmar salida a vacaciones'
                      : 'Firmar retorno de vacaciones',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      color: ColorsApp.primary,
                      fontSize: 18.0)),
              SizedBox(height: 8.0),
              Text(userPreferences.fullnamePerson.toString(),
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      color: ColorsApp.primary,
                      fontSize: 14.0)),
              SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                          'Fecha: ' +
                              Jiffy(holiday.fechaIni, 'dd/MM/yyyy')
                                  .format('dd|MM|yyyy') +
                              ' - ' +
                              Jiffy(holiday.fechaFin, 'dd/MM/yyyy')
                                  .format('dd|MM|yyyy'),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              color: ColorsApp.primary,
                              fontSize: 12.0)),
                    ),
                    Text(
                      'Duración: ' + holiday.dias.toString() + ' días',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300,
                          color: ColorsApp.primary,
                          fontSize: 12.0),
                    ),
                  ]),
              SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        shape: MaterialStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                          (Set<MaterialState> states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25)); // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Cancelar',
                            style: TextStyle(
                                color: ColorsApp.danger,
                                fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        shape: MaterialStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                          (Set<MaterialState> states) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25)); // Use the component's default.
                          },
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Firmar',
                            style: TextStyle(
                                color: ColorsApp.success,
                                fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () async {
                        HolidayService holidayService = new HolidayService();
                        Map<String, String> params = {
                          'confirmacion': '1',
                          'type': type,
                          'dias_efect': holiday.dias.toString()
                        };
                        final resp = await holidayService.signHoliday(
                            params, holiday.idRolVacacion.toString());
                        if (resp.success) {
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ]),
              Divider(height: 1, color: ColorsApp.primary),
              SizedBox(height: 12.0),
              FutureBuilder(
                future: personService.getSign(params),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final Map data = snapshot.data as Map;

                    try {
                      return data.containsKey('file')
                          ? Image.memory(base64Decode(data['file']))
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/image-default.png'),
                            );
                    } catch (e) {
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/image-default.png'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                                child: Text('No tiene una firma digital',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary,
                                        fontSize: 16.0))),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.resolveWith<
                        RoundedRectangleBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25)); // Use the component's default.
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: ColorsApp.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      });

  if (sign != null) {
    return true;
  } else {
    return false;
  }
}
