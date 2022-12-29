import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BigLoadingWidget extends StatelessWidget {
  const BigLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        child: Lottie.asset("assets/lottie/iconPage/loading.json"),
      ),
    );
  }
}
