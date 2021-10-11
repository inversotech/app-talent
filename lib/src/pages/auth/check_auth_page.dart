import 'package:flutter/material.dart';
import 'package:upn_financiero_mobil/src/models/models.dart';
import 'package:upn_financiero_mobil/src/pages/auth/login/login.dart';
import 'package:upn_financiero_mobil/src/pages/home/home_page.dart';
import 'package:upn_financiero_mobil/src/services/auth/auth.dart';

class CheckAuthPage extends StatefulWidget {
  const CheckAuthPage({Key? key}) : super(key: key);

  @override
  State<CheckAuthPage> createState() => _CheckAuthPageState();
}

class _CheckAuthPageState extends State<CheckAuthPage> {
  final AuthService oauthProvider = new AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: oauthProvider.validToken(),
          builder: (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!.success) {
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
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => LoginPage(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 2000),
                      ));
                });
              }
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Verificando...',
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
