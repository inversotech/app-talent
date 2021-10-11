import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';

Future selectDescriptionMarking(
    BuildContext context,
    List<DescriptionMarkingModel> listDescripMarkings,
    String idDescripMarcacion,
    ScheduleWorkerModel scheduleData) async {
  final dialog = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(idDescripMarcacion.isEmpty
            ? 'Nueva marcación'
            : 'Editar marcación'),
        content: Container(
            child: Column(
          children: [
            Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: listDescripMarkings.length,
                itemBuilder: (BuildContext context, int index) {
                  Widget returnWidget = ListTile(
                    title:
                        Text(listDescripMarkings[index].nombre.toString()),
                    selected: idDescripMarcacion ==
                            listDescripMarkings[index].idDescripMarcacion
                        ? true
                        : false,
                    selectedTileColor: Colors.black12,
                    onTap: () {
                      Navigator.of(context).pop({
                        'change': true,
                        'data': listDescripMarkings[index]
                      });
                    },
                  );
                  switch (listDescripMarkings[index].idDescripMarcacion) {
                    case '02':
                      if (scheduleData.fechahoraSalidaRef == null) {
                        returnWidget = Container();
                      }
                      break;
                    case '03':
                      if (scheduleData.fechahoraEntradaRef == null) {
                        returnWidget = Container();
                      }
                      break;
                    default:
                  }
                  return returnWidget;
                },
              ),
            )
          ],
        )),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop({'change': true, 'data': null}),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
  return dialog;
}
