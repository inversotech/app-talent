import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomFooterLoading extends StatelessWidget {
  CustomFooterLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? status) {
        Widget body;
        if (status == LoadStatus.idle) {
          body = Text("Jale hacia arriba");
        } else if (status == LoadStatus.loading) {
          body = CircularProgressIndicator();
        } else if (status == LoadStatus.failed) {
          body = Text("Error de carga. Haga clic en reintentar.");
        } else if (status == LoadStatus.canLoading) {
          body = Text("Suelte para cargar más");
        } else {
          body = Text("");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
