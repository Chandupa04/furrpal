import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:furrpal/config/firebase_service.dart';
import 'package:furrpal/features/home/presentation/pages/userdetails_page.dart';

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
  void initState() {
    super.initState();
    // _markAllNotificationsAsRead();
  }

  // void _markAllNotificationsAsRead() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser != null) {
  //     final unreadNotifications = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .collection('notifications')
  //         .where('read', isEqualTo: false)
  //         .get();

  //     for (var doc in unreadNotifications.docs) {
  //       await doc.reference.update({'read': true});
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const SizedBox(width: 0),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "FurrPal",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 50),
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
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? const Color(0xFF333333)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: selectedIndex == index
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
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
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF333333)),
                  );
                }

                final notifications = snapshot.data?.docs ?? [];

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No likes yet',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                notifications.sort((a, b) {
                  final aTimestamp = (a.data()
                      as Map<String, dynamic>)['timestamp'] as Timestamp;
                  final bTimestamp = (b.data()
                      as Map<String, dynamic>)['timestamp'] as Timestamp;
                  return bTimestamp.compareTo(aTimestamp);
                });

                return ListView.separated(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final data =
                        notifications[index].data() as Map<String, dynamic>;
                    final docId = notifications[index].id;
                    final timestamp = data['timestamp'] as Timestamp;
                    final timeAgo = timeago.format(timestamp.toDate());
                    final dogName = data['dogName'] ?? 'your dog';
                    final avatarPath =
                        data['likedByUserProfilePic'] ?? 'assets/user3.png';
                    final title = 'A user liked your profile';

                    return NotificationTile(
                      notification: Notification(
                        avatarPath: avatarPath,
                        title: title,
                        message:
                            data['message'] ?? '$dogName has received a like.',
                        time: timeAgo,
                        userId: data['likedByUserId'],
                        dogId: data['likedByDogId'],
                        likedByUserId: data['likedByUserId'],
                        likedByDogId: data['likedByDogId'],
                        notificationDocId: docId,
                      ),
                    );
                  },
                );
              },
            )
          : Container(),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Notification notification;
  final FirebaseService _firebaseService = FirebaseService();

  NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (notification.likedByUserId != null) {
          final userDetails = await _firebaseService
              .getUserDetails(notification.likedByUserId!);

          if (userDetails != null && context.mounted) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('notifications')
                .doc(notification.notificationDocId)
                .update({'read': true});

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
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.favorite, color: Color(0xFFF49548), size: 28),
            const SizedBox(width: 16),
            Expanded(
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
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notification.time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  if (notification.likedByUserId != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFFE4F15).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'View Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFE4F15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
  final String notificationDocId;

  Notification({
    required this.avatarPath,
    required this.title,
    required this.message,
    required this.time,
    this.userId,
    this.dogId,
    this.likedByUserId,
    this.likedByDogId,
    required this.notificationDocId,
  });
}
