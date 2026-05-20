import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/general/person_service.dart';
import 'package:lamb_talent/resources/services/holiday/holiday_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';

Future<bool> showModalSSign(
    HolidayModel holiday, String type, BuildContext buildContext) async {
  UserPreferences userPreferences = UserPreferences();
  PersonService personService = PersonService();
  Map<String, String> params = {
    'id_persona': userPreferences.idPerson.toString(),
  };
  final sign = await showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.neutral200,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            title: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Image.asset('assets/icons/close.png',
                      height: 40, width: 40, color: ColorsApp.primary),
                  onPressed: () => Get.back()
                  // Navigator.of(context).pop()
                  ),
            ),
            contentPadding: const EdgeInsets.all(8.0),
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
                const SizedBox(height: 8.0),
                Text(userPreferences.fullnamePerson.toString(),
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: ColorsApp.primary,
                        fontSize: 14.0)),
                const SizedBox(height: 12.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                            'Fecha: ${Jiffy.parse(holiday.fechaIni!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')} - ${Jiffy.parse(holiday.fechaFin!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')}',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300,
                                color: ColorsApp.primary,
                                fontSize: 12.0)),
                      ),
                      Text(
                        'Duración: ${holiday.dias} días',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: ColorsApp.primary,
                            fontSize: 12.0),
                      ),
                    ]),
                const SizedBox(height: 12.0),
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: ColorsApp.danger,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          Get.back();
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Firmar',
                              style: TextStyle(
                                  color: ColorsApp.success,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () async {
                          HolidayService holidayService = HolidayService();
                          Map<String, String> params = {
                            'confirmacion': '1',
                            'type': type,
                            'dias_efect': holiday.dias.toString()
                          };

                          loadingIndicator(onlyLoading: true, opacity: false);
                          final resp = await holidayService.signHoliday(
                              params, holiday.idRolVacacion.toString());
                          Get.until((route) => !Get.isDialogOpen!);
                          if (resp.success) {
                            // Get.back<bool>(result: true);
                            // ignore: use_build_context_synchronously
                            Navigator.pop<bool>(context, true);
                          }
                        },
                      ),
                    ]),
                const Divider(height: 1, color: ColorsApp.primary),
                const SizedBox(height: 12.0),
                Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: personService.getSign(params),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final Map data = snapshot.data as Map;

                        try {
                          return data.containsKey('file')
                              ? Image.memory(base64Decode(data['file']))
                              : const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/img/image-default.png'),
                                );
                        } catch (e) {
                          return Column(
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/img/image-default.png'),
                              ),
                              Container(
                                alignment: Alignment.center,
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
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Cerrar',
                          style: TextStyle(
                              color: ColorsApp.primary,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              ],
            ));
      });

  /* await showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: ColorsApp.neutral200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          title: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Image.asset('assets/icons/close.png',
                    height: 40, width: 40, color: ColorsApp.primary),
                onPressed: () => Navigator.of(context).pop()),
          ),
          contentPadding: const EdgeInsets.all(8.0),
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
              const SizedBox(height: 8.0),
              Text(userPreferences.fullnamePerson.toString(),
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      color: ColorsApp.primary,
                      fontSize: 14.0)),
              const SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                          'Fecha: ${Jiffy.parse(holiday.fechaIni!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')} - ${Jiffy.parse(holiday.fechaFin!, pattern: 'yyyy-MM-dd').format(pattern: 'dd|MM|yyyy')}',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300,
                              color: ColorsApp.primary,
                              fontSize: 12.0)),
                    ),
                    Text(
                      'Duración: ${holiday.dias} días',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300,
                          color: ColorsApp.primary,
                          fontSize: 12.0),
                    ),
                  ]),
              const SizedBox(height: 12.0),
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Cancelar',
                            style: TextStyle(
                                color: ColorsApp.danger,
                                fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () {
                        Get.back();
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Firmar',
                            style: TextStyle(
                                color: ColorsApp.success,
                                fontWeight: FontWeight.bold)),
                      ),
                      onPressed: () async {
                        HolidayService holidayService = HolidayService();
                        Map<String, String> params = {
                          'confirmacion': '1',
                          'type': type,
                          'dias_efect': holiday.dias.toString()
                        };

                        final resp = await holidayService.signHoliday(
                            params, holiday.idRolVacacion.toString());

                        if (resp.success) {
                          Navigator.pop<bool>(context, true);

                          //Get.back<bool>(result: true);
                        }
                      },
                    ),
                  ]),
              const Divider(height: 1, color: ColorsApp.primary),
              const SizedBox(height: 12.0),
              Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: personService.getSign(params),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final Map data = snapshot.data as Map;

                      try {
                        return data.containsKey('file')
                            ? Image.memory(base64Decode(data['file']))
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/img/image-default.png'),
                              );
                      } catch (e) {
                        return Column(
                          children: [
                            const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/image-default.png'),
                            ),
                            Container(
                              alignment: Alignment.center,
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
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Cerrar',
                        style: TextStyle(
                            color: ColorsApp.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              )
            ],
          ),
        );
      }); */
  if (sign != null) {
    return true;
  } else {
    return false;
  }
}
