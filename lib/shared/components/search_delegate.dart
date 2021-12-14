import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchDelgateCustom extends SearchDelegate {
  String nameTitle = '';
  String selection = '';
  String nameSubTitle = '';
  String nameImg = '';
  String fieldLabel = 'Buscar';
  bool searchInput = false;
  Timer? _timer;
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
        icon: const Icon(Icons.clear),
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
    searchInput = false;
    if (query.isEmpty) {
      if (_timer != null) {
        _timer!.cancel();
      }
      return Container();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 400), () {
      searchInput = true;
    });

    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 410), () {
        return searchInput
            ? listData(query)
            : Future.delayed(const Duration(milliseconds: 0));
      }),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List list = snapshot.data;
          if (list.isNotEmpty) {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: list.map((item) {
                final imageIcon = nameImg.isNotEmpty && nameImg != ''
                    ? item[nameImg] ?? ''
                    : '';
                return ListTile(
                  leading: imageIcon.isNotEmpty
                      ? Builder(builder: (context) {
                          try {
                            return CachedNetworkImage(
                              imageUrl: imageIcon!,
                              placeholder: (context, url) => const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/img/user-default.png'),
                              ),
                              errorWidget: (context, url, error) {
                                return const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/img/user-default.png'));
                              },
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                              ),
                            );
                          } catch (e) {
                            return const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/img/user-default.png'),
                            );
                          }
                        })
                      : const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/img/user-default.png'),
                        ),
                  title: Text(item[nameTitle].toString()),
                  subtitle: nameSubTitle.isNotEmpty
                      ? Text(item[nameSubTitle].toString())
                      : const Text(''),
                  onTap: () {
                    close(context, item);
                  },
                );
              }).toList(),
            );
          } else {
            return const Center(
              child: Text('No se econtró información para mostrar.'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
