import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/app/Pages/checkoutPage.dart';

class LoadingCheckout extends StatefulWidget {
  var idProduk, idUser, idKat, idKota, berat, pengiriman;
  LoadingCheckout({
    super.key,
    this.idProduk,
    this.idUser,
    this.idKat,
    this.idKota,
    this.berat,
    this.pengiriman,
  });

  @override
  State<LoadingCheckout> createState() => _LoadingCheckoutState();
}

class _LoadingCheckoutState extends State<LoadingCheckout> {
  void initState() {
    Timer(Duration(seconds: 2), () {
      Get.offAll(
          CheckoutPage(
            idProduk: widget.idProduk,
            idUser: widget.idUser,
            idKat: widget.idKat,
            idKota: widget.idKota,
            berat: widget.berat,
            pengiriman: widget.pengiriman,
          ),
          duration: Duration(seconds: 0));
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
