import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDelgateCustom extends SearchDelegate {
  String nameTitle = '';
  String selection = '';
  String nameSubTitle = '';
  String nameImg = '';
  String fieldLabel = 'Buscar';
  final Future Function(String) listData;
  SearchDelgateCustom(
      {required this.nameTitle,
      this.nameSubTitle = '',
      required this.listData,
      this.nameImg = '',
      this.fieldLabel = ''});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
    //throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selection),
      ),
    );
    //throw UnimplementedError();
  }

  @override
  String get searchFieldLabel => fieldLabel;
  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    //throw UnimplementedError();
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: this.listData(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List list = snapshot.data;
          if (list.length > 0) {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: list.map((item) {
                final imageIcon = this.nameImg.isNotEmpty && this.nameImg != ''
                    ? item[this.nameImg] ?? ''
                    : '';
                return ListTile(
                  leading: imageIcon.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageIcon!,
                          placeholder: (context, url) => CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/img/user-default.png'),
                          ),
                          errorWidget: (context, url, error) {
                            return CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/img/user-default.png'));
                          },
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/img/user-default.png'),
                        ),
                  title: Text(item[this.nameTitle].toString()),
                  subtitle: nameSubTitle.isNotEmpty
                      ? Text(item[this.nameSubTitle].toString())
                      : Text(''),
                  onTap: () {
                    close(context, item);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: Text('No se econtró información para mostrar.'),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /*  @override
  Widget buildSuggestions(BuildContext context) {
    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((element) =>
                element.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    // Las sugerencias que aparecen cuando la persona escribe
    return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: () {
              selection = listaSugerida[i];
              showResults(context);
            },
          );
        });
    //throw UnimplementedError();
  } */
}
