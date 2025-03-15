import 'package:flutter/material.dart';

Widget buildInfoRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
    ],
  );
}
