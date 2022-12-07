import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/shippingOptionPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/models/details_alamat_model.dart';
import '/app/Pages/paymentPage.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  var idProduk, idUser, idKat;
  var pengiriman;
  var idKota, berat;
  DateTime now = DateTime.now();
  CheckoutPage({
    super.key,
    this.idProduk,
    this.idUser,
    this.idKat,
    this.pengiriman,
    this.idKota,
    this.berat,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int? totalPembayaran;

  DetailsAlamat alamat = DetailsAlamat();
  var resultAlamat;
  var modelsAlamat;
  var idKota;
  String? currentId;

  var loading = false;

  Future<void> getAlamat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastId;
    });
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/detail_alamat_user/get_detail_alamat.php?id_user=${currentId.toString()}");
    final response2 = await http.get(url);
    if (response2.statusCode == 200) {
      setState(() {
        resultAlamat = json.decode(response2.body);
        modelsAlamat = resultAlamat['result'];
        idKota = modelsAlamat[0]['id_kota'];
      });
    } else {
      print("response status code Alamat ceckout salah");
    }
  }

  List result = [];
  Future<void> getData() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/produk_user/get_produk_user.php?id_produk=${widget.idProduk.toString()}&id_user=${widget.idUser.toString()}&id_kategori=${widget.idKat.toString()}");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body)[0]['result'];
      });
    } else {
      print("response status code checkout produk salah");
    }
  }

  var resultPengiriman;
  getPengiriman() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    var dataPengiriman = {
      "key": "d94bc123ecd740dfcfb52e76e0439035",
      "origin": "${widget.idKota}",
      "destination": "160",
      "weight": "${widget.berat}",
      "courier": "${widget.pengiriman}",
    };
    final response = await http.post(url, body: dataPengiriman);
    resultPengiriman = jsonDecode(response.body);
    if (resultPengiriman['rajaongkir']['status']['code'] == 200) {
      print(resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost']);
      setState(() {});
    } else {
      print("response status code checkout produk salah");
    }
  }

  int ongkir = 20000;
  int? hargaBr;
  int? totalPesan;
  int? subTotalProduk;
  var pengiriman = "pos";

  @override
  void initState() {
    print(pengiriman);
    setState(() {
      // idKota = modelsAlamat[0]['id_kota'];
    });
    getAlamat();
    getData();
    getPengiriman();
    print(widget.idKota);
    print(widget.idUser);
    print(widget.berat);
    print(widget.pengiriman);
    print(idKota);
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    bool tes = !false;
    return (loading == false)
        ? Scaffold(
            body: Center(
              child: Container(
                width: 130,
                height: 130,
                // color: Colors.amber,
                child: Lottie.asset("assets/lottie/iconPage/loading.json"),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
              elevation: 2,
              shadowColor: Color(0xFFF4F1F6),
              title: const Text(
                "Checkout",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 22,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 75,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9C62FF),
                    blurRadius: 6,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C62FF),
                      minimumSize: Size(180, 65),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                    onPressed: () {
                      Get.offAll(PaymentPage());
                    },
                    child: const Text(
                      "Buat Pesanan",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Total Pembayaran",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF585858)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Rp${result[0]['harga'] + ongkir}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9C62FF)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            body: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 22,
                                      // color: Colors.amber,
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Color(0xFF9C62FF),
                                        size: 23,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Container(
                                      width: 310,
                                      // color: Colors.deepPurple,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Alamat pengiriman",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            "${modelsAlamat[0]['nama_lengkap_alamat']} | ${modelsAlamat[0]['no_hp_alamat']}",
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            "${modelsAlamat[0]['detail_jalan']}, ${modelsAlamat[0]['detail_patokan']}",
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            "KAB. ${modelsAlamat[0]['kota']}, ${modelsAlamat[0]['provinsi']}"
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            "${modelsAlamat[0]['kode_pos']}",
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 21,
                                      // color: Color.fromARGB(255, 129, 88, 198),
                                      child: const Icon(
                                        Icons.navigate_next_rounded,
                                        size: 30,
                                        color: Color(0xFFB0B0B0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 10,
                          color: const Color(0xFFF5F5F5),
                        ),
                        Container(
                          width: bodyWidth * 10,
                          height: 40,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.storefront_outlined,
                                color: Color(0xFF636363),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                result[0]['nama_lengkap'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: bodyWidth * 10,
                          color: const Color(0xFFF5F5F5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: double.infinity,
                                    color: Colors.white,
                                    child: Image(
                                      image: MemoryImage(
                                        base64.decode(result[0]['gambar']),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: 280,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          result[0]['nama_produk'],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          "Rp${result[0]['harga']}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Color(0xff727272)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "x1",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(0xFF9252FF),
                            ),
                            InkWell(
                              onTap: () async {
                                final tes = await Get.to(ShippingOption(
                                  pengiriman: pengiriman,
                                ));
                                // final tes = await Navigator.of(context)
                                //     .push(MaterialPageRoute(
                                //   builder: (context) =>
                                //       ShippingOption(pengiriman: widget.pengiriman),
                                // ));
                                setState(() {
                                  pengiriman = tes;
                                });
                              },
                              // highlightColor: Colors.purple,
                              child: Container(
                                width: double.infinity,
                                color: const Color(0xFFF2EAFF),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Opsi Pengiriman",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF9252FF),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (pengiriman == null)
                                                  ? "pos".toUpperCase()
                                                  : pengiriman,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Estimasi pengiriman ${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['etd']}"
                                                  .capitalize!,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xff727272)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Rp${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              FontAwesomeIcons.angleRight,
                                              size: 15,
                                              color: Color(0xFF868686),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(0xFF9252FF),
                            ),
                          ],
                        ),
                        Container(
                          width: bodyWidth * 10,
                          height: 10,
                          color: Color(0xFFF5F5F5),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Pesan (1 Produk):",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Rp${result[0]['harga']}",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF9C62FF),
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: bodyWidth * 10,
                          height: 10,
                          color: Color(0xFFF5F5F5),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: bodyWidth * 10,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.circleDollarToSlot,
                                      size: 22,
                                      color: Color(0xFF9C62FF),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Metode Pembayaran",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xff727272)),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Transfer Bank - Bank BRI",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.angleRight,
                                      size: 15,
                                      color: Color(0xFF868686),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: bodyWidth * 10,
                          height: 10,
                          color: Color(0xFFF5F5F5),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              left: 12, top: 15, bottom: 15, right: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit_calendar_outlined,
                                    size: 28,
                                    color: Color(0xFF9C62FF),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rincian Pembayaran",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal untuk produk",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Rp${result[0]['harga']}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal Pengiriman",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Rp${ongkir}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 17),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Pembayaran",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Rp${result[0]['harga'] + ongkir}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9C62FF),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: bodyWidth * 10,
                          height: 5,
                          color: Color(0xFFF5F5F5),
                        ),
                      ],
                    );
                  },
                )),
          );
  }
}
