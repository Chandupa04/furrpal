import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:furrpal/constant/constant.dart';
import 'package:furrpal/custom/button_custom.dart';
import 'cart_page.dart';
import 'product_details_page.dart';

class Product {
  final String name;
  final String image;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 0,
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Product> products = [
    Product(
        name: "Dog Collar",
        image: "assets/images/dog_collar.jpg",
        price: 10.99),
    Product(
        name: "Pet Food Bowl", image: "assets/images/bowl.jpg", price: 5.99),
    Product(name: "Chew Toy", image: "assets/images/chew_toy.jpg", price: 8.99),
    Product(
        name: "Dog Shampoo", image: "assets/images/shampoo.jpg", price: 12.49),
    Product(
        name: "Dog Food", image: "assets/images/dog_food.jpg", price: 12.49),
    Product(
        name: "Dog Towel", image: "assets/images/dog_towel.jpg", price: 12.49),
    Product(
        name: "Dog Muzzle",
        image: "assets/images/dog_muzzle.jpg",
        price: 12.49),
    Product(
        name: "Dog Chain", image: "assets/images/dog_chain.jpg", price: 12.49),
    Product(
        name: "Dog Muzzle",
        image: "assets/images/dog_muzzle.jpg",
        price: 22.49),
  ];

  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      if (!cart.contains(product)) {
        cart.add(product);
      }
      product.quantity++;
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
    ).then((_) {
      setState(() {}); // Refresh the state after returning from cart
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.deepPurple,
        title: Text(
          "FurrPal Shop",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            // color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: navigateToCart,
            color: Colors.amberAccent,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ),
                );
              },
              child: Card(
                color: whiteColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Column(
                  children: [
                    Expanded(
                        child: Image.asset(product.image, fit: BoxFit.cover)),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        children: [
                          Text(product.name,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          Text("\$${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.green)),
                          ButtonCustom(
                            text: 'Add to Cart',
                            btnHeight: 30.h,
                            btnWidth: 140.w,
                            borderRadius: BorderRadius.circular(15.r),
                            // btnColor: ,
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: blackColor,
                            ),
                            callback: () {},
                          ),
                          // ElevatedButton(
                          //   onPressed: () => addToCart(product),
                          //   child: Text("Add to Cart"),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
