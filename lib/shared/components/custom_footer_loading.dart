import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomFooterLoading extends StatelessWidget {
  const CustomFooterLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? status) {
        Widget body;
        if (status == LoadStatus.idle) {
          body = const Text("Jale hacia arriba");
        } else if (status == LoadStatus.loading) {
          body = const CircularProgressIndicator();
        } else if (status == LoadStatus.failed) {
          body = const Text("Error de carga. Haga clic en reintentar.");
        } else if (status == LoadStatus.canLoading) {
          body = const Text("Suelte para cargar más");
        } else {
          body = const Text("");
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
