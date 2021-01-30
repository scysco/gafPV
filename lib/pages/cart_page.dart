import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gafemp/model/product_gaf.dart';
import 'package:gafemp/model/report_sale_gaf.dart';
import 'package:gafemp/model/user_gaf.dart';
import 'package:gafemp/widget/product.dart';

class CartPage extends StatefulWidget {
  final UserGaf user;
  CartPage(this.user);
  @override
  _CartPageState createState() => _CartPageState(user);
}

class _CartPageState extends State<CartPage> {
  UserGaf user;
  String store;
  CollectionReference productsRef;
  CollectionReference sales;
  String qrCodeResult;
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  List<ProductGaf> products = [];
  double total = 0.0;
  TextEditingController ctrlSearch = TextEditingController();
  List<QueryDocumentSnapshot> srchProds;
  List<QueryDocumentSnapshot> srchProdsTemp = [];

  _CartPageState(this.user);

  @override
  void initState() {
    super.initState();
    store = user.stores;
    productsRef =
        FirebaseFirestore.instance.collection('stores/$store/products');
    sales = FirebaseFirestore.instance.collection('stores/$store/sales');
  }

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
              Material(
                color: colorP,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => _searchPnl(context),
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage('assets/searchsec.png'),
                          height: 32,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Buscar",
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
              Material(
                color: colorP,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => _scan(),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Image(
                      image: AssetImage('assets/qrsec.png'),
                      height: 66,
                    ),
                  ),
                ),
              ),
              Material(
                color: colorP,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () => _endSale(context),
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.all(15),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _scan() async {
    String codeSanner = await FlutterBarcodeScanner.scanBarcode(
        "#004d40", "Cancel", true, ScanMode.QR);
    if (codeSanner != '-1') {
      AudioCache player = AudioCache();
      qrCodeResult = codeSanner;
      player.play('beep-barcode.mp3');
      FirebaseFirestore.instance
          .collection('stores/$store/products')
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

  void _searchPnl(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, _setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('BUSQUEDA'),
            content: Container(
              width: MediaQuery.of(context).size.width * .85,
              height: MediaQuery.of(context).size.height * .65,
              child: Column(
                children: [
                  TextField(
                    controller: ctrlSearch,
                    onChanged: (value) {
                      List<QueryDocumentSnapshot> temp = [];
                      srchProds.forEach((element) {
                        String sn = element.data()['nombre'];
                        String sm = element.data()['marca'];
                        bool insertProduct = false;
                        if (sn.toLowerCase().startsWith(value.toLowerCase())) {
                          insertProduct = true;
                        }
                        if (sm.toLowerCase().startsWith(value.toLowerCase())) {
                          insertProduct = true;
                        }
                        if (insertProduct) {
                          temp.add(element);
                        }
                      });
                      _setState(() {
                        srchProdsTemp = temp;
                        temp = [];
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Buscar Produco',
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productsRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        } else {
                          srchProds = snapshot.data.docs;
                          return ListView.builder(
                              //padding: EdgeInsets.all(25),
                              itemCount: srchProdsTemp.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map ds = srchProdsTemp[index].data();
                                String id = srchProdsTemp[index].id;
                                ds['code'] = id;
                                ProductGaf prod = ProductGaf(
                                    ds['code'],
                                    ds['nombre'],
                                    ds['marca'],
                                    double.parse(ds['costo'].toString()),
                                    double.parse(ds['precio'].toString()),
                                    ds['tipo'],
                                    double.parse(ds['unidades'].toString()),
                                    ['s', 'sd']);
                                return Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () => _addUnits(context, prod),
                                    child: Container(
                                      width: 150,
                                      child: Product(Colors.black87, prod),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
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

  void _addUnits(
    BuildContext context,
    ProductGaf product,
  ) {
    ProductGaf secProduct = product;
    secProduct.unidades = 1.0;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (_context, _setState) {
          TextEditingController ctrlTextAddProd = TextEditingController();

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
                              if (double.parse(ctrlTextAddProd.text) > 1) {
                                _setState(() {
                                  secProduct.unidades--;
                                  secProduct.precio =
                                      product.product['precio'] *
                                          secProduct.unidades;
                                });
                              } else {
                                _setState(() {
                                  secProduct.unidades = 0.5;
                                  secProduct.precio =
                                      product.product['precio'] *
                                          secProduct.unidades;
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
                              if (double.tryParse(text) != null) {
                                double u = double.parse(text);
                                if (u > 0) {
                                  secProduct.unidades = u;
                                  secProduct.precio =
                                      product.product['precio'] *
                                          secProduct.unidades;
                                  String p = secProduct.precio.toString();
                                  print(
                                      '**********************precio = $p**************');
                                }
                              }
                              String f = secProduct.unidades.toString();
                              print(
                                  '**********************units = $f**************');
                            },
                            textAlign: TextAlign.center,
                            controller: ctrlTextAddProd
                              ..text = secProduct.unidades.toString(),
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w300),
                          ),
                        ),
                        FlatButton(
                            onPressed: () => _setState(() {
                                  if (double.parse(ctrlTextAddProd.text) >= 1) {
                                    secProduct.unidades++;
                                  } else {
                                    secProduct.unidades = 1;
                                  }
                                  secProduct.precio =
                                      product.product['precio'] *
                                          secProduct.unidades;
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
                          bool exis = false;
                          products.forEach((element) {
                            if (element.code == secProduct.code) {
                              exis = true;
                              element.unidades += secProduct.unidades;
                              element.precio =
                                  element.product['precio'] * element.unidades;
                            }
                            total += element.precio;
                          });
                          if (!exis) {
                            products.add(secProduct);
                          }
                          _setTotal();
                        });
                        Navigator.of(context).pop();
                        Navigator.of(_context).pop();
                      },
                      child: Text(
                        'AGREGAR',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  String strCambio = '0';
  void _endSale(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, _setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text('COMPLETAR VENTA'),
            content: Container(
              width: MediaQuery.of(context).size.width * .70,
              height: MediaQuery.of(context).size.height * .40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Total',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Text('\$' + total.toString(),
                              style: TextStyle(fontSize: 50, color: colorP))),
                      Divider(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Cambio',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '\$' + strCambio,
                          style:
                              TextStyle(fontSize: 50, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (double.tryParse(text) != null) {
                        double t = double.parse(text);
                        double cambio = t - total;
                        _setState(() {
                          setState(() {
                            strCambio = cambio.toString();
                          });
                        });
                      }
                    },
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    )),
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w300),
                  ),
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        resportSale();
                        _setState(() {
                          setState(() {
                            strCambio = '0';
                            total = 0;
                            products.clear();
                          });
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        child: Text(
                          'FINALIZAR',
                          style: TextStyle(fontSize: 30, color: Colors.green),
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

  FirebaseAuth auth = FirebaseAuth.instance;
  void resportSale() {
    DateTime now = new DateTime.now();
    List<ReportSaleGaf> reports = [];
    products.forEach((element) {
      ReportSaleGaf report = ReportSaleGaf(
          element.code,
          element.nombre,
          element.marca,
          element.costo,
          element.precio,
          element.precio - element.costo,
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          auth.currentUser.uid);
      reports.add(report);
    });
    reports.forEach((element) {
      addReport(element);
    });
  }

  Future<void> addReport(ReportSaleGaf element) {
    // Call the user's CollectionReference to add a new user
    return sales
        .add(element.report)
        .then((value) => print("Repor Added"))
        .catchError((error) => print("Failed to add Report: $error"));
  }
}
