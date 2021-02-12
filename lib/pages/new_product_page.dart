import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gafemp/model/user_gaf.dart';

class NewProductPage extends StatefulWidget {
  final Map data;
  final String code;
  final UserGaf user;
  NewProductPage(this.user, {this.data, this.code});
  @override
  _NewProductPageState createState() =>
      _NewProductPageState(user, data: data, code: code);
}

class _NewProductPageState extends State<NewProductPage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);

  final ctrlCode = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlBrand = TextEditingController();
  final ctrlType = TextEditingController();
  final ctrlCost = TextEditingController();
  final ctrlPrice = TextEditingController();
  final ctrlUnitsPP = TextEditingController();
  final ctrlPriceUnit = TextEditingController();
  final ctrlUnits = TextEditingController();
  final ctrlTags = TextEditingController();
  CollectionReference products;

  Map data;
  UserGaf user;
  String store;
  String code;

  _NewProductPageState(this.user, {this.data, this.code});

  @override
  void initState() {
    super.initState();
    if (code != null) {
      ctrlCode.text = code;
    }
    if (data != null) {
      ctrlCode.text = data['code'];
      ctrlName.text = data['nombre'];
      ctrlBrand.text = data['marca'];
      ctrlType.text = data['tipo'];
      ctrlCost.text = data['costo'].toString();
      ctrlPrice.text = data['precio'].toString();
      ctrlUnits.text =
          data['unidades'] != null ? data['unidades'].toString() : '';
      ctrlPriceUnit.text =
          data['priceUnit'] != null ? data['priceUnit'].toString() : '';
      ctrlUnitsPP.text =
          data['unitsPP'] != null ? data['unitsPP'].toString() : '';
      ctrlTags.text = data['tags'];
    }
    store = user.stores;
    products = FirebaseFirestore.instance.collection('stores/$store/products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _top(),
                _center(context),
              ],
            ),
          ),
          _crearLoading(),
        ],
      ),
      floatingActionButton: flButtons(context),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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

  Future<void> addProducts(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> producto = {
      'nombre': ctrlName.text,
      'marca': ctrlBrand.text,
      'tipo': ctrlType.text,
      'costo': double.parse(ctrlCost.text),
      'precio': double.parse(ctrlPrice.text),
      'unidades': ctrlUnits.text != '' ? double.parse(ctrlUnits.text) : null,
      'priceUnit':
          ctrlPriceUnit.text != '' ? double.parse(ctrlPriceUnit.text) : null,
      'unitsPP': ctrlUnitsPP.text != '' ? double.parse(ctrlUnitsPP.text) : null,
      'tags': ctrlTags.text,
    };
    if (isFilled()) {
      if (genId) {
        return products
            .add(producto)
            .then((value) => Navigator.pop(context))
            .whenComplete(() => setState(() {
                  _isLoading = false;
                }))
            .catchError((error) => print("*** Failed to add user: $error"));
      } else {
        return products
            .doc(ctrlCode.text)
            .set(producto)
            .then((value) => Navigator.pop(context))
            .whenComplete(() => setState(() {
                  _isLoading = false;
                }))
            .catchError((error) => print("*** Failed to add user: $error"));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  bool genId = false;
  bool isFilled() {
    bool isfill = true;
    if (ctrlCode.text == null || ctrlCode.text == '' || ctrlCode.text == '-1') {
      genId = true;
    }
    if (ctrlName.text == null || ctrlName.text == '') {
      if (isfill) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falta el nombre del producto"),
        ));
      }
      isfill = false;
    }
    if (ctrlBrand.text == null || ctrlBrand.text == '') {
      if (isfill) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falta el nombre de la marca"),
        ));
      }
      isfill = false;
    }
    if (ctrlCost.text == null || ctrlCost.text == '') {
      if (isfill) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falta el costo del producto"),
        ));
      }
      isfill = false;
    }
    if (ctrlPrice.text == null || ctrlPrice.text == '') {
      if (isfill) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falta el precio del producto"),
        ));
      }
      isfill = false;
    }
    if (ctrlUnits.text == null || ctrlUnits.text == '') {
      if (isfill) {
        ctrlUnits.text = '';
      }
    }

    if (ctrlType.text == null || ctrlType.text == '') {
      if (isfill) {
        ctrlType.text = '';
      }
    }
    if (ctrlTags.text == null || ctrlTags.text == '') {
      if (isfill) {
        ctrlTags.text = '';
      }
    }
    if (ctrlUnitsPP.text == null || ctrlUnitsPP.text == '') {
      if (isfill) {
        ctrlUnitsPP.text = '';
      }
    }
    if (ctrlPriceUnit.text == null || ctrlPriceUnit.text == '') {
      if (isfill) {
        ctrlPriceUnit.text = '';
      }
    }
    return isfill;
  }

  Widget _top() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 40,
        left: 20,
        bottom: 20,
      ),
      child: Text(
        'Nuevo Producto',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  String helperText2 = 'Cantidad de productos';
  String labelText2 = 'Unidades';

  String labelText3 = 'Precio';
  String helperText3 = 'Precio del producto o paquete';

  Widget _center(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [
            Material(
              child: InkWell(
                child: TextField(
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Codigo del producto',
                    helperText: 'Presiona para Escanear',
                    suffixIcon: Icon(Icons.qr_code),
                    icon: Icon(Icons.qr_code_scanner),
                  ),
                  controller: ctrlCode,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _scanCode();
                  },
                ),
                onTapCancel: () {
                  print(ctrlCode.text);
                  print(ctrlName.text);
                },
                onDoubleTap: () {
                  setState(() {
                    ctrlCode.text = '';
                  });
                },
              ),
            ),
            Divider(),
            TextField(
              // autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Ejemplo: Refresco 600ml',
                labelText: 'Nombre del producto',
                helperText: 'Solo es el nombre',
                icon: Icon(Icons.local_offer),
              ),
              controller: ctrlName,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Ejemplo: Coca Cola',
                labelText: 'Marca',
                helperText: 'Solo es la marca',
                icon: Icon(Icons.branding_watermark),
              ),
              controller: ctrlBrand,
            ),
            Divider(),
            TextField(
                // autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Costo',
                  helperText: 'Costo del producto o paquete',
                  icon: Icon(Icons.monetization_on),
                ),
                controller: ctrlCost),
            Divider(),
            TextField(
              // autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: labelText3,
                helperText: helperText3,
                labelStyle: TextStyle(
                    color: labelText3 == 'Precio' ? Colors.black : Colors.blue),
                icon: Icon(Icons.attach_money),
              ),
              controller: ctrlPrice,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: labelText2,
                helperText: helperText2,
                labelStyle: TextStyle(
                    color:
                        labelText2 == 'Unidades' ? Colors.black : Colors.blue),
                icon: Icon(Icons.assignment),
              ),
              controller: ctrlUnits,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              keyboardType: TextInputType.number,
              onChanged: (txt) {
                if (txt != '') {
                  setState(() {
                    labelText2 = 'Unidades Totales';
                    helperText2 = 'Todas las unidades existentes';
                    labelText3 = 'Precio por Paquete';
                    helperText3 = 'Precio que tendria cada paquete';
                  });
                } else {
                  setState(() {
                    labelText2 = 'Unidades';
                    helperText2 = 'Cantidad de productos';
                    labelText3 = 'Precio';
                    helperText3 = 'Precio del producto o paquete';
                  });
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Precio por unidad',
                helperText: 'Dejar vacio si no aplica',
                icon: Icon(Icons.attach_money),
              ),
              controller: ctrlPriceUnit,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Unidades por paquete',
                helperText: 'Dejar vacio si no aplica',
                icon: Icon(Icons.app_registration),
              ),
              controller: ctrlUnitsPP,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'Ejemplo: Bebidas',
                labelText: 'Tipo',
                icon: Icon(Icons.sort),
              ),
              controller: ctrlType,
            ),
            Divider(),
            TextField(
              // autofocus: true,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Etiquetas',
                hintText: 'cocquita,coke',
                helperText: 'Separa por una coma',
                icon: Icon(Icons.widgets),
              ),
              controller: ctrlTags,
            ),
            SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scanCode() async {
    qrCodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#004d40", "Cancel", true, ScanMode.QR);
    if (qrCodeResult != null) {
      if (qrCodeResult != "-1") {
        setState(() {
          ctrlCode.text = qrCodeResult;
        });
      }
    }
  }

  String qrCodeResult;

  Future<void> delProduct(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    if (isFilled()) {
      return products
          .doc(ctrlCode.text)
          .delete()
          .then((value) => Navigator.pop(context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }))
          .catchError((error) => print("*** Failed to delete user: $error"));
    } else {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  flButtons(BuildContext context) {
    if (data == null) {
      return Container(
        height: 72,
        width: 72,
        margin: EdgeInsets.only(right: 10, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: colorP,
          child: Icon(Icons.cloud_upload),
          onPressed: () {
            addProducts(context);
          },
        ),
      );
    } else {
      return Container(
        height: 72,
        width: 174,
        margin: EdgeInsets.only(right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.delete),
                onPressed: () {
                  delProduct(context);
                },
                heroTag: null,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              width: 72,
              height: 72,
              child: FloatingActionButton(
                backgroundColor: colorP,
                child: Icon(Icons.cloud_upload),
                onPressed: () {
                  addProducts(context);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
