import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:furrpal/app_data.dart';
import 'package:furrpal/firebase_options.dart';

void main() async {
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(MyApp());
}
