class ProductGaf {
  Map product = Map();
  String code;
  String nombre;
  String marca;
  double costo;
  double precio;
  String tipo;
  double unidades;
  List<String> tags;
  ProductGaf.map(this.product, {this.code, this.unidades}) {
    if (code != null) {
      product['code'] = code;
    } else {
      code = product['code'];
    }
    nombre = product['nombre'];
    marca = product['marca'];
    costo = product['costo'];
    precio = product['precio'];
    tipo = product['tipo'];
    if (unidades != null) {
      product['unidades'] = unidades;
    } else {
      unidades = product['unidades'];
    }
    tags = product['tags'].split(',');
  }
  ProductGaf(this.code, this.nombre, this.marca, this.costo, this.precio,
      this.tipo, this.unidades, this.tags) {
    product['code'] = code;
    product['nombre'] = nombre;
    product['producto'] = marca;
    product['costo'] = costo;
    product['precio'] = precio;
    product['tipo'] = tipo;
    product['unidades'] = unidades;
    product['tags'] = tags;
  }
}
