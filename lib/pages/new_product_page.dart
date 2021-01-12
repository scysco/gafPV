import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class NewProductPage extends StatefulWidget {
  final Map data;
  NewProductPage({this.data});
  @override
  _NewProductPageState createState() => _NewProductPageState(data: data);
}

class _NewProductPageState extends State<NewProductPage> {
  final Color colorP = Color.fromARGB(255, 0, 77, 64);

  final ctrlCode = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlBrand = TextEditingController();
  final ctrlType = TextEditingController();
  final ctrlCost = TextEditingController();
  final ctrlPrice = TextEditingController();
  final ctrlUnits = TextEditingController();
  final ctrlTags = TextEditingController();
  CollectionReference products = FirebaseFirestore.instance
      .collection('stores/goyEoBspy0fCNUIgdPWE/products');

  Map data;

  _NewProductPageState({this.data});

  @override
  void initState() {
    super.initState();
    if (data != null) {
      ctrlCode.text = data['id'];
      ctrlName.text = data['nombre'];
      ctrlBrand.text = data['marca'];
      ctrlType.text = data['tipo'];
      ctrlCost.text = data['costo'].toString();
      ctrlPrice.text = data['precio'].toString();
      ctrlUnits.text = data['unidades'].toString();
      ctrlTags.text = data['tags'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
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
    if (isFilled()) {
      return products
          .doc(ctrlCode.text)
          .set({
            'nombre': ctrlName.text,
            'marca': ctrlBrand.text,
            'tipo': ctrlType.text,
            'costo': double.parse(ctrlCost.text),
            'precio': double.parse(ctrlPrice.text),
            'unidades': double.parse(ctrlUnits.text),
            'tags': ctrlTags.text,
          })
          .then((value) => Navigator.pop(context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }))
          .catchError((error) => print("*** Failed to add user: $error"));
    } else {
      setState(() {
        _isLoading = false;
      });
      return null;
    }
  }

  bool isFilled() {
    bool isfill = true;
    if (ctrlCode.text == null || ctrlCode.text == '' || ctrlCode.text == '-1') {
      isfill = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Codigo de barras no valido"),
      ));
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
    if (ctrlType.text == null || ctrlType.text == '') {
      if (isfill) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Falta el tipo de producto"),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Define cuantas unidades existen"),
        ));
      }
      isfill = false;
    }
    if (ctrlTags.text == null || ctrlTags.text == '') {
      if (isfill) {
        ctrlTags.text = '';
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

  Widget _center(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [
            TextField(
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Costo',
                  helperText: 'Costo unitario del producto',
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
                labelText: 'Precio',
                helperText: 'Precio unitario del producto',
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
                labelText: 'Unidades',
                helperText: 'Cantidad de productos',
                icon: Icon(Icons.assignment),
              ),
              controller: ctrlUnits,
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
    if (qrCodeResult != null)
      setState(() {
        ctrlCode.text = qrCodeResult;
      });
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
          .catchError((error) => print("*** Failed to add user: $error"));
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
