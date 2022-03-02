import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomFooterLoading extends StatelessWidget {
  final Color colorLoading;
  CustomFooterLoading({Key? key, this.colorLoading = ColorsApp.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? status) {
        Widget body;
        if (status == LoadStatus.idle) {
          body = Text(
            "Jale hacia arriba",
            style: TextStyle(color: colorLoading),
          );
        } else if (status == LoadStatus.loading) {
          body = CircularProgressIndicator(color: colorLoading);
        } else if (status == LoadStatus.failed) {
          body = Text(
            "Error de carga. Haga clic en reintentar.",
            style: TextStyle(color: colorLoading),
          );
        } else if (status == LoadStatus.canLoading) {
          body = Text(
            "Suelte para cargar más",
            style: TextStyle(color: colorLoading),
          );
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
