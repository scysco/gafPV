import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  final ctlMail = TextEditingController();
  final ctlPassword = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
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
                        onPressed: login,
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

  Future<void> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: ctlMail.text, password: ctlPassword.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
