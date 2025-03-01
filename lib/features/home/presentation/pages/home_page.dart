import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:furrpal/features/home/presentation/pages/payment_page.dart';
import 'package:furrpal/features/home/presentation/pages/filter_search_page.dart';

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

  // Create an overlay entry to show custom toast
  OverlayEntry? _overlayEntry;

  // Function to show custom toast message
  void _showCustomToast(String message) {
    // Remove any existing overlay first
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // Position it above the bottom navigation but below cards
        bottom: 80, // Adjust this value based on your tab bar height
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 121, 125, 122),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );

    // Insert overlay and auto-remove after some duration
    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _showToast(String dogName, bool isLiked) {
    _showCustomToast("${dogName} ${isLiked ? 'liked! ' : 'disliked '}");
  }

  void _showSkipToast(String dogName) {
    _showCustomToast("${dogName} skipped");
  }

  @override
  void dispose() {
    // Clean up overlay if it exists
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 240),
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildTopBar(),
          const Spacer(),
          SizedBox(
            height: 650,
            child: CardSwiper(
              controller: swiperController,
              cardsCount: dogs.length,
              // Updated onSwipe callback to handle all directions
              onSwipe: (previousIndex, currentIndex, direction) {
                if (direction == CardSwiperDirection.right) {
                  _showToast(dogs[previousIndex]['name'], true);
                  print("${dogs[previousIndex]['name']} liked! ");
                } else if (direction == CardSwiperDirection.left) {
                  _showToast(dogs[previousIndex]['name'], false);
                  print("${dogs[previousIndex]['name']} disliked ");
                } else if (direction == CardSwiperDirection.top ||
                    direction == CardSwiperDirection.bottom) {
                  _showSkipToast(dogs[previousIndex]['name']);
                  print("${dogs[previousIndex]['name']} skipped ⏭");
                }
                return true;
              },
              cardBuilder:
                  (context, index, percentThresholdX, percentThresholdY) {
                return DogProfileCard(
                  dog: dogs[index],
                  isTopCard: index == 0,
                  swiperController: swiperController,
                  onLike: () => _showToast(dogs[index]['name'], true),
                  onDislike: () => _showToast(dogs[index]['name'], false),
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
                MaterialPageRoute(builder: (context) => SearchFilterScreen()),
              );
            },
            child: Icon(Icons.search, color: Colors.grey.shade800, size: 28),
          ),
          Icon(Icons.person, color: Colors.grey.shade800, size: 28),
        ],
      ),
    );
  }
}

// DogProfileCard class remains the same
class DogProfileCard extends StatelessWidget {
  final Map<String, dynamic> dog;
  final bool isTopCard;
  final CardSwiperController swiperController;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const DogProfileCard({
    super.key,
    required this.dog,
    required this.isTopCard,
    required this.swiperController,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    dog["image"],
                    height: 200,
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _floatingButton(
                icon: Icons.close,
                color: Colors.redAccent,
                backgroundColor: Colors.red.withOpacity(0.2),
                onTap: () {
                  // Show toast first, then swipe
                  onDislike();
                  swiperController.swipe(CardSwiperDirection.left);
                },
              ),
              const SizedBox(width: 30),
              _floatingButton(
                icon: Icons.favorite,
                color: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.2),
                onTap: () {
                  // Show toast first, then swipe
                  onLike();
                  swiperController.swipe(CardSwiperDirection.right);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
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
