import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furrpal/app_data.dart';
import 'package:furrpal/firebase_options.dart';
import 'stripe_payment_page/consts.dart'; // Import the file with your Stripe keys

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Stripe
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.com.furrpal'; // Replace with your merchant identifier if using Apple Pay
  await Stripe.instance.applySettings();

  // Run app
  runApp(MyApp());
}
 
