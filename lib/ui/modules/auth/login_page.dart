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
      body: Column(
        children: [
          _headerSection(),
          _formSection(context),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorsApp.primary, Color.fromARGB(255, 3, 36, 71)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Bienvenido',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tus credenciales',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
          child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (_) => Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _usernameField(),
                  const SizedBox(height: 20),
                  _passwordField(context),
                  const SizedBox(height: 12),
                  _checkWidget(),
                  const SizedBox(height: 28),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: controller.username,
      keyboardType: TextInputType.text,
      autofocus: true,
      style: GoogleFonts.montserrat(
        fontSize: 16,
        color: ColorsApp.primary,
      ),
      decoration: _inputDecoration(
        label: 'Usuario',
        hint: 'Ingrese su usuario',
        icon: Icons.person_outline_rounded,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Usuario requerido';
        }
        return null;
      },
      onEditingComplete: () => controller.focusPassword.requestFocus(),
    );
  }

  Widget _passwordField(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller.password,
        focusNode: controller.focusPassword,
        obscureText: controller.obscureText.value,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          color: ColorsApp.primary,
        ),
        decoration: _inputDecoration(
          label: 'Contraseña',
          hint: 'Ingrese su contraseña',
          icon: Icons.lock_outline_rounded,
          suffixIcon: IconButton(
            icon: Icon(
              controller.obscureText.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: ColorsApp.control,
            ),
            onPressed: () {
              controller.obscureText.value = !controller.obscureText.value;
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Contraseña requerida';
          }
          return null;
        },
        onEditingComplete: () => controller.loginLamb(context),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        color: ColorsApp.primaryVariant,
      ),
      hintStyle: GoogleFonts.montserrat(
        color: ColorsApp.control,
      ),
      prefixIcon: Icon(icon, color: ColorsApp.primaryVariant),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: ColorsApp.info.withValues(alpha: 0.25),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorsApp.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorsApp.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorsApp.danger, width: 2),
      ),
    );
  }

  Widget _checkWidget() {
    return Obx(
      () => Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: controller.checkCredencial.value,
              activeColor: ColorsApp.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: ColorsApp.control),
              onChanged: (val) => controller.checkCredencial.value = val!,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Guardar credenciales',
            style: GoogleFonts.montserrat(
              color: ColorsApp.primaryVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: ColorsApp.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
      ),
      onPressed: () => controller.loginLamb(context),
      child: Text(
        'Ingresar',
        style: GoogleFonts.montserrat(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
