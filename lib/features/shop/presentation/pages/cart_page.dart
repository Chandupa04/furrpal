import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shop_page.dart';
import 'order_details_page.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;

  const CartPage({Key? key, required this.cart}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(Product product) {
    setState(() {
      product.quantity--;
      if (product.quantity <= 0) {
        widget.cart.remove(product);
      }
    });
  }

  void navigateToOrderDetails() {
    if (widget.cart.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailsPage(cart: widget.cart)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        widget.cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart", style: TextStyle(fontSize: 22.sp)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: widget.cart.isEmpty
            ? Center(
                child: Text("Your cart is empty!",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold)),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final product = widget.cart[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5.h),
                          child: ListTile(
                            leading: Image.asset(product.image,
                                width: 50.w, height: 50.h),
                            title: Text(product.name,
                                style: TextStyle(fontSize: 18.sp)),
                            subtitle: Text("Quantity: ${product.quantity}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "\$${(product.price * product.quantity).toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.green)),
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () => removeFromCart(product),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(thickness: 2),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.cart.isNotEmpty
                          ? navigateToOrderDetails
                          : null,
                      child: Text("Proceed to Checkout"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
