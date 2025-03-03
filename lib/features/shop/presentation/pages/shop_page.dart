import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        name: "Dog Feeder",
        image: "assets/images/dog_feeder.jpg",
        price: 15.50),
    Product(
        name: "Dog Snacks", image: "assets/images/dog_snack.jpg", price: 20.50),
    Product(
        name: "Dog Food Bowl",
        image: "assets/images/food_bowl.jpg",
        price: 17.50),
    Product(
        name: "Pet Diapers",
        image: "assets/images/pet_diapers.jpg",
        price: 10.50),
    Product(
        name: "Pet Hair Remover",
        image: "assets/images/dog_hair.jpg",
        price: 10.50),
    Product(
        name: "Retractable Elastic Pet Leash Car Seat Safety Belt for Dogs",
        image: "assets/images/Retractable_Elastic.jpg",
        price: 10.50),
    Product(
        name: "Diapers for Female Dogs",
        image: "assets/images/diapersg.jpg",
        price: 7.50),
    Product(
        name: "Diapers for Male Dogs",
        image: "assets/images/diapers.jpg",
        price: 7.50),
    Product(name: "Dogs Beds", image: "assets/images/bed.jpg", price: 12.60),
    Product(name: "Dog Toys", image: "assets/images/toys.jpg", price: 3.50),
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
        backgroundColor: Colors.deepPurple,
        title: Text("FurrPal Shop",
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
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
                          ElevatedButton(
                            onPressed: () => addToCart(product),
                            child: Text("Add to Cart"),
                          ),
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
