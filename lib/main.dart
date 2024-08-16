import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase core import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zero_c/firebase_options.dart';
import 'login_process/Login_process.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
