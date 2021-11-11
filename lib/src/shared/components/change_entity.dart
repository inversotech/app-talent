import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/general/deparment.dart';
import 'package:upn_financiero_mobil/src/models/general/entity.dart';
import 'package:upn_financiero_mobil/src/pages/home/home_page.dart';
import 'package:upn_financiero_mobil/src/services/general/deparments_service.dart';
import 'package:upn_financiero_mobil/src/services/general/entity_service.dart';

void showModalChangeEntity(BuildContext buildContext) async {
  await showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (context) {
        return ChangeEntity();
      });
}

class ChangeEntity extends StatefulWidget {
  ChangeEntity({Key? key}) : super(key: key);

  @override
  _ChangeEntityState createState() => _ChangeEntityState();
}

class _ChangeEntityState extends State<ChangeEntity> {
  TextEditingController _inputFieldEntity = new TextEditingController();
  TextEditingController _inputFieldDepto = new TextEditingController();
  EntityService _entityService = EntityService();
  DeparmentsService _deparmentService = DeparmentsService();
  List<Map<String, dynamic>> listMyDeptos = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        elevation: 0,
        backgroundColor: ColorsApp.info,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        title: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
              icon: Image.asset('assets/icons/close.png',
                  height: 40, width: 40, color: ColorsApp.primary),
              onPressed: () => Navigator.of(context).pop()),
        ),
        contentPadding: EdgeInsets.all(8.0),
        titlePadding: EdgeInsets.zero,
        scrollable: false,
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cambiar mi entidad y departamento',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          color: ColorsApp.primary,
                          fontSize: 16.0)),
                  SizedBox(height: 24.0),
                  FutureBuilder(
                      future: _entityService.getListMyEntities(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List<Entity> myEntities = snapshot.data;
                          List<Map<String, dynamic>> listMyEntities = [];
                          myEntities.forEach((element) {
                            listMyEntities.add({
                              'value': element.idEntidad,
                              'label': element.nombre,
                              'icon': null,
                            });
                          });
                          return SelectFormField(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 12.0),
                                labelText: 'Entidad',
                                labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    color: ColorsApp.primary),
                                suffixIcon: Icon(Icons.arrow_drop_down,
                                    color: ColorsApp.primary)),
                            type: SelectFormFieldType.dialog,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: ColorsApp.primary),
                            controller: _inputFieldEntity,
                            changeIcon: true,
                            dialogTitle: 'Seleccionar',
                            dialogCancelBtn: 'Cancelar',
                            enableSearch: false,
                            dialogSearchHint: 'Buscar',
                            items: listMyEntities,
                            onChanged: (val) async {
                              listMyDeptos = [];
                              List<Deparment> list = await _deparmentService
                                  .getListMyDeparments(
                                      {'id_entidad': val.toString()});
                              list.forEach((element) {
                                listMyDeptos.add({
                                  'value': element.idDepto,
                                  'label': element.nombre,
                                  'icon': null,
                                });
                              });
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo requerido.';
                              }
                              return null;
                            },
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }),
                  SizedBox(height: 16.0),
                  SelectFormField(
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 12.0),
                        labelText: 'Departamento',
                        labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: ColorsApp.primary),
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: ColorsApp.primary)),
                    type: SelectFormFieldType.dialog,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600, color: ColorsApp.primary),
                    controller: _inputFieldDepto,
                    changeIcon: true,
                    dialogTitle: 'Seleccionar',
                    dialogCancelBtn: 'Cancelar',
                    enableSearch: false,
                    dialogSearchHint: 'Buscar',
                    items: listMyDeptos,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo requerido.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          Future.microtask(() {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => HomePage(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 2000),
                                ));
                          });
                        },
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/save.png',
                                  height: 30, width: 30, color: Colors.white),
                              Text(
                                'Guardar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.0),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ));
  }
}
