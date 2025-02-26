import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pet Social Notifications',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         brightness: Brightness.light,
//         fontFamily: 'Roboto',
//       ),
//       home: const NotificationsPage(),
//     );
//   }
// }

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Community'),
              Tab(text: 'Pet Shop'),
              Tab(text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationList(notifications: communityNotifications),
            NotificationList(notifications: petShopNotifications),
            NotificationList(notifications: profileNotifications),
          ],
        ),
      ),
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<Notification> notifications;

  const NotificationList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationTile(notification: notifications[index]);
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Notification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(notification.avatarPath),
        ),
        title: Text(notification.title),
        subtitle: Text(notification.message),
        trailing: Text(
          notification.time,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

  Notification({
    required this.avatarPath,
    required this.title,
    required this.message,
    required this.time,
  });
}

// Sample data
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
