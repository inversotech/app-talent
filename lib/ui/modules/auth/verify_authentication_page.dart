import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/auth/verify_authentication_controller.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyAutheticationController>(
        init: VerifyAutheticationController(),
        builder: (_) => Scaffold(
              body: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Verificando...',
                    )
                  ],
                ),
              )),
            ));
  }
}
