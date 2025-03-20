import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../consts.dart';

class StripeService {
  // Private constructor for Singleton pattern
  StripeService._();

  // Singleton instance
  static final StripeService instance = StripeService._();

  // Dio instance for HTTP requests
  final Dio _dio = Dio();

  // Make payment function
  Future<bool> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      // Create payment intent
      final String? paymentIntentClientSecret = await _createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      // Check if payment intent creation was successful
      if (paymentIntentClientSecret == null) {
        print('Failed to create payment intent');
        return false;
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'FurrPal',
          // You can customize appearance, enable Google Pay/Apple Pay, etc. here
        ),
      );

      // Present payment sheet to user
      return await _processPayment();
    } catch (error) {
      print('Error making payment: $error');
      return false;
    }
  }

  // Process payment function
  Future<bool> _processPayment() async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      print('Payment sheet presented successfully');

      // Confirm the payment
      await Stripe.instance.confirmPaymentSheetPayment();
      print('Payment confirmed successfully');

      print('Payment successful! Returning true');
      return true; // Payment was successful
    } catch (error) {
      print('Error processing payment: $error');
      return false; // Payment failed
    }
  }

  // Create payment intent function
  // WARNING: In production, this should be done on your server, not in client code
  Future<String?> _createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      // Prepare data for the request
      final Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
      };

      // Send request to Stripe API
      final Response response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      // Check if response contains data
      if (response.data != null) {
        return response.data['client_secret'];
      }

      return null;
    } catch (error) {
      print('Error creating payment intent: $error');
      return null;
    }
  }

  // Calculate amount in cents
  String _calculateAmount(double amount) {
    // Stripe requires amount in cents
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}

