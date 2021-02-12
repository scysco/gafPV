import 'package:flutter/material.dart';
import 'package:gafemp/model/product_gaf.dart';

class Product extends StatelessWidget {
  final ProductGaf product;
  final Color color;

  Product(this.color, this.product);
  @override
  Widget build(BuildContext context) {
    print("**" + MediaQuery.of(context).size.width.toString());
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.marca ?? 'default value',
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .5,
                child: Text(
                  product.nombre ?? 'default value',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product.unidades.toString() ?? 'default value' + ' X',
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                '\$' + product.precio.toString() ?? 'default value',
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
