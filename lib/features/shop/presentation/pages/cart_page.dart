import 'package:flutter/material.dart';
import 'order_details_page.dart';
import 'shop_page.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;

  const CartPage({super.key, required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Product product) async {
    bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Remove Item"),
              content: Text("Are you sure you want to remove ${product.name}?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child:
                      const Text("Remove", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      setState(() {
        if (product.quantity > 1) {
          product.quantity--;
        } else {
          widget.cart.remove(product);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} removed from cart"),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void addToCart(Product product) {
    setState(() {
      product.quantity++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} quantity increased"),
        duration: const Duration(seconds: 1),
      ),
    );
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
        title: const Text("Your Cart"),
        backgroundColor: Colors.deepPurple,
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Continue Shopping"),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Cart items list
                  ListView.separated(
                    shrinkWrap:
                        true, // This makes the ListView occupy only necessary space
                    itemCount: widget.cart.length,
                    separatorBuilder: (context, index) =>
                        const Divider(thickness: 1),
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
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => removeFromCart(product),
                              color: Colors.red,
                            ),
                            Text("${product.quantity}",
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () => addToCart(product),
                              color: Colors.green,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Total Price with highlighted style
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.amber, width: 2),
                          ),
                          child: Text(
                            "Total: \$${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // Floating Action Button for Checkout
      floatingActionButton: widget.cart.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 80), // Adjust for FAB
              child: FloatingActionButton.extended(
                onPressed: navigateToOrderDetails,
                label: const Text("Checkout"),
                icon: const Icon(Icons.shopping_cart),
                backgroundColor: Colors.deepPurple,
              ),
            ),
    );
  }
}
