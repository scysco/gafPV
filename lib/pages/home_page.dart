import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:gafemp/model/user_gaf.dart';
import 'package:gafemp/pages/cart_page.dart';
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
  UserGaf user;

  _HomePageState(this.user);

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
                    MaterialPageRoute(builder: (context) => CartPage()));
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
                                      builder: (context) => ProductsPage()));
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
              Container(
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
        return StatefulBuilder(builder: (context, _setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('Cambiar Foto de Perfil'),
            content: Container(
              width: MediaQuery.of(context).size.width * .60,
              height: MediaQuery.of(context).size.height * .30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 25, 20, 30),
                    child: _avatarLoad(80),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {},
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

  Widget _avatarLoad(double radius) {
    return user.image
        ? FutureBuilder<String>(
            future: _urlImage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return CircleAvatar(
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
}
