// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_courses/add.dart';
import 'package:flutter_courses/auth/login.dart';
import 'package:flutter_courses/auth/signup.dart';
import 'package:flutter_courses/firebase_options.dart';
import 'package:flutter_courses/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      try {
        await FirebaseAuth.instance.signInAnonymously();
        print("✅ الاتصال بـ Firebase يعمل بنجاح");
      } catch (e) {
        print("❌ فشل الاتصال بـ Firebase: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.amber),
          elevation: 2,
          shadowColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home:
          (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Homepage()
          : Login(),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homepage": (context) => Homepage(),
        "addcategory": (context) => AddCategory(),
      },
    );
  }
}
