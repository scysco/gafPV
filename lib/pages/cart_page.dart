import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gafemp/model/product_gaf.dart';
import 'package:gafemp/widget/product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String qrCodeResult;
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  List<ProductGaf> products = [];
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorP,
        body: SafeArea(
          child: Column(
            children: [
              _top(),
              _center(context),
              _bottom(context),
            ],
          ),
        ));
  }

  Widget _top() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage('assets/arrowsec.png'),
            height: 40,
          ),
          Image(
            image: AssetImage('assets/phonesec.png'),
            width: 30,
          ),
        ],
      ),
    );
  }

  Widget _center(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carrito',
              style: TextStyle(
                fontSize: 38,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text('Empty'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          color: colorP,
                          child: InkWell(
                            child: Product(Colors.white, products[index]),
                            onTap: () {
                              _setUnits(context, products[index]);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottom(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                '\$' + total.toString(),
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/searchsec.png'),
                      height: 32,
                    ),
                    SizedBox(height: 5),
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
                padding: EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    _scan();
                  },
                  child: Image(
                    image: AssetImage('assets/qrsec.png'),
                    height: 66,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/cartsec.png'),
                      height: 32,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Terminar",
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
        ],
      ),
    );
  }

  Future<void> _scan() async {
    AudioCache player = AudioCache();
    String codeSanner = await FlutterBarcodeScanner.scanBarcode(
        "#004d40", "Cancel", true, ScanMode.QR);
    qrCodeResult = codeSanner;
    player.play('beep-barcode.mp3');
    FirebaseFirestore.instance
        .collection('stores/goyEoBspy0fCNUIgdPWE/products')
        .doc(qrCodeResult)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _addProduct(qrCodeResult, documentSnapshot.data());
        });
      }
    });
  }

  void _addProduct(String code, Map<String, dynamic> data) {
    ProductGaf prd;
    bool exis = false;
    products.forEach((element) {
      if (element.code == code) {
        exis = true;
        element.unidades++;
        element.precio = element.product['precio'] * element.unidades;
      }
      total += element.precio;
    });
    if (!exis) {
      prd = ProductGaf.map(data, code: code, unidades: 1);
      products.add(prd);
    }
    _setTotal();
  }

  void _setTotal() {
    total = 0;
    products.forEach((element) {
      total += element.precio;
    });
  }

  void _endSale() {}

  void _setUnits(
    BuildContext context,
    ProductGaf product,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, _setState) {
          TextEditingController ctrlText = TextEditingController();
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(product.nombre),
            content: Container(
              height: 112,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(
                              30.0) //         <--- border radius here
                          ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () {
                              if (double.parse(ctrlText.text) > 1) {
                                setState(() {
                                  product.unidades--;
                                  product.precio = product.product['precio'] *
                                      product.unidades;
                                  _setState(() {
                                    ctrlText.text = product.unidades.toString();
                                  });
                                  _setTotal();
                                });
                              }
                            },
                            child: Container(
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w300),
                              ),
                            )),
                        Container(
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              setState(() {
                                if (double.tryParse(text) != null) {
                                  double u = double.parse(text);
                                  if (u > 0) {
                                    product.unidades = u;
                                    product.precio = product.product['precio'] *
                                        product.unidades;
                                    _setTotal();
                                  }
                                }
                              });
                            },
                            textAlign: TextAlign.center,
                            controller: ctrlText
                              ..text = product.unidades.toString(),
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w300),
                          ),
                        ),
                        FlatButton(
                            onPressed: () => setState(() {
                                  product.unidades++;
                                  product.precio = product.product['precio'] *
                                      product.unidades;
                                  _setState(() {
                                    ctrlText.text = product.unidades.toString();
                                  });
                                  _setTotal();
                                }),
                            child: Container(
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w300),
                              ),
                            )),
                      ],
                    ),
                  ),
                  FlatButton(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPressed: () {
                        setState(() {
                          products.remove(product);
                          _setTotal();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'ELIMINAR',
                        style: TextStyle(color: Colors.redAccent, fontSize: 20),
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
