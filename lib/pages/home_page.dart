import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gafemp/model/user_gaf.dart';
import 'package:gafemp/pages/cart_page.dart';
import 'package:gafemp/pages/message_page.dart';
import 'package:gafemp/pages/products_page.dart';

class HomePage extends StatefulWidget {
  final UserGaf user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  StreamSubscription<Event> _messagesSubscription;

  DatabaseReference myRef;
  UserGaf user;
  RemoteMessage initialMessage;

  _HomePageState(this.user);
  @override
  void initState() {
    super.initState();
    asignMessage();
    myRef = database.reference().child('/chat/goyEoBspy0fCNUIgdPWE');
    DatabaseReference ref = myRef.child(myRef.push().key);
    ref.child('message').set('value');
    ref.child('d').set('1');

    StreamSubscription<Event> _messagesSubscription =
        myRef.onChildAdded.listen((event) {
      print('Child added: ${event.snapshot.value}');
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorP,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _center(),
            _bottom(),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 100,
        width: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(14),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage(user)));
              },
              child: Image(
                image: AssetImage('assets/cart.png'),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _top() {
    return Container(
      color: colorP,
      height: 150,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hola " + user.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          user.genre == 'Hombre'
                              ? 'Bienvenido de regreso'
                              : 'Bienvenida de regreso',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Material(
                  color: colorP,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      _avatarPanel(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: _avatarLoad(26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            height: 62,
            child: TextField(
              //style: TextStyle(fontSize: 10),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Buscar procuctos",
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _urlImage() async {
    String url = await firebase_storage.FirebaseStorage.instance
        .ref('profilePictures/' + auth.currentUser.uid + '.jpg')
        .getDownloadURL();
    return url;
  }

  Widget _center() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 25),
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('assets/phone.png'),
                            width: 80,
                          ),
                          Text('Recargas'),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage('assets/delay.png'),
                            width: 80,
                          ),
                          Text('Distribuidores'),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductsPage(user)));
                            },
                            child: Image(
                              image: AssetImage('assets/products.png'),
                              height: 66,
                            ),
                          ),
                          Text('Productos'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 20,
            right: 20,
          ),
          height: 80,
          color: colorP,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/tasks.png'),
                      height: 40,
                    ),
                    Text(
                      "Tareas",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: colorP,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/messages.png'),
                          height: 40,
                        ),
                        Text(
                          "Mensajes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _avatarPanel(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (_context, _setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Cambiar Foto de Perfil'),
            content: Container(
              width: MediaQuery.of(context).size.width * .60,
              height: MediaQuery.of(context).size.height * .40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        _filePicker(_setState);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 25, 20, 30),
                        child: _avatarLoad(80, onEdit: true),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        _setProfileImage(_context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "ACEPTAR",
                          style: TextStyle(
                            color: colorP,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _avatarLoad(double radius, {bool onEdit = false}) {
    return user.image
        ? FutureBuilder<String>(
            future: _urlImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return onEdit
                      ? CircleAvatar(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: (_image != null)
                                        ? FileImage(_image)
                                        : NetworkImage(snapshot.data),
                                  ))),
                          radius: radius,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data),
                          radius: radius,
                        );
                } else {}
              }
              return CircleAvatar(
                child: Text(user.name[0] + user.secondName[0]),
                backgroundColor: Colors.white70,
                radius: radius,
              );
            },
          )
        : CircleAvatar(
            child: Text(user.name[0] + user.secondName[0]),
            backgroundColor: Colors.white70,
            radius: radius,
          );
  }

  File _image;
  Future<void> _filePicker(_setState) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      _setState(() {
        _image = File(result.files.first.path);
      });
      print('***********' + _image.path);
    }
  }

  void _setProfileImage(BuildContext context) async {
    if (_image != null) {
      try {
        Navigator.of(context).pop();
        await firebase_storage.FirebaseStorage.instance
            .ref('profilePictures/' + auth.currentUser.uid + '.jpg')
            .putFile(_image);
        _image = null;
        setState(() {});
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
    } else {
      _image = null;
      Navigator.of(context).pop();
    }
  }

  Future<void> asignMessage() async {
    await FirebaseMessaging.instance.getInitialMessage();
  }
}
