// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'app/Pages/intro/SplashScreen.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.size,
      debugShowCheckedModeBanner: false,
      title: "Go-Thrift",
      home: SplashScreen(),
    );
  }
}
