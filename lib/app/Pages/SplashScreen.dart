import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/auth/login/loginPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import '/app/Pages/home_screen.dart';
import '/app/Pages/introductionPage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  // bool? isSkipIntro = false;
  // SplashScreen({this.isSkipIntro});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isSkipIntro = false;
  bool? isSkipLogin = false;
  bool? current;
  bool? current2;

  void check(bool? current) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? lastValue = await Controller1.getCheckLogin();
    bool? lasvalueIntro = await Controller1.getCheckIntroduction();
    current = lastValue as bool?;
    current2 = lasvalueIntro as bool?;
    print("login skip type  $current");
    print("into skip type  $current2");
    if (current == true) {
      setState(() {
        isSkipLogin = true;
      });
    } else {
      setState(() {
        isSkipLogin = false;
      });
    }
    if (current2 == true) {
      setState(() {
        isSkipIntro = true;
      });
    } else {
      setState(() {
        isSkipIntro = false;
      });
    }
  }

  @override
  void initState() {
    var i = check(current);
    Timer(Duration(seconds: 3), () {
      (isSkipIntro == true)
          ? (isSkipLogin == true)
              ? Get.offAll(HomeScreen())
              : Get.offAll(LoginPage())
          : Get.offAll(IntroductionPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/lottie/iconIntroduction/logo_splash.json"),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
