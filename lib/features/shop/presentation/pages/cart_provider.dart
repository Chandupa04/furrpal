import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _userId;

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Set the user ID and load the cart from Firestore
  void setUserId(String userId) {
    print('Setting userId: $userId'); // Debugging
    _userId = userId;
    _loadCartFromFirestore();
  }

  // Reset the cart (call this on logout)
  void reset() {
    _cartItems.clear();
    _userId = null;
    notifyListeners();
  }

  // Load cart items from Firestore
  Future<void> _loadCartFromFirestore() async {
    if (_userId == null) return;

    final userDoc = await _firestore.collection('users').doc(_userId).get();
    if (userDoc.exists) {
      _cartItems = List<Map<String, dynamic>>.from(userDoc['cart'] ?? []);
      notifyListeners();
    }
  }

  // Add item to cart and update Firestore
  void addToCart(Map<String, dynamic> product) async {
    final existingIndex =
        _cartItems.indexWhere((item) => item['name'] == product['name']);
    if (existingIndex >= 0) {
      _cartItems[existingIndex]['quantity'] += 1; // Increase quantity
    } else {
      product['quantity'] = 1; // Add new product with quantity 1
      _cartItems.add(product);
    }
    notifyListeners();
    await _updateCartInFirestore();
  }

  // Remove item from cart and update Firestore
  void removeFromCart(int index) async {
    _cartItems.removeAt(index);
    notifyListeners();
    await _updateCartInFirestore();
  }

  // Update item quantity in cart and update Firestore
  void updateQuantity(int index, int quantity) async {
    if (quantity > 0) {
      _cartItems[index]['quantity'] = quantity;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
    await _updateCartInFirestore();
  }

  // Clear cart and update Firestore
  void clearCart() async {
    _cartItems.clear();
    notifyListeners();
    await _updateCartInFirestore();
  }

  // Place an order and clear the cart
  Future<void> placeOrder() async {
    if (_userId == null) return;

    // Create an order document
    final order = {
      'items': _cartItems,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save the order to the user's orders subcollection
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('orders')
        .add(order);

    // Clear the cart after placing the order
    clearCart();
  }

  // Update the cart in Firestore
  Future<void> _updateCartInFirestore() async {
    if (_userId == null) return;

    await _firestore.collection('users').doc(_userId).update({
      'cart': _cartItems,
    });
  }
}
