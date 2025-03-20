import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product['imageUrl'], height: 300, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(product['name'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('LKR ${product['price']}',
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 16),
            const Text('Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(product['description'], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Reviews:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Add reviews here (you can fetch reviews from Firestore)
          ],
        ),
      ),
    );
  }
}
