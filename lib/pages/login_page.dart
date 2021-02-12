import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gafemp/model/user_gaf.dart';

import 'package:gafemp/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);

  final ctlMail = TextEditingController();

  final ctlPassword = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorP,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Text(
                  "GAF",
                  style: TextStyle(fontSize: 90, color: Colors.white),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Column(
                  children: [
                    tfForm(hintText: "Correo", controller: ctlMail),
                    SizedBox(height: 20),
                    tfForm(
                        hintText: "Password",
                        obscureText: true,
                        controller: ctlPassword),
                    SizedBox(height: 30),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.60,
                      color: Color.fromARGB(255, 0, 108, 82),
                      child: FlatButton(
                        textColor: Colors.white,
                        child: Text("ENTRAR",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w400)),
                        onPressed: () {
                          login(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Obten tus credenciales con algun administrador",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container tfForm(
      {String hintText,
      bool obscureText = false,
      TextEditingController controller}) {
    return Container(
      height: 45,
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(fontSize: 16, color: colorP),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      if (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: ctlMail.text,
            password: ctlPassword.text,
          ) !=
          null) {
        _data.then((value) {
          setState(() => _isLoading = false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage(value)));
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Correo no Encontrado"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Contraseña Incorecta!!"),
        ));
      }
    }
  }

  Future<UserGaf> get _data async {
    setState(() => _isLoading = true);
    UserGaf user;
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        //print(data['name']);
        user = UserGaf.map(documentSnapshot.data());
      } else {
        print('Document does not exist on the database');
      }
    });
    return user;
  }

  bool _isLoading = false;

  Widget _crearLoading() {
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
          SizedBox(
            height: 15.0,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
