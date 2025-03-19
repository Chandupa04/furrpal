

import 'package:flutter/material.dart';

class PricingPlansScreen extends StatefulWidget {
  const PricingPlansScreen({Key? key}) : super(key: key);

  @override
  State<PricingPlansScreen> createState() => _PricingPlansScreenState();
}

class _PricingPlansScreenState extends State<PricingPlansScreen> {
  bool isAnnual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Choose Your Plan',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the perfect subscription that fits your needs',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Billing toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Monthly',
                      style: TextStyle(
                        fontWeight: !isAnnual ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: isAnnual,
                      onChanged: (value) {
                        setState(() {
                          isAnnual = value;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Annual',
                      style: TextStyle(
                        fontWeight: isAnnual ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'Save 16%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Pricing plans
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPlanCard(
                      name: 'Basic',
                      price: 0.0,
                      description: 'Free plan with limited likes',
                      color: Colors.grey[600]!,
                      features: const [
                        {'name': '6 free likes per month', 'included': true},
                        {'name': 'Basic profile access', 'included': true},
                        {'name': 'No premium filters', 'included': false},
                        {'name': 'No priority matching', 'included': false},
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(
                      name: 'Paw Lover',
                      price: 9.99,
                      description: 'More likes and better matches',
                      color: Colors.brown[400]!,
                      features: const [
                        {'name': '50 likes per month', 'included': true},
                        {'name': 'Advanced profile filters', 'included': true},
                        {'name': 'Priority matching', 'included': false},
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(
                      name: 'Top Dog',
                      price: 19.99,
                      description: 'Premium matchmaking experience',
                      color: Colors.amber[500]!,
                      isPopular: true,
                      features: const [
                        {'name': 'Unlimited likes', 'included': true},
                        {'name': 'Premium profile visibility', 'included': true},
                        {'name': 'Exclusive match suggestions', 'included': true},
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPlanCard(
                      name: 'Alpha',
                      price: 49.99,
                      description: 'VIP matchmaking with exclusive perks',
                      color: Colors.black,
                      features: const [
                        {'name': 'Unlimited likes & super likes', 'included': true},
                        {'name': 'VIP customer support', 'included': true},
                        {'name': 'Highest priority matchmaking', 'included': true},
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String name,
    required double price,
    required String description,
    required Color color,
    required List<Map<String, dynamic>> features,
    bool isPopular = false,
  }) {
    return Card(
      elevation: isPopular ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPopular ? Colors.black : Colors.grey[300]!,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  width: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/${isAnnual ? 'year' : 'month'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            feature['included'] ? Icons.check_circle : Icons.cancel,
                            color: feature['included'] ? Colors.blue : Colors.grey[300],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            feature['name'],
                            style: TextStyle(
                              color: feature['included'] ? Colors.black87 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showPaymentModal(
                        context: context,
                        plan: name,
                        price: price,
                        isAnnual: isAnnual,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100), // Orange color
                      foregroundColor: Colors.white, // White text
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(isPopular ? 'Get Started' : 'Select Plan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentModal({
    required BuildContext context,
    required String plan,
    required double price,
    required bool isAnnual,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return PaymentModal(
          plan: plan,
          price: price,
          isAnnual: isAnnual,
        );
      },
    );
  }
}

class PaymentModal extends StatefulWidget {
  final String plan;
  final double price;
  final bool isAnnual;

  const PaymentModal({
    Key? key,
    required this.plan,
    required this.price,
    required this.isAnnual,
  }) : super(key: key);

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameController = TextEditingController();

  String _paymentStep = 'details'; // 'details', 'processing', 'success'

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _paymentStep = 'processing';
      });

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _paymentStep = 'success';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _paymentStep == 'success'
                    ? 'Payment Successful!'
                    : 'Subscribe to ${widget.plan} Plan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _paymentStep == 'success'
                    ? 'Thank you for your subscription.'
                    : '${widget.isAnnual ? 'Annual' : 'Monthly'} billing at \$${widget.price.toStringAsFixed(2)}/${widget.isAnnual ? 'year' : 'month'}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              if (_paymentStep == 'details') _buildPaymentForm(),
              if (_paymentStep == 'processing') _buildProcessingState(),
              if (_paymentStep == 'success') _buildSuccessState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method selector (simplified to just credit card)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.credit_card, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  'Credit Card',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Cardholder name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'John Smith',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the cardholder name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Card number
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              hintText: '4242 4242 4242 4242',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the card number';
              }
              if (value.replaceAll(' ', '').length != 16) {
                return 'Card number must be 16 digits';
              }
              return null;
            },
            onChanged: (value) {
              // Format card number with spaces
              final text = value.replaceAll(' ', '');
              if (text.length > 16) return;

              final buffer = StringBuffer();
              for (int i = 0; i < text.length; i++) {
                buffer.write(text[i]);
                if ((i + 1) % 4 == 0 && i != text.length - 1) {
                  buffer.write(' ');
                }
              }

              final formattedText = buffer.toString();
              if (formattedText != value) {
                _cardNumberController.value = TextEditingValue(
                  text: formattedText,
                  selection: TextSelection.collapsed(offset: formattedText.length),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Expiry date and CVC in a row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (!RegExp(r'^\d\d/\d\d$').hasMatch(value)) {
                      return 'Use MM/YY format';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Format expiry date with slash
                    final text = value.replaceAll('/', '');
                    if (text.length > 4) return;

                    String formattedText = text;
                    if (text.length > 2) {
                      formattedText = '${text.substring(0, 2)}/${text.substring(2)}';
                    }

                    if (formattedText != value) {
                      _expiryDateController.value = TextEditingValue(
                        text: formattedText,
                        selection: TextSelection.collapsed(offset: formattedText.length),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvcController,
                  decoration: const InputDecoration(
                    labelText: 'CVC',
                    hintText: '123',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 3) {
                      return 'Invalid CVC';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length > 3) {
                      _cvcController.value = TextEditingValue(
                        text: value.substring(0, 3),
                        selection: const TextSelection.collapsed(offset: 3),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Pay \$${widget.price.toStringAsFixed(2)}'),
            ),
          ),
          const SizedBox(height: 16),

          // Terms and conditions
          Center(
            child: Text(
              'Your payment will be processed securely via Stripe.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              'By subscribing, you agree to our Terms of Service and Privacy Policy.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 24),
          Text(
            'Processing your payment...',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Subscription Activated!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'You now have access to all ${widget.plan} plan features.',
            style: TextStyle(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}

// To use this code in your Flutter app:
// 1. Create a new file named payment_page.dart
// 2. Add this code to the file
// 3. Navigate to this screen from your main app
// 4. For actual Stripe integration, add the flutter_stripe package