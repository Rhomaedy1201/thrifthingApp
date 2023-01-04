import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:trifthing_apps/app/Pages/main/searchPage.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/shimmer_loading_products.dart';
import 'detailProductPage.dart';
import 'package:http/http.dart' as http;

class DisplayResultSearch extends StatefulWidget {
  var namaProduk, data;
  DisplayResultSearch({super.key, this.namaProduk, this.data});

  @override
  State<DisplayResultSearch> createState() => _DisplayResultSearchState();
}

class _DisplayResultSearchState extends State<DisplayResultSearch> {
  bool isLoading = true;

  var namaProduk, data;
  _DisplayResultSearchState({this.namaProduk, this.data});
  TextEditingController getText = TextEditingController();
  List<dynamic> result = [];
  void getData() async {
    setState(() {
      // isLoading = true;
    });

    try {
      final _baseUrl =
          "$apiSearchProduk?nama_produk=${getText.text.toString()}";
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        result = jsonDecode(response.body)[0]['result'];
        setState(() {});
      } else {
        print("response status code detail produk salah");
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      // isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getText.text = widget.namaProduk;
    getData();
    Timer(
      Duration(seconds: 2),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,

        // leadingWidth: 40,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: const Color(0xFFEDECF5),
          ),
          margin: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: TextField(
              textInputAction: TextInputAction.search,
              enabled: false,
              controller: getText,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 25,
                  color: Color(0xff727272),
                ),
                hintText: 'Cari Baju...',
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
      ),
      body: Container(
        margin: const EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 5),
        child: (widget.data <= 0)
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 300,
                      child: Lottie.asset(
                          'assets/lottie/iconPage/barang-kosong.json'),
                      color: Colors.transparent,
                    ),
                    const Text(
                      "Hasil tidak ditemukan!!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Produk kosong atau coba kata kunci yang lain atau yang lebih umum",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF707070),
                      ),
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF7F42E8),
                        ),
                        child: const Center(
                          child: Text(
                            "Coba kata kunci lain",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : isLoading
                ? const ShimmerLoadingProducts()
                : GridView.builder(
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(DetailProductPage(
                            idProduk: result[index]['id_produk'],
                            idUser: result[index]['id_user'],
                            idKategori: result[index]['id_kategori'],
                          ));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFEBE8F5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 5),
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: MemoryImage(
                                        base64.decode(result[index]['gambar'])),
                                    repeat: ImageRepeat.noRepeat,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result[index]['nama_produk'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF727272),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Rp${NumberFormat('#,###').format(result[index]['harga'])}"
                                          .replaceAll(",", "."),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF6754B4),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF9D9D9D),
                                          size: 18,
                                        ),
                                        Text(
                                          (result[index]['kota'] == null)
                                              ? "Alamat kosong"
                                              : "${result[index]['kota']}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff727272)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 10 / 13.25,
                    ),
                    shrinkWrap: true,
                    primary: false,
                  ),
      ),
    );
  }
}
