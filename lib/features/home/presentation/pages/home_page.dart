import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:furrpal/features/home/presentation/pages/payment_page.dart';
import 'package:furrpal/features/home/presentation/pages/filter_search_page.dart';
import 'package:furrpal/config/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> dogs = [];
  bool isLoading = true;
  bool _disposed = false;
  String? currentUserId;

  final CardSwiperController swiperController = CardSwiperController();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    _loadDogProfiles();
  }

  @override
  void dispose() {
    _disposed = true;
    _overlayEntry?.remove();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_disposed && mounted) {
      setState(fn);
    }
  }

  Future<void> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      print('Current user ID: $currentUserId');
    } else {
      print('No user is logged in');
    }
  }

  Future<void> _loadDogProfiles() async {
    if (!mounted) return;

    _safeSetState(() {
      isLoading = true;
    });

    try {
      final dogProfiles = await _firebaseService.getAllDogProfiles();

      // Debug: Print the number of profiles retrieved
      print('Loaded ${dogProfiles.length} dog profiles');

      _safeSetState(() {
        dogs = dogProfiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading dog profiles: $e');
      if (!_disposed && mounted) {
        _safeSetState(() {
          isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dog profiles: $e')),
        );
      }
    }
  }

  void _testFirestore() async {
    try {
      // Get current user ID
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("No user logged in");
        return;
      }
      String userId = currentUser.uid;

      // First, check if we can read existing documents
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .get();
      print(
          "Found ${snapshot.docs.length} existing dog profiles for current user");

      // Then try to add a test document
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('dogs')
          .add({
        'name': 'Test Dog',
        'breed': 'Test Breed',
        'gender': 'Male',
        'age': '3',
        'location': 'Test Location',
        'createdAt': FieldValue.serverTimestamp(),
        'likes': [],
        'dislikes': [],
      });

      print("Test dog profile added successfully with ID: ${docRef.id}");

      // Refresh the dog profiles list
      _loadDogProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test dog profile added successfully!')),
        );
      }
    } catch (e) {
      print("Error testing Firestore: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error testing Firestore: $e")),
        );
      }
    }
  }

  void _showCustomToast(String message) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
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

    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  // Handle like action
  void _handleLike(Map<String, dynamic> dog) {
    if (currentUserId == null) {
      print('No user is logged in, cannot like dog');
      return;
    }

    final String dogId = dog['id'];
    final String dogOwnerId = dog['ownerId'];
    final String dogName = dog['name'] ?? 'Unknown Dog';

    // Show toast immediately
    _showToast(dogName, true);

    // Then perform the database operation
    _firebaseService
        .storeDogLike(
      currentUserId: currentUserId!,
      dogOwnerId: dogOwnerId,
      dogId: dogId,
      dogName: dogName,
    )
        .catchError((e) {
      print('Error liking dog: $e');
      if (mounted) {
        if (e.toString().contains('24-hour like limit')) {
          // Show payment page when limit is reached
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Like Limit Reached'),
                content: const Text(
                    'You have reached your 24-hour like limit. Upgrade to continue liking more profiles!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PricingPlansScreen(),
                        ),
                      );
                    },
                    child: const Text('Upgrade Now'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context)
                          .pop(); // Pop the current route to go back
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to like dog: $e')),
          );
        }
      }
    });
  }

  // Handle dislike action
  void _handleDislike(Map<String, dynamic> dog) {
    if (currentUserId == null) {
      print('No user is logged in, cannot dislike dog');
      return;
    }

    final String dogId = dog['id'];
    final String dogOwnerId = dog['ownerId'];
    final String dogName = dog['name'] ?? 'Unknown Dog';

    // Show toast immediately
    _showToast(dogName, false);

    // Then perform the database operation
    _firebaseService
        .storeDogDislike(
      currentUserId: currentUserId!,
      dogOwnerId: dogOwnerId,
      dogId: dogId,
      dogName: dogName,
    )
        .catchError((e) {
      print('Error disliking dog: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to dislike dog: $e')),
        );
      }
    });
  }

  void _showToast(String dogName, bool isLiked) {
    _showCustomToast("$dogName ${isLiked ? 'liked! ' : 'disliked '}");
  }

  void _showSkipToast(String dogName) {
    _showCustomToast("$dogName skipped");
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (dogs.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No dog profiles found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadDogProfiles,
                    child: const Text("Refresh"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _testFirestore,
                    child: const Text("Test Firestore Connection"),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 650,
              child: CardSwiper(
                controller: swiperController,
                cardsCount: dogs.length,
                onSwipe: (previousIndex, currentIndex, direction) {
                  // Handle swipe actions
                  if (direction == CardSwiperDirection.right) {
                    _handleLike(dogs[previousIndex]);
                  } else if (direction == CardSwiperDirection.left) {
                    _handleDislike(dogs[previousIndex]);
                  } else if (direction == CardSwiperDirection.top ||
                      direction == CardSwiperDirection.bottom) {
                    _showSkipToast(
                        dogs[previousIndex]['name'] ?? 'Unknown Dog');
                  }
                  return true;
                },
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                  return DogProfileCard(
                    dog: dogs[index],
                    isTopCard: index == 0,
                    swiperController: swiperController,
                    onLike: () => _handleLike(dogs[index]),
                    onDislike: () => _handleDislike(dogs[index]),
                  );
                },
              ),
            ),
          const Spacer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDogProfiles,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
            },
            child: Icon(Icons.search, color: Colors.grey.shade800, size: 28),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: const [
                Text(
                  "FurrPal",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(width: 30),
          // Icon(Icons.person, color: Colors.grey.shade800, size: 28),
        ],
      ),
    );
  }
}

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
    // Get image from Firebase or use placeholder
    final String imageUrl = dog["imageUrl"] ?? "";

    return Container(
      height: 160,
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
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        ),
                      );
                    },
                  )
                      : Image.asset(
                    "assets/images/dog_placeholder.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  dog["name"] ?? "Unknown",
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  dog["breed"] ?? "Unknown breed",
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
                // Show a message that this feature is coming soon
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('This feature is coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
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
        _infoPill("Age", dog["age"] ?? "Unknown"),
        _infoPill("Gender", dog["gender"] ?? "Unknown"),
        _infoPill("Location", dog["location"] ?? "Unknown"),
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
