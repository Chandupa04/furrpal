import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furrpal/app_data.dart';
import 'package:furrpal/firebase_options.dart';
import 'stripe_payment_page/consts.dart'; // Import the file with your Stripe keys

void main() async {
  try {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Stripe - this must be done before Firebase
    Stripe.publishableKey = stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.com.furrpal.furrpal'; // Add this for Apple Pay support
    await Stripe.instance.applySettings(); // Uncomment this line - it's critical!

    // Initialize Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Run app
    runApp(MyApp());
  } catch (e) {
    print('Error during initialization: $e');
    // Still try to run the app even if there was an error
    runApp(MyApp());
  }
}