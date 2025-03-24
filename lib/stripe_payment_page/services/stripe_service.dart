import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart';
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

      // Initialize payment sheet with more detailed configuration
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'FurrPal',
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFFF9A035),
              background: Colors.white,
              componentBackground: Colors.white,
              primaryText: Colors.black,
              secondaryText: Colors.grey,
              componentText: Colors.black,
            ),
            shapes: PaymentSheetShape(
              borderRadius: 12.0,
              borderWidth: 1.0,
            ),
          ),
          billingDetails: const BillingDetails(
            name: 'FurrPal User',
          ),
          returnURL: 'flutterstripe://redirect',
          allowsDelayedPaymentMethods: true,
        ),
      );

      // Present payment sheet to user
      return await _processPayment();
    } catch (error) {
      print('Error making payment: $error');
      if (error is StripeException) {
        print('Stripe error code: ${error.error.code}');
        print('Stripe error message: ${error.error.message}');
        print('Stripe error localizedMessage: ${error.error.localizedMessage}');
      }
      return false;
    }
  }

  // Process payment function
  Future<bool> _processPayment() async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
      print('Payment successful! Returning true');
      return true; // Payment was successful
    } on Exception catch (error) {
      print('Error processing payment: $error');
      if (error is StripeException) {
        print('Stripe error code: ${error.error.code}');
        print('Stripe error message: ${error.error.message}');
        print('Stripe error localizedMessage: ${error.error.localizedMessage}');
      }
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
        'payment_method_types[]': 'card',
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
        print('Payment intent created successfully');
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