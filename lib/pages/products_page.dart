import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gafemp/model/product_gaf.dart';
import 'package:gafemp/pages/new_product_page.dart';
import 'package:gafemp/widget/product.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);
  CollectionReference users = FirebaseFirestore.instance
      .collection('stores/goyEoBspy0fCNUIgdPWE/products');

  List<QueryDocumentSnapshot> srchProds;
  List<QueryDocumentSnapshot> srchProdsTemp = [];
  TextEditingController ctrlSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorP,
      body: SafeArea(
        child: Column(
          children: [
            _top(),
            _center(),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 72,
        width: 72,
        margin: EdgeInsets.only(right: 10, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: colorP,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewProductPage()));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    child: Text(
                      "Productos",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage('assets/products.png'),
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        String qrCodeResult =
                            await FlutterBarcodeScanner.scanBarcode(
                                "#004d40", "Cancel", true, ScanMode.QR);
                        if (qrCodeResult != null) {
                          ProductGaf prod;
                          srchProds.forEach((element) {
                            if (element.id == qrCodeResult) {
                              prod = ProductGaf.map(element.data(),
                                  code: element.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewProductPage(
                                            data: prod.product,
                                          )));
                            }
                          });
                        }
                      },
                      customBorder: CircleBorder(),
                      child: Image(
                        image: AssetImage('assets/qrsec.png'),
                        height: 50,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: ctrlSearch,
                      onChanged: (value) {
                        isFirstView = false;
                        List<QueryDocumentSnapshot> temp = [];
                        srchProds.forEach((element) {
                          String sn = element.data()['nombre'];
                          String sm = element.data()['marca'];
                          bool insertProduct = false;
                          if (sn
                              .toLowerCase()
                              .startsWith(value.toLowerCase())) {
                            insertProduct = true;
                          }
                          if (sm
                              .toLowerCase()
                              .startsWith(value.toLowerCase())) {
                            insertProduct = true;
                          }
                          if (insertProduct) {
                            temp.add(element);
                          }
                        });
                        setState(() {
                          srchProdsTemp = temp;
                          temp = [];
                        });
                      },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isFirstView = true;
  Widget _center() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        child: Container(
          padding: EdgeInsets.only(top: 20),
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Text(
                    "Loading",
                    textAlign: TextAlign.center,
                  ),
                  width: double.infinity,
                );
              } else {
                srchProds = snapshot.data.docs;
                return ListView.builder(
                    padding: EdgeInsets.all(25),
                    itemCount:
                        isFirstView ? srchProds.length : srchProdsTemp.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map ds;
                      String id;
                      if (isFirstView) {
                        ds = srchProds[index].data();
                        id = srchProds[index].id;
                      } else {
                        ds = srchProdsTemp[index].data();
                        id = srchProdsTemp[index].id;
                      }
                      ds['code'] = id;
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewProductPage(
                                        data: ds,
                                      ))),
                          child: Product(
                              Colors.black87,
                              ProductGaf(
                                  ds['code'],
                                  ds['nombre'],
                                  ds['marca'],
                                  double.parse(ds['costo'].toString()),
                                  double.parse(ds['precio'].toString()),
                                  ds['tipo'],
                                  double.parse(ds['unidades'].toString()),
                                  ['s', 'sd'])),
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}
