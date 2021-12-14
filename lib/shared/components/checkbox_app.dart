import 'package:flutter/material.dart';
import 'package:lamb_talent/core/colors.dart';

class CheckboxApp extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;
  final double size;
  const CheckboxApp(
      {Key? key,
      required this.value,
      required this.onChanged,
      this.size = 20.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!value);
          }
        },
        child: Container(
          width: size * 2,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: ColorsApp.primary),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(2.0),
              child: value
                  ? Icon(
                      Icons.check,
                      size: size,
                      color: Colors.white,
                    )
                  : Container(
                    height: size,
                    width: size,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
            ),
          ),
        ));
  }
}
