import 'package:flutter/material.dart';
import 'order_details_page.dart';
import 'shop_page.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
      } else {
        widget.cart.remove(product);
      }
    });
  }

  void navigateToOrderDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderDetailsPage(cart: widget.cart)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        widget.cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.deepPurple,
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final product = widget.cart[index];
                      return ListTile(
                        leading:
                            Image.asset(product.image, width: 50, height: 50),
                        title: Text(product.name),
                        subtitle: Text(
                            "\$${product.price.toStringAsFixed(2)} x ${product.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () => removeFromCart(product),
                              color: Colors.red,
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle),
                              onPressed: () {
                                setState(() {
                                  product.quantity++;
                                });
                              },
                              color: Colors.green,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: navigateToOrderDetails,
                        child: Text("Proceed to Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
