import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gafemp/pages/home_page.dart';
import 'package:gafemp/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String page;
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        page = "login";
      } else {
        page = "/";
      }
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GAF Punto de Venta',
        initialRoute: page,
        routes: {
          '/': (BuildContext context) => HomePage(),
          'login': (BuildContext context) => LoginPage(),
        },
      ),
    );
  }
}
