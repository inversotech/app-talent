import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:upn_financiero_mobil/src/services/general/entity_service.dart';

final provider = new EntityService();
Future changeEntity(BuildContext context) async {
  final dialog = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Center(
            child: Text(
              'Seleccionar entidad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            child: FutureBuilder(
              future: _listEntities(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final List entities = snapshot.data;
                  return _createItems(entities);
                  //print(snapshot.data);
                  //return Container();
                  //_createItem(idEntity, title)
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop({'change': true, 'data': null}),
              child: Text('Cerrar'),
              style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            /*  TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
              style: TextButton.styleFrom(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ), */
          ],
        );
      });
  return dialog;
}

Future _listEntities() async {
  final resp = await provider.getListEntities();
  if (resp.success) {
    return resp.data;
  } else {
    return [];
  }
}

Widget _createItems(List elements) {
  return GroupListView(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    sectionsCount: elements.length,
    countOfItemInSection: (int section) {
      final entidades = elements[section]['entidades'];
      return entidades.length;
    },
    itemBuilder: (BuildContext context, IndexPath index) {
      return TextButton(
        onPressed: () {
          Navigator.of(context).pop({'change': true, 'data': elements[index.section]['entidades']
                  [index.index]});
          
         // Navigator.pushReplacementNamed(context, RoutesName.home);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            elements[index.section]['entidades'][index.index]['name'],
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    },
    groupHeaderBuilder: (BuildContext context, int section) {
      return Text(
        elements[section]['name'],
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    },
    separatorBuilder: (context, index) => SizedBox(height: 1),
    sectionSeparatorBuilder: (context, section) => SizedBox(height: 1),
  );
}
