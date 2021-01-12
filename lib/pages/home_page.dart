import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gafemp/pages/cart_page.dart';
import 'package:gafemp/pages/products_page.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);

  String userData = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    readUser().then((String value) {
      setState(() {
        userData = value;
        userName = userData.split(',')[0].split(':')[1];
      });
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
      height: 160,
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
                          "Hola " + userName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "Bienvenido de regreso",
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
                Container(
                  padding: EdgeInsets.all(20),
                  child: CircleAvatar(
                    child: Text('JS'),
                    backgroundColor: Colors.white70,
                    radius: 26,
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

  Future<String> readUser() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "default";
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/user.gaf');
  }
}
