import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/product.dart';
import 'package:shopping/providers/products.dart';
import 'package:shopping/widgets/badge.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;

  // ProductDetailScreen(this.title);
  static const routeName = '/productDetail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 500,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: loadedProduct.id,
                          child: Image.network(
                            loadedProduct.imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black54),
                            child: IconButton(
                              icon: Icon(
                                loadedProduct.isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                              ),
                              onPressed: () {
                                setState(() {
                                  loadedProduct.toggleFavouritesStatus(
                                      authData.token, authData.userId);
                                });
                              },
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          '\$${loadedProduct.price}',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text('Inclusive of all taxes'),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            cart.addItem(loadedProduct.id, loadedProduct.price,
                                loadedProduct.title, loadedProduct.imageUrl);
                          },
                          color: Colors.amber[700],
                          child: Text(
                            'Add to cart',
                            style: TextStyle(fontSize: 20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'About this item',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          loadedProduct.description,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
