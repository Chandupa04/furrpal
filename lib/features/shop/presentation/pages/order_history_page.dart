import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: Text(
          'Order History',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyOrdersView();
          }

          final orders = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) =>
                _buildOrderCard(context, orders[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyOrdersView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 70, color: Colors.grey[500]),
          SizedBox(height: 16.h),
          Text(
            "No orders found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Your order history will appear here",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, DocumentSnapshot order) {
    final orderData = order.data() as Map<String, dynamic>;
    final items = orderData['items'] as List<dynamic>;
    final timestamp = orderData['timestamp'] as Timestamp;
    final formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());

    // Calculate total price once
    double totalPrice = _calculateTotalPrice(items);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ExpansionTile(
        title: Text(
          'Order #${order.id.substring(0, 8)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${totalPrice.toStringAsFixed(2)} USD',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              formattedDate,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        children: [
          _buildOrderItems(items),
        ],
      ),
    );
  }

  double _calculateTotalPrice(List<dynamic> items) {
    double total = 0;
    for (final item in items) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = item['quantity'] as int? ?? 1;
      total += price * quantity;
    }
    return total;
  }

  Widget _buildOrderItems(List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            'Items',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) => _buildOrderItem(items[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final quantity = item['quantity'] as int? ?? 1;
    final itemTotal = price * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item['imageUrl'] ?? '',
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60.w,
                height: 60.h,
                color: Colors.grey[200],
                child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${price.toStringAsFixed(2)} × $quantity USD',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Item total
          Text(
            ' ${itemTotal.toStringAsFixed(2)} USD',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
