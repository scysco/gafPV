class ReportSaleGaf {
  Map<String, dynamic> report = Map();
  String code;
  String nombre;
  String marca;
  double costo;
  double precio;
  double ganancia;
  int year;
  int month;
  int day;
  int hour;
  int minutes;
  String employ;
  ReportSaleGaf(
      this.code,
      this.nombre,
      this.marca,
      this.costo,
      this.precio,
      this.ganancia,
      this.year,
      this.month,
      this.day,
      this.hour,
      this.minutes,
      this.employ) {
    report['code'] = code;
    report['nombre'] = nombre;
    report['marca'] = marca;
    report['costo'] = costo;
    report['precio'] = precio;
    report['ganancia'] = ganancia;
    report['employ'] = employ;
    report['year'] = year;
    report['month'] = month;
    report['day'] = day;
    report['hour'] = hour;
    report['minutes'] = minutes;
  }
  ReportSaleGaf.map(this.report) {
    code = report['code'];
    nombre = report['nombre'];
    marca = report['marca'];
    costo = report['costo'];
    precio = report['precio'];
    ganancia = report['ganancia'];
    employ = report['employ'];
    year = report['year'];
    month = report['month'];
    hour = report['hour'];
    minutes = report['minutes'];
    day = report['day'];
  }
}
