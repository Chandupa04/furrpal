import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furrpal/config/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:furrpal/features/home/presentation/pages/userdetails_page.dart';

class DogProfilePage extends StatefulWidget {
  final String dogId;
  final String userId;

  const DogProfilePage({
    Key? key,
    required this.dogId,
    required this.userId,
  }) : super(key: key);

  @override
  _DogProfilePageState createState() => _DogProfilePageState();
}

class _DogProfilePageState extends State<DogProfilePage> {
  final FirebaseService _firebaseService = FirebaseService();
  bool isLoading = true;
  Map<String, dynamic>? dogProfile;

  @override
  void initState() {
    super.initState();
    _loadDogProfile();
  }

  Future<void> _loadDogProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final profile = await _firebaseService.getDogProfileById(
        widget.dogId,
        widget.userId,
      );

      if (mounted) {
        setState(() {
          dogProfile = profile;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dog profile: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load dog profile: $e')),
        );
      }
    }
  }

  // Helper method to get the appropriate image
  Widget _getProfileImage() {
    // Check multiple possible field names for the image URL
    String? imageUrl;
    if (dogProfile!.containsKey("imageUrl") &&
        dogProfile!["imageUrl"] != null &&
        dogProfile!["imageUrl"].toString().isNotEmpty) {
      imageUrl = dogProfile!["imageUrl"];
    } else if (dogProfile!.containsKey("image") &&
        dogProfile!["image"] != null &&
        dogProfile!["image"].toString().isNotEmpty) {
      imageUrl = dogProfile!["image"];
    }

    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading dog image: $error');
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.error,
              color: Colors.red,
              size: 50,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        "assets/images/dog_placeholder.jpg",
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 240),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dog Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dogProfile == null
              ? const Center(
                  child: Text(
                    'Dog profile not found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _getProfileImage(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          dogProfile!["name"] ?? "Unknown Dog",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dogProfile!["breed"] ?? "Unknown breed",
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildInfoRow(),
                        const SizedBox(height: 30),
                        if (dogProfile!["healthConditions"] != null &&
                            dogProfile!["healthConditions"]
                                .toString()
                                .isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Health Conditions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dogProfile!["healthConditions"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            final userDetails = await _firebaseService
                                .getUserDetails(dogProfile!["ownerId"]);
                            if (userDetails != null && mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    name: userDetails['name'],
                                    email: userDetails['email'],
                                    address: userDetails['address'],
                                    contact: userDetails['contact'],
                                    since: userDetails['since'],
                                    imagePath: userDetails['imagePath'],
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Failed to load user details')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 183, 180, 177),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          child: const Text(
                            "View Owner Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildInfoItem("Age", dogProfile!["age"] ?? "Unknown"),
          _buildVerticalDivider(),
          _buildInfoItem("Gender", dogProfile!["gender"] ?? "Unknown"),
          _buildVerticalDivider(),
          _buildInfoItem("Location", dogProfile!["location"] ?? "Unknown"),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}
