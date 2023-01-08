import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/main/categoryPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import '/app/widgets/categoryProduct.dart';
import '/app/widgets/itemsRecomendation.dart';
import 'package:http/http.dart' as http;

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    getTransaksi();
    super.initState();
  }

  List<dynamic> result = [];
  var responseData;
  int? tgl;
  bool isLoading = false;

  Future<void> getTransaksi() async {
    DateFormat dateFormat = DateFormat("dd");
    String day = dateFormat.format(DateTime.now());
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    Uri url = Uri.parse("$apiGetTransaksi?id_user=${lastId}");
    var response = await http.get(url);
    responseData = jsonDecode(response.body);
    result = responseData['result'];

    print(response.body);
    for (var i = 0; i < result.length; i++) {
      var cek =
          DateFormat("dd").format(DateTime.parse(result[i]['tanggal_beli']));
      tgl = int.parse(cek) + 1;

      if (int.parse(day) >= tgl! && result[i]['status'] == "belum dibayar") {
        Uri url2 = Uri.parse(
            "$deleteDetailTrans?id_transaksi=${result[i]['id_transaksi']}");
        var response2 = await http.delete(url2);
        print(response2.body);
      } else {
        print("gausah hapus karena sudah dibayar");
      }

      print("cek $cek");
      print("cek2 $tgl");
      print("$day");
      print("${result[0]['status']}");
    }

    setState(() {
      isLoading = false;
    });
  }

  int _current = 0;

  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'assets/images/banner2.webp',
    'assets/images/banner1.jpeg',
    'assets/images/banner3.jpeg',
    'assets/images/banner5.jpeg',
    'assets/images/banner6.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final myAppBar = PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ListView(
        children: [
          Container(
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 1.7,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList
                  .map((item) => Container(
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      item,
                                    ),
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 9.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF6F1CFF))
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kategori Produk",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4B5C),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(CategoryPage(
                      type: true,
                    ));
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Lihat semua",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 13,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          CategoryProduct(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Rekomendasi",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4B5C),
                  ),
                ),
              ],
            ),
          ),
          ItemsRecomendation(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
