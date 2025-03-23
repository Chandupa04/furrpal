import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrderHistoryPage({super.key});

  Stream<QuerySnapshot> _getUserOrders(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order History')),
        body: const Center(
            child: Text('You must be logged in to view order history')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;
              final items = orderData['items'] as List<dynamic>;
              final timestamp = orderData['timestamp'] as Timestamp;

              double totalPrice = 0;
              for (final item in items) {
                final price = (item['price'] as num?)?.toDouble() ??
                    0.0; // Ensuring it's a double
                final quantity = item['quantity'] as int? ?? 1;
                totalPrice += price * quantity;
              }

              final formattedDate =
                  DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  title: Text('Order #${order.id}'),
                  subtitle:
                      Text('Total:  ${totalPrice.toStringAsFixed(2)} USD'),
                  trailing: Text(formattedDate),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Items:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...items.map((item) {
                            final price =
                                (item['price'] as num?)?.toDouble() ?? 0.0;
                            final quantity = item['quantity'] as int? ?? 1;
                            return ListTile(
                              leading: Image.network(
                                item['imageUrl'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item['name'] ?? 'No Name'),
                              subtitle: Text(' $price x $quantity USD'),
                              trailing: Text(
                                  ' ${(price * quantity).toStringAsFixed(2)} USD'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
