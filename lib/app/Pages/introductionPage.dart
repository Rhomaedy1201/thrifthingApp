import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import '/app/auth/login/loginPage.dart';
import 'package:get/get.dart';

class IntroductionPage extends StatefulWidget {
  bool? isSkipIntro;
  IntroductionPage({super.key, this.isSkipIntro});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    _incrementCheckIntroduction();
    super.initState();
  }

  Future<String?> resetCheckIntroduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('valueIntroduction', true);
  }

  Future<bool?> _incrementCheckIntroduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? lastValue = await Controller1.getCheckIntroduction();
    bool? current = lastValue;
    await prefs.setBool('valueIntroduction', current!);
    print("into : $current");
  }

  void _onIntroEnd(context) {
    Get.offAll(LoginPage());
    resetCheckIntroduction();
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName,
      [double width = 350, double height = 300]) {
    return Lottie.asset('assets/lottie/iconIntroduction/$assetName',
        width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        globalFooter: SizedBox(
          width: double.infinity,
          height: 60,
        ),
        pages: [
          PageViewModel(
            title: "Hallo, Selamat Datang!",
            body:
                "Instead of having to buy an entire share, invest any amount you want.",
            image: _buildImage('icon7.json'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Learn as you go",
            body:
                "Download the Stockpile app and master the market with our mini-lesson.",
            image: _buildImage('icon1.json'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Kids and teens",
            body:
                "Kids and teens can track their stocks 24/7 and place trades that you approve.",
            image: _buildImage('icon3.json'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Kids and teens",
            body:
                "Kids and teens can track their stocks 24/7 and place trades that you approve.",
            image: _buildImage('icon4.json'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,

        //rtl: true, // Display as right-to-left
        back: const Icon(
          Icons.arrow_back,
          color: Colors.deepPurple,
        ),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(
          Icons.arrow_forward,
          color: Colors.deepPurple,
        ),
        done: const Text('Done',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.deepPurple)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeColor: Colors.deepPurple,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }
}
