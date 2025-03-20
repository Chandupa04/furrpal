import 'package:flutter/material.dart';
import 'services/stripe_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Amount to charge (in dollars)
  final double paymentAmount = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment Demo'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total Amount: \$${paymentAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text(
                'Purchase',
                style: TextStyle(fontSize: 18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onPressed: () async {
                // Process payment when button is clicked
                await StripeService.instance.makePayment(
                  amount: paymentAmount,
                  currency: 'USD',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

