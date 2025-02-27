import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int selectedIndex = 0;

  final categories = ['Profile', 'Community', 'Pet Shop'];

  List<Notification> getCurrentNotifications() {
    switch (selectedIndex) {
      case 0:
        return profileNotifications;
      case 1:
        return communityNotifications;
      case 2:
        return petShopNotifications;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      body: ListView.separated(
        itemCount: getCurrentNotifications().length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          indent: 72,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          return NotificationTile(
            notification: getCurrentNotifications()[index],
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Notification notification;

  const NotificationTile({super.key, required this.notification});

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
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(notification.avatarPath),
            ),
          ),
          const SizedBox(width: 12),
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
              ],
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

  Notification({
    required this.avatarPath,
    required this.title,
    required this.message,
    required this.time,
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
