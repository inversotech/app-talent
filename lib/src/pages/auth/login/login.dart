import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upn_financiero_mobil/src/constants/colors.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/pages/home/home_page.dart';
import 'package:upn_financiero_mobil/src/services/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserService userProvider = new UserService();
  final AuthService oauthProvider = new AuthService();
  LoginFormModel loginFormModel = new LoginFormModel();
  final GlobalKey<FormState> _formLoginKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  void initState() {
    super.initState();
    _clearStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [ColorsApp.primary, ColorsApp.primaryVariant],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),
                        _logo(),
                        _title(),
                        SizedBox(height: 30),
                        _userPasswordWidget(context),
                        SizedBox(height: 20),
                        _submitButton(context),
/*                         _resetPasswordButton(),
 */                      ],
                    ),
                ),
              ),
/*               _loginFaceButton()
 */            ],
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Image.asset('assets/icons/logo.png',
        height: 50.0, fit: BoxFit.cover);
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

  Widget _userPasswordWidget(context) {
    final node = FocusScope.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: this._formLoginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.all(12.0),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.person_outlined),
                  labelText: 'Usuario',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
                onSaved: (value) => loginFormModel.username = value.toString(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Usuario requerido.';
                  }
                  return null;
                },
                onEditingComplete: () => node.nextFocus(),
              ),
            ),
            SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.all(12.0),
              child: TextFormField(
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outlined),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
                obscureText: obscureText,
                onSaved: (value) => loginFormModel.password = value.toString(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Contraseña requerido.';
                  }
                  return null;
                },
                onEditingComplete: () {
                  node.unfocus();
                  _onSubmit(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(ColorsApp.info),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: ColorsApp.info)))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Ingresar',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        onPressed: () {
          _onSubmit(context);
        },
      ),
    );
  }

  Widget _resetPasswordButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: TextButton(
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300, color: Colors.white, fontSize: 14),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _loginFaceButton() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 12.0),
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face, color: Colors.white),
              Text(
                'Ingresar con el lector facial',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 14),
              ),
            ],
          ),
          onPressed: () {},
        ),
    
    );
  }

  void _onSubmit(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      barrierDismissible: false,
    );
    final isValid = _formLoginKey.currentState!.validate();
    if (!isValid) {
      Navigator.pop(context);
      return;
    }
    _formLoginKey.currentState!.save();
    Map<String, String> params = {
      'username': loginFormModel.username,
      'password': loginFormModel.password,
      'no_caduca': 'S'
    };
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    String serial = '';
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      params['uuid'] = androidInfo.androidId; //UUID for Android
      params['model'] = androidInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['version'] = androidInfo.version.release;
      params['manufacturer'] = androidInfo.manufacturer;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      params['uuid'] = iosInfo.identifierForVendor; //UUID for iOS
      params['model'] = iosInfo.model;
      params['platform'] = Platform.operatingSystem;
      params['version'] = iosInfo.systemVersion;
      params['manufacturer'] = iosInfo.systemName;
    }
    params['serial'] = serial;
    params['isvirtual'] = '';
    // print(params);
    final resp = await oauthProvider.loginLamb(params);
    if (resp.success) {
      Navigator.pop(context);
      Future.microtask(() {
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => HomePage(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 2000),
            ));
      });
    } else {
      Navigator.pop(context);
    }
    // get token oauth lamb
    /* final resp = await oauthProvider.loginLamb(
        loginFormModel.username, loginFormModel.password);
    if (resp.success) {
      final valid = await oauthProvider.validToken();
      if (valid.success) {s
        _loggingIn();
      } else {
        Navigator.pop(context);
      }
      /* final verifyToken =
          await userProvider.validToken();
           print(verifyToken);
      if (verifyToken) {
        print(verifyToken); 
        Navigator.pop(context);*/

      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, 'home');
      /* } else {
        // ToastCustom().danger(message: 'Error en servidor de autetificación.');
        Navigator.pop(context);
      } */
    } else {
      // ToastCustom().danger(message: 'Usuario o contraseña incorrecto !!');
      Navigator.pop(context);
    } */
  }

  void _clearStorage() {
    final storage = new FlutterSecureStorage();
    storage.delete(key: 'access_token');
  }
}
