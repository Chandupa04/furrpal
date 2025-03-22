import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:furrpal/config/firebase_service.dart';
import 'package:furrpal/features/home/dog_profile_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedIndex = 0;
  final FirebaseService _firebaseService = FirebaseService();
  final categories = ['Profile', 'Community'];

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    print('Current user ID: ${currentUser?.uid}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const SizedBox(width: 0), // Remove leading space
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "FurrPal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                categories.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? const Color(0xFF333333)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categories[index],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: selectedIndex == index
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: selectedIndex == 0
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser?.uid)
                  .collection('notifications')
                  .where('type', isEqualTo: 'like')
                  .snapshots(),
              builder: (context, snapshot) {
                print('StreamBuilder state: ${snapshot.connectionState}');
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('StreamBuilder waiting for data...');
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final notifications = snapshot.data?.docs ?? [];
                print('Number of notifications: ${notifications.length}');

                if (notifications.isEmpty) {
                  print('No notifications found');
                  return Center(
                    child: Text(
                      'No likes yet',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                // Sort notifications by timestamp in memory
                notifications.sort((a, b) {
                  final aTimestamp = (a.data()
                      as Map<String, dynamic>)['timestamp'] as Timestamp;
                  final bTimestamp = (b.data()
                      as Map<String, dynamic>)['timestamp'] as Timestamp;
                  return bTimestamp
                      .compareTo(aTimestamp); // Sort in descending order
                });

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final notification =
                        notifications[index].data() as Map<String, dynamic>;
                    print('Notification data: $notification');

                    // Debugging: Print dogId and userId for each notification
                    print('Dog ID: ${notification['dogId']}');
                    print('User ID: ${notification['userId']}');

                    final timestamp = notification['timestamp'] as Timestamp;
                    final timeAgo = timeago.format(timestamp.toDate());

                    // Get the user who liked the profile
                    final likedByUserName =
                        notification['likedByUserName'] ?? 'Someone';
                    final dogName = notification['dogName'] ?? 'your dog';
                    final message = notification['message'] ??
                        'Your dog is getting popular!';

                    // Get profile picture if available, otherwise use default
                    final avatarPath =
                        notification['likedByUserProfilePic'] != null &&
                                notification['likedByUserProfilePic']
                                    .toString()
                                    .isNotEmpty
                            ? notification['likedByUserProfilePic']
                            : 'assets/user3.png';

                    return NotificationTile(
                      notification: Notification(
                        avatarPath: avatarPath,
                        title: '$likedByUserName liked your profile',
                        message: message,
                        time: timeAgo,
                        userId: notification['likedByUserId'],
                        dogId: notification['likedByDogId'],
                        likedByUserId: notification['likedByUserId'],
                        likedByDogId: notification['likedByDogId'],
                      ),
                    );
                  },
                );
              },
            )
          : ListView.separated(
              itemCount: getCurrentNotifications().length,
              separatorBuilder: (context, index) => const Divider(
                height: 0.5,
                indent: 100,
                endIndent: 16, // Matches the right padding
                thickness: 0.8,
                color: Color(
                    0xFFDDDDDD), // Light grey line (optional for a premium feel)
              ),
              itemBuilder: (context, index) {
                return NotificationTile(
                  notification: getCurrentNotifications()[index],
                );
              },
            ),
    );
  }

  List<Notification> getCurrentNotifications() {
    switch (selectedIndex) {
      case 1:
        return communityNotifications;
      default:
        return [];
    }
  }
}

class NotificationTile extends StatelessWidget {
  final Notification notification;
  final FirebaseService _firebaseService = FirebaseService();

  NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.time,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  if (notification.likedByUserId != null &&
                      notification.likedByDogId != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          print('Viewing dog profile:');
                          print('  likedByDogId: ${notification.likedByDogId}');
                          print(
                              '  likedByUserId: ${notification.likedByUserId}');

                          // Fetch the dog profile before navigating
                          final dogProfile =
                              await _firebaseService.getDogProfileById(
                            notification.likedByDogId!,
                            notification.likedByUserId!,
                          );

                          if (dogProfile != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DogProfilePage(
                                  dogId: notification.likedByDogId!,
                                  userId: notification.likedByUserId!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Profile not found',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          // decoration: BoxDecoration(
                          //   color: const Color(0xffF88158),
                          //   borderRadius: BorderRadius.circular(16),
                          // ),
                          child: Text(
                            'View Profile',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 254, 79, 21),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Notification {
  final String avatarPath;
  final String title;
  final String message;
  final String time;
  final String? userId;
  final String? dogId;
  final String? likedByUserId;
  final String? likedByDogId;

  Notification({
    required this.avatarPath,
    required this.title,
    required this.message,
    required this.time,
    this.userId,
    this.dogId,
    this.likedByUserId,
    this.likedByDogId,
  });
}

// Sample data
final List<Notification> profileNotifications = [
  Notification(
    avatarPath: 'assets/user3.png',
    title: 'Emily liked Max\'s profile',
    message: 'Your Golden Retriever is getting popular!',
    time: '30m ago',
  ),
  Notification(
    avatarPath: 'assets/user4.png',
    title: 'Tom viewed Bella\'s profile',
    message: 'Your Labrador caught someone\'s attention',
    time: '1d ago',
  ),
];

final List<Notification> communityNotifications = [
  Notification(
    avatarPath: 'assets/user1.png',
    title: 'John Doe liked your post',
    message: 'Your cute puppy photo got a new like!',
    time: '2m ago',
  ),
  Notification(
    avatarPath: 'assets/user2.png',
    title: 'Jane Smith commented',
    message: 'Awesome picture of your dog!',
    time: '15m ago',
  ),
];

final List<Notification> petShopNotifications = [
  Notification(
    avatarPath: 'assets/shop1.png',
    title: 'PetMart Sale',
    message: '20% off on all dog toys this weekend!',
    time: '1h ago',
  ),
  Notification(
    avatarPath: 'assets/shop2.png',
    title: 'New Arrival',
    message: 'Check out our new premium dog food collection',
    time: '3h ago',
  ),
];
