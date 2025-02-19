import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> dogs = [
    {
      "name": "Rocky",
      "breed": "German Shepherd",
      "age": "4 years",
      "gender": "Male",
      "location": "Kandy",
      "image": "assets/images/german_shepherd.jpg"
    },
  ];

  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 1.0,
      upperBound: 1.1,
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dog = dogs[0];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 240),
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildTopBar(),
          const Spacer(),
          Draggable(
            feedback: DogProfileCard(dog: dog),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              // Future swipe effect - Load next profile
            },
            child: DogProfileCard(dog: dog),
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
          Icon(Icons.search, color: Colors.grey.shade800, size: 28),
          Icon(Icons.person, color: Colors.grey.shade800, size: 28),
        ],
      ),
    );
  }
}

class DogProfileCard extends StatelessWidget {
  final Map<String, dynamic> dog;
  const DogProfileCard({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(12),
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(dog["image"],
                    height: 300, fit: BoxFit.cover, width: double.infinity),
              ),
              const SizedBox(height: 15),
              Text(
                dog["name"],
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(
                dog["breed"],
                style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown),
              ),
              const SizedBox(height: 10),
              _infoRow(dog),
              const SizedBox(height: 125),
            ],
          ),
        ),
        _buildFloatingButtons(context),
      ],
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
            color: const Color.fromARGB(255, 165, 168, 163),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      bottom: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _glassButton(
              icon: Icons.close, color: Colors.redAccent, onTap: () {}),
          const SizedBox(width: 30),
          _glassButton(
              icon: Icons.favorite,
              color: const Color.fromARGB(255, 139, 180, 92),
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _glassButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTapDown: (_) => HapticFeedback.mediumImpact(),
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 3,
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
