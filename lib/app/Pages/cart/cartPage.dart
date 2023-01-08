import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/orders/checkoutPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/models/cart_modal.dart';
import 'package:trifthing_apps/app/services/service_cart.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    getTypeCart();
    getProductCart();
    super.initState();
  }

  bool? resultType;
  bool loadingType = false;
  Future<void> getTypeCart() async {
    setState(() {
      loadingType = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    String? currendId;
    setState(() {
      currendId = lastId;
    });

    resultType = await ServiceCart().cekTypeCart(id_user_pembeli: "$currendId");

    setState(() {
      loadingType = false;
    });
  }

  List<CartModal> resultCart = [];
  bool isLoading = false;
  int subTotal = 0;
  int subBerat = 0;
  Future<void> getProductCart() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    String? currendId;
    setState(() {
      currendId = lastId;
    });

    resultCart = await ServiceCart().getCart(id_user_pembeli: "$currendId");

    if (resultCart.length > 0) {
      int total = 0;
      int berat = 0;
      for (var i = 0; i < resultCart.length; i++) {
        total += resultCart[i].total!;
        subTotal = total;
        // sub total berat
        berat += resultCart[i].berat!;
        subBerat = berat;
      }
    } else {
      subTotal = 0;
    }

    print("$subBerat");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 0,
        shadowColor: Color.fromARGB(255, 255, 255, 255),
        title: Column(
          children: [
            const Text(
              "Keranjang Saya",
              style: TextStyle(
                color: Color(0xFF414141),
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${resultCart.length} Produk",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF828282),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );

    Widget bottomNavBar() {
      return Container(
        width: bodyWidth * 10,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF828282),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Rp${NumberFormat('#,###').format(subTotal)}"
                      .replaceAll(",", '.'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF414141),
                  ),
                ),
              ],
            ),
            Container(
              width: 220,
              height: 60,
              child: ElevatedButton(
                onPressed: resultType == false
                    ? null
                    : () {
                        Get.to(CheckoutPage(
                          idKotaPengirim: resultCart[0].id_kota_penjual,
                          berat: subBerat,
                        ));
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C62FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Check Out",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget items() {
      return isLoading
          ? const SmallLoadingWidget()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: resultCart.length,
                physics: const ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 10.0 / 3,
                ),
                itemBuilder: (context, index) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFBBB7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF6F65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 27,
                          color: Colors.white,
                        ),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    key: Key(resultCart[index].toString()),
                    onDismissed: (direction) {
                      setState(() {
                        resultCart.removeAt(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFE4E4E4),
                            blurRadius: 3,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCECECE),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64Decode("${resultCart[index].gambar}"),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 220,
                                  // color: Colors.amber,
                                  child: Text(
                                    "${resultCart[index].namaProduk}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                Row(
                                  children: [
                                    Text(
                                      "Rp${NumberFormat('#,###').format(resultCart[index].harga)}"
                                          .replaceAll(",", "."),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF9C62FF),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      "x${resultCart[index].jumlah}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8A8A8A),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Warning!!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                            content: const Text(
                              "Apakah kamu yakin ingin menhapus barang ini ?",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  bool? resultDeleteCardId =
                                      await ServiceCart().deleteCartUseId(
                                    idKeranjang:
                                        "${resultCart[index].idKeranjang}",
                                  );
                                  getTypeCart();
                                  getProductCart();

                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
    }

    return Scaffold(
      appBar: myAppBar,
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavBar(),
      body: loadingType
          ? const SmallLoadingWidget()
          : resultType == false
              ? RefreshIndicator(
                  onRefresh: () async {
                    getTypeCart();
                    getProductCart();
                  },
                  child: ListView(
                    children: const [
                      Center(
                        child: Text("Kosong"),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    getTypeCart();
                    getProductCart();
                  },
                  child: ListView(
                    children: [
                      items(),
                    ],
                  ),
                ),
    );
  }
}
