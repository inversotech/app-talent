import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/functions/capitalize.dart';
import 'package:lamb_talent/core/user_preferences.dart';
import 'package:lamb_talent/resources/models/justification/justification_group.dart';
import 'package:lamb_talent/resources/models/models.dart';
import 'package:lamb_talent/resources/services/justification/justification_service.dart';
import 'package:lamb_talent/shared/components/loading.dart';
import 'package:lamb_talent/shared/components/visor_pdf_img.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ListJustification extends StatelessWidget {
  final List<JustificationGroup> listData;
  final BoxConstraints constraints;
  final void Function(JustificationModel) onPressed;
  final void Function() onChangeList;
  final bool isJefeArea;
  final bool isDth;
  final bool approve;
  const ListJustification(
      {Key? key,
      required this.listData,
      required this.constraints,
      required this.onPressed,
      required this.onChangeList,
      this.isJefeArea = false,
      this.isDth = false,
      this.approve = false})
      : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext buildContext) {
    if (listData.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          primary: false,
          itemBuilder: (context, index) {
            final itemFather = listData[index];
            List<JustificationModel> children = listData[index].children!;
            return Column(
              children: [
                approve
                    ? Text(itemFather.apellidonombre.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            color: ColorsApp.primary,
                            fontSize: 16.0))
                    : Container(),
                ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    primary: false,
                    itemBuilder: (context, index) {
                      final item = children[index];
                      return TextButton(
                        onPressed: () {
                          _showModalDetail(
                              buildContext,
                              item.idTrabajador.toString(),
                              item.idSolicJustif.toString(),
                              item.idEstadoJustif.toString(),
                              approve);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: ColorsApp.info,
                                          child: Text((index + 1).toString(),
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                  fontSize: 22.0)),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10.0),
                                              Text(
                                                capitalize(
                                                    item.motivo.toString()),
                                                style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorsApp.primary,
                                                    fontSize: 16.0),
                                              ),
                                              Text(
                                                  'Fecha: ${DateFormat('dd|MM|yyyy').format(DateTime.parse(item.fecha!))}',
                                                  style: GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ColorsApp.primary,
                                                      fontSize: 12.0)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  item.evidenciaAdj != null
                                      ? Flexible(
                                          child: InkWell(
                                            onTap: () async {
                                              loadingIndicator(
                                                  onlyLoading: true,
                                                  opacity: true);
                                              Map<String, String> params = {
                                                'archivo':
                                                    item.evidenciaAdj.toString()
                                              };
                                              final justificationService =
                                                  JustificationService();
                                              ApiResponse resp =
                                                  await justificationService
                                                      .geFileRequest(params);

                                              if (resp.success) {
                                                final dir =
                                                    await getTemporaryDirectory();
                                                File file = File(dir.path +
                                                    item.evidenciaAdj
                                                        .toString());
                                                Uint8List bytes =
                                                    base64.decode(resp.data);
                                                await file.writeAsBytes(bytes);
                                                Get.back();
                                                Get.to(VisorPdfImgPage(
                                                    title: 'Evidencia',
                                                    filePath: file.path));
                                                /* Navigator.of(buildContext)
                                                    .pop();

                                                Navigator.push(
                                                    buildContext,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VisorPdfImgPage(
                                                                title:
                                                                    'Evidencia',
                                                                filePath: file
                                                                    .path))); */
                                              } else {
                                                /*                 Navigator.of(buildContext)
                                                    .pop(); */
                                                Get.back();
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 35.0),
                                                Image.asset(
                                                    'assets/icons/file.png',
                                                    height: 25,
                                                    width: 25,
                                                    color: ColorsApp.primary),
                                                Text(
                                                    item.evidenciaAdj
                                                        .toString()
                                                        .toLowerCase(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: ColorsApp
                                                                .primary,
                                                            fontSize: 12.0))
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    children: [
                                      Text(
                                        item.estado.toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          color: item.idEstadoJustif == '01'
                                              ? ColorsApp.primary
                                              : item.idEstadoJustif == '02'
                                                  ? ColorsApp.basic
                                                  : item.idEstadoJustif == '03'
                                                      ? ColorsApp.success
                                                      : item.idEstadoJustif ==
                                                              '04'
                                                          ? ColorsApp.danger
                                                          : item.idEstadoJustif ==
                                                                  '00'
                                                              ? ColorsApp.danger
                                                              : Colors.black,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                          height: 1,
                          color: ColorsApp.primary,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0);
                    },
                    itemCount: children.length),
              ],
            );
          },
          itemCount: listData.length);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('No se encontró información para mostrar.',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: ColorsApp.primary)),
        ),
      );
    }
  }

  void _showModalDetail(BuildContext buildContext, String idTrabajador,
      String id, String idEstado, bool approve) async {
    final pref = UserPreferences();

    await Get.dialog(AlertDialog(
      elevation: 0,
      backgroundColor: ColorsApp.info,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      title: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
            icon: Image.asset('assets/icons/close.png',
                height: 40, width: 40, color: ColorsApp.primary),
            onPressed: () => Get.back()),
      ),
      contentPadding: const EdgeInsets.all(8.0),
      titlePadding: EdgeInsets.zero,
      scrollable: false,
      content: SizedBox(
        width: Get.width
        //MediaQuery.of(context).size.width
        ,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _getDataJustification(id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                try {
                  JustificationModel data = snapshot.data['request'];
                  List<ProcessJustifcationModel> listProcessJustif =
                      snapshot.data['proccess'];
                  List<MarkingWorkerModel> listMarkings =
                      snapshot.data['markings'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(capitalize(data.motivo.toString()),
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: ColorsApp.primary,
                                fontSize: 16.0)),
                      ),
                      const SizedBox(height: 4.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                            'Fecha: ${DateFormat('dd|MM|yyyy').format(DateTime.parse(data.fecha.toString()))}',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                color: ColorsApp.primary,
                                fontSize: 12.0)),
                      ),
                      const SizedBox(height: 4.0),
                      data.evidenciaAdj != null
                          ? InkWell(
                              onTap: () {
                                _showEvidence(buildContext, data);
                              },
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/file.png',
                                      height: 25,
                                      width: 25,
                                      color: ColorsApp.primary),
                                  Text(data.evidenciaAdj.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          color: ColorsApp.primary,
                                          fontSize: 12.0))
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 8.0),
                      data.descripcion != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Motivo.',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          color: ColorsApp.primary,
                                          fontSize: 13.0)),
                                  Text(data.descripcion.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                          color: ColorsApp.primary,
                                          fontSize: 12.0))
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text('Marcaciones solicitadas:',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: ColorsApp.primary,
                                fontSize: 13.0)),
                      ),
                      _markings(listMarkings),
                      const Divider(height: 1, color: ColorsApp.primary),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Proceso: ',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.primary,
                                    fontSize: 13.0)),
                            Flexible(
                              child: Text(
                                data.estado.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: data.idEstadoJustif == '01'
                                        ? ColorsApp.primary
                                        : data.idEstadoJustif == '02'
                                            ? ColorsApp.success
                                            : data.idEstadoJustif == '03'
                                                ? ColorsApp.success
                                                : data.idEstadoJustif == '04'
                                                    ? ColorsApp.danger
                                                    : data.idEstadoJustif ==
                                                            '00'
                                                        ? ColorsApp.danger
                                                        : Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      _processJustif(listProcessJustif),
                      const SizedBox(height: 12.0)
                    ],
                  );
                } catch (e) {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: Text('No se encontró información para mostrar',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: ColorsApp.primary))),
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
      ),
      actions: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              idEstado == '01' && !pref.isWorkerChild && !approve
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .primaryVariant; // Use the component's default.
                            },
                          ),
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
                          child: Text('Anular',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          _showModalAnularRefuse(
                              buildContext, idTrabajador, id, '00', 'Anular');
                        },
                      ),
                    )
                  : Container(),
              (idEstado == '01' && isJefeArea) || (idEstado == '02' && isDth)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .danger; // Use the component's default.
                            },
                          ),
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
                          child: Text('Rechazar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          _showModalAnularRefuse(
                              buildContext, idTrabajador, id, '04', 'Rechazar');
                        },
                      ),
                    )
                  : Container(),
              (idEstado == '01' && isJefeArea) || (idEstado == '02' && isDth)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextButton(
                        style: ButtonStyle(
                          alignment: Alignment.center,
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return ColorsApp
                                  .success; // Use the component's default.
                            },
                          ),
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
                          child: Text(
                              idEstado == '01' && isJefeArea
                                  ? 'Aprobación Area'
                                  : idEstado == '02' && isDth
                                      ? 'Aprobación DTH'
                                      : '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        onPressed: () {
                          _showModalApprove(
                              buildContext, idTrabajador, id, idEstado);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        )
      ],
    ));

    /*    await showDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            title: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Image.asset('assets/icons/close.png',
                      height: 40, width: 40, color: ColorsApp.primary),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            contentPadding: const EdgeInsets.all(8.0),
            titlePadding: EdgeInsets.zero,
            scrollable: false,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _getDataJustification(id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      try {
                        JustificationModel data = snapshot.data['request'];
                        List<ProcessJustifcationModel> listProcessJustif =
                            snapshot.data['proccess'];
                        List<MarkingWorkerModel> listMarkings =
                            snapshot.data['markings'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(capitalize(data.motivo.toString()),
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsApp.primary,
                                      fontSize: 16.0)),
                            ),
                            const SizedBox(height: 4.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  'Fecha: ${DateFormat('dd|MM|yyyy').format(DateTime.parse(data.fecha.toString()))}',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsApp.primary,
                                      fontSize: 12.0)),
                            ),
                            const SizedBox(height: 4.0),
                            data.evidenciaAdj != null
                                ? InkWell(
                                    onTap: () {
                                      _showEvidence(buildContext, data);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset('assets/icons/file.png',
                                            height: 25,
                                            width: 25,
                                            color: ColorsApp.primary),
                                        Text(data.evidenciaAdj.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0))
                                      ],
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 8.0),
                            data.descripcion != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Motivo.',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                color: ColorsApp.primary,
                                                fontSize: 13.0)),
                                        Text(data.descripcion.toString(),
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                color: ColorsApp.primary,
                                                fontSize: 12.0))
                                      ],
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text('Marcaciones solicitadas:',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: ColorsApp.primary,
                                      fontSize: 13.0)),
                            ),
                            _markings(listMarkings),
                            const Divider(height: 1, color: ColorsApp.primary),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Proceso: ',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          color: ColorsApp.primary,
                                          fontSize: 13.0)),
                                  Flexible(
                                    child: Text(
                                      data.estado.toString(),
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0,
                                          color: data.idEstadoJustif == '01'
                                              ? ColorsApp.primary
                                              : data.idEstadoJustif == '02'
                                                  ? ColorsApp.basic
                                                  : data.idEstadoJustif == '03'
                                                      ? ColorsApp.success
                                                      : data.idEstadoJustif ==
                                                              '04'
                                                          ? ColorsApp.danger
                                                          : data.idEstadoJustif ==
                                                                  '00'
                                                              ? ColorsApp.danger
                                                              : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _processJustif(listProcessJustif),
                            const SizedBox(height: 12.0)
                          ],
                        );
                      } catch (e) {
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(
                                  'No se encontró información para mostrar',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      color: ColorsApp.primary))),
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
            ),
            actions: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    idEstado == '01' && !pref.isWorkerChild && !approve
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return ColorsApp
                                        .primaryVariant; // Use the component's default.
                                  },
                                ),
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
                                child: Text('Anular',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () {
                                _showModalAnularRefuse(
                                    context, idTrabajador, id, '00', 'Anular');
                              },
                            ),
                          )
                        : Container(),
                    (idEstado == '01' && isJefeArea) ||
                            (idEstado == '02' && isDth)
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return ColorsApp
                                        .danger; // Use the component's default.
                                  },
                                ),
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
                                child: Text('Rechazar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () {
                                _showModalAnularRefuse(context, idTrabajador,
                                    id, '04', 'Rechazar');
                              },
                            ),
                          )
                        : Container(),
                    (idEstado == '01' && isJefeArea) ||
                            (idEstado == '02' && isDth)
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: TextButton(
                              style: ButtonStyle(
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return ColorsApp
                                        .success; // Use the component's default.
                                  },
                                ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    idEstado == '01' && isJefeArea
                                        ? 'Aprobación Area'
                                        : idEstado == '02' && isDth
                                            ? 'Aprobación DTH'
                                            : '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              onPressed: () {
                                _showModalApprove(
                                    context, idTrabajador, id, idEstado);
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
              )
            ],
          );
        }); */
  }

  void _showEvidence(BuildContext buildContext, JustificationModel data) async {
    loadingIndicator(onlyLoading: true, opacity: true);
    Map<String, String> params = {'archivo': data.evidenciaAdj.toString()};
    final justificationService = JustificationService();
    ApiResponse resp = await justificationService.geFileRequest(params);
    if (resp.success) {
      final dir = await getTemporaryDirectory();
      File file = File(dir.path + data.evidenciaAdj.toString());
      Uint8List bytes = base64.decode(resp.data);
      await file.writeAsBytes(bytes);
      Get.back();
      Get.to(VisorPdfImgPage(title: 'Evidencia', filePath: file.path));
      /* Navigator.of(buildContext).pop();
      Navigator.push(
          buildContext,
          MaterialPageRoute(
              builder: (context) =>
                  VisorPdfImgPage(title: 'Evidencia', filePath: file.path))); */
    } else {
      // Navigator.of(buildContext).pop();
      Get.back();
    }
  }

  Widget _markings(List<MarkingWorkerModel> listMarkings) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: listMarkings.length,
      itemBuilder: (BuildContext context, int index) {
        MarkingWorkerModel item = listMarkings[index];
        return Container(
          padding: const EdgeInsets.only(top: 4.0),
          width: constraints.maxWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset('assets/icons/check.png',
                            height: 25, width: 25, color: ColorsApp.primary),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(item.nombreDescripMarcacion.toString(),
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsApp.primary,
                                    fontSize: 14.0)),
                            item.fechahora != null
                                ? Text(
                                    '${DateFormat('dd|MM|yyyy hh:mm a').format(DateTime.parse(item.fechahora.toString())).toLowerCase()} (Registrado)',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary,
                                        fontSize: 14.0))
                                : Container(),
                            item.fechahoraManual != null
                                ? Text(
                                    DateFormat('dd|MM|yyyy hh:mm a')
                                        .format(DateTime.parse(
                                            item.fechahoraManual.toString()))
                                        .toLowerCase(),
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w400,
                                        color: ColorsApp.primary,
                                        fontSize: 14.0))
                                : Container()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _processJustif(List<ProcessJustifcationModel> listProcessJustif) {
    List<Step> steps = [];
    for (var val in listProcessJustif) {
      if (val.idSolicJustif != null) {
        steps.add(Step(
            isActive: val.idSolicJustif != null ? true : false,
            state: val.idSolicJustif != null
                ? val.idEstadoJustif == '00' || val.idEstadoJustif == '04'
                    ? StepState.error
                    : StepState.complete
                : StepState.disabled,
            title: Text(val.nombre.toString(),
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.primary,
                    fontSize: 14.0)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                val.email != null
                    ? Text(
                        '${val.email}: ${Jiffy(val.fecha.toString(), "dd/MM/yyyy HH:mm").format('dd|MM|yyyy hh:mm a')}',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: ColorsApp.primary,
                            fontSize: 12.0))
                    : Container(),
                val.comentario != null
                    ? Text(val.comentario.toString(),
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            color: ColorsApp.primary,
                            fontSize: 12.0))
                    : Container()
              ],
            ),
            content: Container()));
      }
    }
    return listProcessJustif.isNotEmpty
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails controls) {
                    return Row(
                      children: [
                        InkWell(
                            onTap: controls.onStepContinue, child: Container()),
                        InkWell(
                            onTap: controls.onStepCancel, child: Container()),
                      ],
                    );
                  },
                  physics: const ScrollPhysics(),
                  steps: steps,
                  type: StepperType.vertical,
                ),
              ],
            ),
          )
        : Container();
  }

  void _showModalApprove(BuildContext context, String idTrabajador, String id,
      String idEstado) async {
    await Get.dialog(AlertDialog(
      elevation: 0,
      backgroundColor: ColorsApp.info,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      titleTextStyle: GoogleFonts.montserrat(
          color: ColorsApp.primary, fontWeight: FontWeight.bold, fontSize: 18),
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text((idEstado == '01' && isJefeArea
                  ? 'Aprobación Area'
                  : idEstado == '02' && isDth
                      ? 'Aprobación DTH'
                      : '')
              .toUpperCase()),
        ),
      ),
      content: Column(children: [
        Image.asset('assets/icons/check.png',
            height: 50, width: 50, color: ColorsApp.success),
        Text('¿Desea aprobar la justificacón?',
            style: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14))
      ]),
      actions: [
        TextButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return ColorsApp
                      .primaryVariant; // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
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
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onPressed: () => Navigator.of(context).pop()),
        TextButton(
          style: ButtonStyle(
            alignment: Alignment.center,
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return ColorsApp.success; // Use the component's default.
              },
            ),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25)); // Use the component's default.
              },
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Estoy de acuerdo!',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            changeRequestStatus(
                '',
                context,
                idTrabajador,
                id,
                idEstado == '01' && isJefeArea
                    ? '02'
                    : idEstado == '02' && isDth
                        ? '03'
                        : idEstado);
          },
        )
      ],
    ));
    /* await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            titleTextStyle: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text((idEstado == '01' && isJefeArea
                        ? 'Aprobación Area'
                        : idEstado == '02' && isDth
                            ? 'Aprobación DTH'
                            : '')
                    .toUpperCase()),
              ),
            ),
            content: Column(children: [
              Image.asset('assets/icons/check.png',
                  height: 50, width: 50, color: ColorsApp.success),
              Text('¿Desea aprobar la justificacón?',
                  style: GoogleFonts.montserrat(
                      color: ColorsApp.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))
            ]),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primaryVariant; // Use the component's default.
                      },
                    ),
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
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp.success; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Estoy de acuerdo!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  changeRequestStatus(
                      '',
                      context,
                      idTrabajador,
                      id,
                      idEstado == '01' && isJefeArea
                          ? '02'
                          : idEstado == '02' && isDth
                              ? '03'
                              : idEstado);
                },
              )
            ],
          );
        }); */
  }

  void _showModalAnularRefuse(BuildContext context, String idTrabajador,
      String id, String idEstado, String text) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          TextEditingController inputFieldCtrl = TextEditingController();
          return AlertDialog(
            elevation: 0,
            backgroundColor: ColorsApp.info,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.zero,
            scrollable: true,
            titleTextStyle: GoogleFonts.montserrat(
                color: ColorsApp.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            title: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(text.toUpperCase()),
            )),
            content: TextFormField(
              controller: inputFieldCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                labelText: 'Comentario (opcional)',
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return ColorsApp
                            .primaryVariant; // Use the component's default.
                      },
                    ),
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
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return ColorsApp
                          .primaryVariant; // Use the component's default.
                    },
                  ),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25)); // Use the component's default.
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(text,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  changeRequestStatus(
                      inputFieldCtrl.value.text.isNotEmpty
                          ? inputFieldCtrl.value.text
                          : '',
                      context,
                      idTrabajador,
                      id,
                      idEstado);
                },
              )
            ],
          );
        });
  }

  void changeRequestStatus(String text, BuildContext context,
      String idTrabajador, String id, String idEstado) async {
    final justificationService = JustificationService();
    Map<String, String> params = {
      'id_trabajador': idTrabajador.toString(),
      'id_solic_justif': id,
      'id_estado_justif': idEstado,
      'comentario': text
    };
    loadingIndicator(onlyLoading: false, text: 'Guardando ...');
    ApiResponse create = await justificationService.changeRequestStatus(params);

    if (create.success) {
      Get.back();
      Get.back();

/*       Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context); */
      onChangeList();
    }
  }

  Future<Map<String, dynamic>> _getDataJustification(String id) async {
    Map<String, dynamic> data = {
      'request': null,
      'markings': null,
      'proccess': null
    };
    final justificationService = JustificationService();
    ApiResponse resp = await justificationService.getJustification(id);
    if (resp.success) {
      JustificationModel request = JustificationModel.fromJson(resp.data);
      data['request'] = request;
    }
    List<MarkingWorkerModel> listMarking =
        await justificationService.getJustificationMarkings(id);
    data['markings'] = listMarking;
    List<ProcessJustifcationModel> listProcessJustif =
        await justificationService.getProcessJustification(id);
    data['proccess'] = listProcessJustif;
    return data;
  }
}
