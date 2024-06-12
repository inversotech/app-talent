import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamb_talent/controllers/auth/login_controller.dart';
import 'package:lamb_talent/core/colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ColorsApp.primary, ColorsApp.primaryVariant],
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _logo(),
                _title(),
                const SizedBox(height: 30),
                _userPasswordWidget(context),
                _checkWidget(context),
                const SizedBox(height: 20),
                _submitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Image.asset('assets/icons/logo.png',
        height: 60.0, fit: BoxFit.cover);
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Bienvenido',
        style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget _userPasswordWidget(buildContext) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.all(12.0),
                      child: Semantics(
                        label: 'Usuario',
                        enabled: true,
                        hint: 'Ingrese su usuario',
                        child: TextFormField(
                          controller: controller.username,
                          keyboardType: TextInputType.visiblePassword,
                          autofocus: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_outlined),
                            labelText: 'Usuario',
                            hintText: 'Ingrese su usuario',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Usuario requerido.';
                            }
                            return null;
                          },
                          onEditingComplete: () =>
                              controller.focusPassword.requestFocus(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.all(12.0),
                      child: Semantics(
                          label: 'Contraseña',
                          enabled: true,
                          hint: 'Ingrese su contraseña',
                          child: Obx(() => TextFormField(
                                controller: controller.password,
                                focusNode: controller.focusPassword,
                                obscureText: controller.obscureText.value,
                                decoration: inputDecorationPassword(),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Contraseña requerido.';
                                  }
                                  return null;
                                },
                                onEditingComplete: () {
                                  controller.loginLamb(buildContext);
                                },
                              ))),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget _checkWidget(buildContext) {
    return Obx(() => CheckboxListTile(
        // tileColor: ColorsApp.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('Guardar credenciales',
            style: TextStyle(color: ColorsApp.white)),
        value: controller.checkCredencial.value,
        side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
          return const BorderSide(
              width: 2.0,
              style: BorderStyle.solid,
              color: ColorsApp
                  .white); // Defer to default value on the theme or widget.
        }),
        onChanged: (val) {
          controller.checkCredencial.value = val!;
        }));
  }

  Widget _submitButton(BuildContext buildContext) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ColorsApp.info),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: const BorderSide(color: ColorsApp.info)))),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Ingresar',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        onPressed: () {
          controller.loginLamb(buildContext);
        },
      ),
    );
  }

  InputDecoration inputDecorationPassword() {
    return InputDecoration(
      icon: const Icon(Icons.lock_outlined),
      labelText: 'Contraseña',
      hintText: 'Ingrese su contraseña',
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      border: InputBorder.none,
      suffixIcon: Obx(() => IconButton(
            icon: Icon(controller.obscureText.value
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              controller.obscureText.value = !controller.obscureText.value;
            },
          )),
    );
  }
}
