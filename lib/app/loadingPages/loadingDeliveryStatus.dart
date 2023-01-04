import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../Pages/orders/deliveryStatusPage.dart';

class LoadingDeliveryStatus extends StatefulWidget {
  const LoadingDeliveryStatus({super.key});

  @override
  State<LoadingDeliveryStatus> createState() => _LoadingDeliveryStatusState();
}

class _LoadingDeliveryStatusState extends State<LoadingDeliveryStatus> {
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
    ;
  }
}
