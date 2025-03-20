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

  // Override == operator to compare products by name
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.name == name;
  }

  // Override hashCode to match the == operator
  @override
  int get hashCode => name.hashCode;
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
        name: "Dog Food Bowl",
        image: "assets/images/food_bowl.jpg",
        price: 17.49),
    Product(
        name: "Male Dog Diapers",
        image: "assets/images/diapers.jpg",
        price: 23.49),
    Product(
        name: "Dog Hair Brush",
        image: "assets/images/dog_hair.jpg",
        price: 17.49),
    Product(
        name: "Female Dog Diapers",
        image: "assets/images/diapersg.jpg",
        price: 16.00),
    Product(name: "Dog Toys", image: "assets/images/toys.jpg", price: 8.59),
    Product(
        name: "Pet Nails Cutter",
        image: "assets/images/pet_nail.jpg",
        price: 6.29),
    Product(
        name: "Pet Poop Scooper With Poop Wast Bag",
        image: "assets/images/poop.jpg",
        price: 15.59),
    Product(
        name: "Pet Carrier Basket",
        image: "assets/images/pet_carrier.jpg",
        price: 5.59),
  ];

  List<Product> cart = [];
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts =
        List.from(products); // Initialize filteredProducts with all products
  }

  void addToCart(Product product) {
    setState(() {
      // Check if the product already exists in the cart
      final existingProductIndex = cart.indexWhere((p) => p == product);

      if (existingProductIndex != -1) {
        // If the product exists, increase its quantity
        cart[existingProductIndex].quantity++;
      } else {
        // If the product doesn't exist, add it to the cart with quantity 1
        cart.add(Product(
          name: product.name,
          image: product.image,
          price: product.price,
          quantity: 1,
        ));
      }
    });

    // Show a SnackBar to confirm the item was added to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart!"),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
        behavior:
            SnackBarBehavior.floating, // Optional: Makes the SnackBar float
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            // Optional: Undo the action
            setState(() {
              final existingProductIndex = cart.indexWhere((p) => p == product);
              if (existingProductIndex != -1) {
                if (cart[existingProductIndex].quantity > 1) {
                  cart[existingProductIndex].quantity--;
                } else {
                  cart.removeAt(existingProductIndex);
                }
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${product.name} removed from cart"),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
    ).then((_) {
      setState(() {}); // Refresh the state after returning from cart
    });
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all products
        filteredProducts = List.from(products);
      } else {
        // Filter products based on the search query
        filteredProducts = products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF88158),
        elevation: 0,
        leading: const SizedBox(width: 0), // Remove leading space
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "FurrPal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: navigateToCart,
            color: Colors.yellowAccent,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: filterProducts,
            ),
          ),
        ),
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
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
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
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.bold)),
                          Text("\$${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                          ButtonCustom(
                            text: 'Add to Cart',
                            btnHeight: 30.h,
                            btnWidth: 140.w,
                            borderRadius: BorderRadius.circular(15.r),
                            textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: blackColor,
                            ),
                            callback: () => addToCart(product),
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
