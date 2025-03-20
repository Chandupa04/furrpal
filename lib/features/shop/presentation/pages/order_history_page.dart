import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderHistoryPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? userId = _auth.currentUser?.uid; // Get the user ID

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Order History')),
        body:
            Center(child: Text('You must be logged in to view order history')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(userId)
            .collection('orders')
            .orderBy('timestamp', descending: true) // Sort by latest orders
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;
              final items = orderData['items'] as List<dynamic>;
              final timestamp = orderData['timestamp'] as Timestamp;

              // Calculate total price
              double totalPrice = 0;
              for (final item in items) {
                final price = item['price'] as int? ?? 0; // Handle null price
                final quantity =
                    item['quantity'] as int? ?? 1; // Handle null quantity
                totalPrice += price * quantity;
              }

              // Format the timestamp
              final formattedDate =
                  DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text('Total: LKR ${totalPrice.toStringAsFixed(2)}'),
                  trailing: Text(formattedDate),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...items.map((item) {
                            final price =
                                item['price'] as int? ?? 0; // Handle null price
                            final quantity = item['quantity'] as int? ??
                                1; // Handle null quantity
                            return ListTile(
                              leading: Image.network(
                                item['imageUrl'] ?? '', // Handle null imageUrl
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item['name'] ??
                                  'No Name'), // Handle null name
                              subtitle: Text('LKR $price x $quantity'),
                              trailing: Text(
                                  'LKR ${(price * quantity).toStringAsFixed(2)}'),
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
