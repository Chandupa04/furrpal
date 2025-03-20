import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'consts.dart';
import 'payment_home_ui.dart';

void main() async {
  // Setup Stripe before running the app
  await _setup();
  runApp(const MyApp());
}

Future<void> _setup() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe with publishable key
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Payment Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

