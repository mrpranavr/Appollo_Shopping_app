import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure ?',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            content: Text('Do you want to remove the item from the cart ?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        // child: Padding(
        //   padding: EdgeInsets.all(8),
        //   child: ListTile(
        //     horizontalTitleGap: 1,
        //     leading: CircleAvatar(
        //       radius: 40,
        //       child: Padding(
        //           padding: EdgeInsets.all(5),
        //           child: FittedBox(child: Text('\$$price'))),
        //     ),
        //     title: Text(title),
        //     subtitle: Text('Total: \$${(price * quantity)}'),
        //     trailing: Text('$quantity x'),
        //   ),
        // ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Container(
            height: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
                VerticalDivider(
                  color: Colors.black38,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w900),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Price: $price'),
                          SizedBox(
                            height: 8,
                          ),
                          Text('Quantity: $quantity'),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      Container(
                        child: Chip(
                          backgroundColor: Theme.of(context).primaryColor,
                          label: Text(
                            'Total: \$${(price * quantity)}',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .title
                                    .color),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
