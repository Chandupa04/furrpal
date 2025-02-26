import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:furrpal/features/home/presentation/pages/payment_page.dart';
import 'package:furrpal/features/home/presentation/pages/filter_search_page.dart';
import 'package:furrpal/features/home/presentation/pages/userprofile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> dogs = [
    {
      "name": "Rocky",
      "breed": "German Shepherd",
      "age": "4 years",
      "gender": "Male",
      "location": "Kandy",
      "image": "assets/images/german_shepherd.jpg"
    },
    {
      "name": "Bella",
      "breed": "Golden Retriever",
      "age": "3 years",
      "gender": "Female",
      "location": "Colombo",
      "image": "assets/images/golden_retriever.jpeg"
    }
  ];

  final CardSwiperController swiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 240),
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildTopBar(),
          const Spacer(),

          // Replaced static DogProfileCard with CardSwiper
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.88,
            height: 650,
            // Ensures only 1 card is visible
            child: CardSwiper(
              controller: swiperController,
              cardsCount: dogs.length,
              onSwipe: (index, direction, previousIndex) {
                if (direction == CardSwiperDirection.right) {
                  print("${dogs[index]['name']} liked! ❤️");
                } else if (direction == CardSwiperDirection.left) {
                  print("${dogs[index]['name']} disliked ❌");
                }
                return true;
              },
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return DogProfileCard(
                  dog: dogs[index],
                  isTopCard: index == 0,
                  swiperController: swiperController,
                );
              },
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchFilterScreen()),
              );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const UserProfileApp()),
              // );

            },
            child: Icon(Icons.search, color: Colors.grey.shade800, size: 28),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfileWidget()),
              );
            },
          // Navigate to User Profile

            child:Icon(Icons.person, color: Colors.grey.shade800, size: 28),
          ),
        ],
      ),
    );
  }
}

// Fixes bottom overflow issue by using Flexible & Padding
class DogProfileCard extends StatelessWidget {
  final Map<String, dynamic> dog;
  final bool isTopCard;
  final CardSwiperController swiperController;

  const DogProfileCard({
    super.key,
    required this.dog,
    required this.isTopCard,
    required this.swiperController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 85.0,
      height: 100,
      // ✅ Increased height to 85% of screen
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, //  Keeps things compact
        children: [
          Expanded(
            // Expands content properly without overflow
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    dog["image"],
                    height: 200, // Adjust image height
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  dog["name"],
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  dog["breed"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow(dog),
                const SizedBox(height: 15),
              ],
            ),
          ),

          //  Centered Button (Show User Details)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserDetailsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 183, 180, 177),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text(
                "Show User Details",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),

          // Floating Buttons (Heart & Cross)
          const SizedBox(height: 15), // Adjusted spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _floatingButton(
                icon: Icons.close,
                color: Colors.redAccent,
                backgroundColor: Colors.red.withOpacity(0.2),
                onTap: () {
                  swiperController.swipe(CardSwiperDirection.left);
                },
              ),
              const SizedBox(width: 30),
              _floatingButton(
                icon: Icons.favorite,
                color: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.2),
                onTap: () {
                  swiperController.swipe(CardSwiperDirection.right);
                },
              ),
            ],
          ),
          const SizedBox(height: 20), // Adjusted to prevent bottom overflow
        ],
      ),
    );
  }

  Widget _infoRow(Map<String, dynamic> dog) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _infoPill("Age", dog["age"]),
        _infoPill("Gender", dog["gender"]),
        _infoPill("Location", dog["location"]),
      ],
    );
  }

  Widget _infoPill(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 183, 215, 172),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  // Floating Button Design (Heart & Cross)
  Widget _floatingButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => HapticFeedback.mediumImpact(),
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 32, color: color),
        ),
      ),
    );
  }
}
