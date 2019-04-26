import 'package:flutter/material.dart';
import 'package:gift_genie/list/product.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final double padding;

  ProductTitle(this.product, this.padding);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Text(
            product.name,
            style: Theme
                .of(context)
                .textTheme
                .title,
          ),
          // Empty space:
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.monetization_on, size: 20.0),
              SizedBox(width: 5.0),
              Text(
                product.price,
                style: Theme
                    .of(context)
                    .textTheme
                    .caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}