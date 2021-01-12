import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gafemp/pages/products_page.dart';
import 'package:path_provider/path_provider.dart';

import 'package:gafemp/pages/home_page.dart';
import 'package:gafemp/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GAF Punto de Venta',
        theme: ThemeData(
          primaryColor: colorP, // default value
        ),
        routes: <String, WidgetBuilder>{
          '/ProductPage': (BuildContext context) => ProductsPage(),
        },
        home: FutureBuilder(
          // Initialize FlutterFire
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return somethingWentWrong(context);
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return myApp(context);
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return loading(context);
          },
        ),
      ),
    );
  }

  FutureBuilder myApp(BuildContext context) {
    return FutureBuilder<File>(
      // Initialize FlutterFire
      future: _userFile(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.existsSync()) {
            return myHome(context);
          } else {
            return LoginPage();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading(context);
      },
    );
  }

  FutureBuilder myHome(BuildContext context) {
    return FutureBuilder<File>(
      // Initialize FlutterFire
      future: _getData(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return HomePage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading(context);
      },
    );
  }

  Future<File> _getData() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/user.gaf');
  }

  Future<File> _userFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/user.gaf');
  }

  Widget loading(BuildContext context) {
    return Scaffold(
      backgroundColor: colorP,
      body: Center(
        child: Text(
          'GAF',
          style: TextStyle(fontSize: 90, color: Colors.white),
        ),
      ),
    );
  }

  Widget somethingWentWrong(BuildContext context) {
    return Scaffold(
      backgroundColor: colorP,
      body: Center(
        child: Text(
          'somethingWentWrong',
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }
}
