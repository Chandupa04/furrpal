// import 'package:flutter/material.dart';
//
// class UserDetailsScreen extends StatefulWidget {
//   const UserDetailsScreen({super.key});
//
//   @override
//   State<UserDetailsScreen> createState() => _UserDetailsScreenState();
// }
//
// class _UserDetailsScreenState extends State<UserDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFF88158), // Orange
//               Color(0xFFFFDACD), // Peach
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 🔒 Lock Icon & Message
//               const Column(
//                 children: [
//                   Icon(Icons.lock_outline, size: 80, color: Colors.black),
//                   SizedBox(height: 15),
//                   Text(
//                     "You need to pay to view user details.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 30),
//
//               // 💳 Payment Box
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 15,
//                       spreadRadius: 2,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "PAYMENT METHOD",
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // 🔘 PayHere Option
//                     GestureDetector(
//                       onTap: () {
//                         // Handle PayHere payment
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 12, horizontal: 15),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: const Color(0xFFFE5B00), width: 2),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.payment,
//                                   size: 30,
//                                   color: Color(0xFFF88158),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   "Stripe",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Icon(Icons.check, color: Colors.green, size: 22),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     // ➡️ "Next Step" Button with Gradient
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: const Color.fromARGB(255, 246, 130, 91),
//                         // gradient: const LinearGradient(
//                         //   colors: [
//                         //     Color(0xFFF88158), // Orange
//                         //     Color(0xFFFFDACD), // Peach
//                         //   ],
//                         //   begin: Alignment.centerLeft,
//                         //   end: Alignment.centerRight,
//                         // ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Handle payment processing here
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "NEXT STEP",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20), // Spacing outside white box
//
//               // ⬅️ Close Button (Outside White Box)
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Navigate back
//                 },
//                 child: const Text(
//                   "Close",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black, // Black text color
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
