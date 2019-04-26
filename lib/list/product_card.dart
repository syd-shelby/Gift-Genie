import 'package:flutter/material.dart';
import 'package:gift_genie/list/product.dart';

import 'package:gift_genie/list/product_title.dart';
import 'package:gift_genie/list/detail.dart';
import 'package:gift_genie/list/product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;

  ProductCard(
      {@required this.product,
        @required this.inFavorites,
        @required this.onFavoriteButtonPressed});

  @override
  Widget build(BuildContext context) {
    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => onFavoriteButtonPressed(product.id),
        child: Icon(
          // Conditional expression:
          // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
          inFavorites == true ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        fillColor: Theme.of(context).buttonColor,
        shape: CircleBorder(),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new DetailScreen(product, inFavorites),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
              Stack(
                children: <Widget>[
                  ProductImage(product.imageURL),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              ProductTitle(product, 15),
            ],
          ),
        ),
      ),
    );
  }
}