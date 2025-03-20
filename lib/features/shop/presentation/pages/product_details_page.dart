import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product['imageUrl'], height: 300, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('LKR ${product['price']}',
                style: TextStyle(fontSize: 20, color: Colors.green)),
            SizedBox(height: 16),
            Text('Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(product['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Reviews:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Add reviews here (you can fetch reviews from Firestore)
          ],
        ),
      ),
    );
  }
}
