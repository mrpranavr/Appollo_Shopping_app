import 'package:flutter/material.dart';
import 'package:shopping/providers/orders.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItems extends StatefulWidget {
  final OrderItem order;

  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 300, 400) : 110,
      child: Card(
        elevation: 8,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy -  hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            Divider(
              color: Colors.black45,
              thickness: 2,
            ),
            // if (_expanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 180, 300)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 75,
                                width: 100,
                                child: Image.network(
                                  prod.imageUrl,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              VerticalDivider(
                                thickness: 2,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.black45,
                              ),
                              Container(
                                width: 100,
                                child: Text(
                                  prod.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 100,
                                child: Text(
                                  '${prod.quantity}x \$${prod.price}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
