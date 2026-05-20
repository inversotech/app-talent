import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/controllers/auth/login_controller.dart';
import 'package:lamb_talent/core/colors.dart';
import 'package:lamb_talent/core/design_tokens.dart';
import 'package:lamb_talent/shared/components/app_button.dart';
import 'package:lamb_talent/shared/components/app_text.dart';
import 'package:lamb_talent/shared/components/app_text_field.dart';

/// Página de Login rediseñada siguiendo Golden Rules for Clean UI Design
///
/// Cambios aplicados:
/// - Gradiente simplificado en header (primary → primaryLight)
/// - AppTextField para inputs consistentes
/// - AppButton.primary para botón de login
/// - AppText para todos los textos
/// - Spacing generoso (Spacing.lg = 24px entre elementos)
/// - Nueva paleta de colores con neutrales
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

  /// Header section con gradiente simplificado
  Widget _headerSection() {
    return Expanded(
      flex: 2,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // colors: [ColorsApp.primary, ColorsApp.primaryLight],
            colors: [ColorsApp.primary, ColorsApp.primary],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/icons/logo.png',
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: Spacing.lg),

              // Título principal
              AppText.display2(
                'Bienvenido',
                color: ColorsApp.white,
              ),
              const SizedBox(height: Spacing.sm),

              // Subtítulo
              AppText.body(
                'Ingresa tus credenciales',
                color: ColorsApp.white.withValues(alpha: 0.85),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Form section con spacing generoso
  Widget _formSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsApp.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Spacing.xl),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.xl,
            Spacing.xl,
            Spacing.xl,
            Spacing.lg,
          ),
          child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (_) => Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _usernameField(),
                  const SizedBox(height: Spacing.lg),
                  _passwordField(),
                  const SizedBox(height: Spacing.md),
                  _checkWidget(),
                  const SizedBox(height: Spacing.xl),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Campo de usuario usando AppTextField
  Widget _usernameField() {
    return AppTextField(
      controller: controller.username,
      label: 'Usuario',
      hintText: 'Ingrese su usuario',
      prefixIcon: Icons.person_outline_rounded,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Usuario requerido';
        }
        return null;
      },
      onFieldSubmitted: (_) => controller.focusPassword.requestFocus(),
    );
  }

  /// Campo de contraseña con toggle de visibilidad
  Widget _passwordField() {
    return Obx(
      () => AppTextField(
        controller: controller.password,
        focusNode: controller.focusPassword,
        label: 'Contraseña',
        hintText: 'Ingrese su contraseña',
        prefixIcon: Icons.lock_outline_rounded,
        obscureText: controller.obscureText.value,
        textInputAction: TextInputAction.done,
        suffixIcon: controller.obscureText.value
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        onSuffixIconPressed: () {
          controller.obscureText.value = !controller.obscureText.value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Contraseña requerida';
          }
          return null;
        },
        onFieldSubmitted: (_) => controller.loginLamb(Get.context!),
      ),
    );
  }

  /// Checkbox para guardar credenciales
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
              side: BorderSide(color: ColorsApp.neutral400),
              onChanged: (val) => controller.checkCredencial.value = val!,
            ),
          ),
          const SizedBox(width: Spacing.md),
          AppText.body(
            'Guardar credenciales',
            color: ColorsApp.neutral700,
          ),
        ],
      ),
    );
  }

  /// Botón de submit usando AppButton
  Widget _submitButton(BuildContext context) {
    return AppButton.primary(
      text: 'Ingresar',
      onPressed: () => controller.loginLamb(context),
      fullWidth: true,
    );
  }
}
