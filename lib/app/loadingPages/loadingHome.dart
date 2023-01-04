import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../Pages/main/home_screen.dart';

class LoadingHome extends StatefulWidget {
  const LoadingHome({super.key});

  @override
  State<LoadingHome> createState() => _LoadingHomeState();
}

class _LoadingHomeState extends State<LoadingHome> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Get.offAll(HomeScreen(), duration: Duration(seconds: 0));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 130,
          height: 130,
          // color: Colors.amber,
          child: Lottie.asset("assets/lottie/iconPage/loading.json"),
        ),
      ),
    );
  }
}
