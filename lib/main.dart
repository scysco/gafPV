import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gafemp/model/user_gaf.dart';
import 'package:gafemp/pages/products_page.dart';

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
    return FutureBuilder<UserGaf>(
      // Initialize FlutterFire
      future: _user(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return HomePage(snapshot.data);
          } else {
            return LoginPage();
          }
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading(context);
      },
    );
  }

  Future<UserGaf> _user() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserGaf user;
    if (auth.currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          user = UserGaf.map(documentSnapshot.data());
          print('Document data: ${documentSnapshot.data()}');
        } else {
          user = null;
          print('Document does not exist on the database');
        }
      });
    } else {
      user = null;
    }
    return user;
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
