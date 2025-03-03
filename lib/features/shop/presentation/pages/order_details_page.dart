import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'shop_page.dart';

class OrderDetailsPage extends StatelessWidget {
  final List<Product> cart;

  const OrderDetailsPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details", style: TextStyle(fontSize: 20.sp)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Items in Order",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final product = cart[index];
                  return ListTile(
                    leading:
                        Image.asset(product.image, width: 50.w, height: 50.h),
                    title:
                        Text(product.name, style: TextStyle(fontSize: 18.sp)),
                    subtitle: Text("Quantity: ${product.quantity}"),
                    trailing: Text(
                        "\$${(product.price * product.quantity).toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 18.sp, color: Colors.green)),
                  );
                },
              ),
            ),
            Divider(thickness: 2),
            Text("Total: \$${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
