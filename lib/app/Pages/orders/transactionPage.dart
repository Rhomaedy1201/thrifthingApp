import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/main/orderDetailsPage.dart';
import 'package:trifthing_apps/app/Pages/main/searchPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
import '/app/bodyPages/transaksi.dart';
import 'package:http/http.dart' as http;

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<dynamic> result = [];
  var responseData;

  bool isLoading = false;

  Future<void> getTransaksi() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    Uri url = Uri.parse("$apiGetTransaksi?id_user=${lastId}");
    var response = await http.get(url);
    responseData = jsonDecode(response.body);
    result = responseData['result'];

    for (var i = 0; i < result.length; i++) {}

    setState(() {
      isLoading = false;
    });
  }

  bool loading = false;
  @override
  void initState() {
    getTransaksi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getTransaksi();
      },
      child: isLoading
          ? const SmallLoadingWidget()
          : ListView(
              children: [
                TransactionBody(),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: (responseData['code'] == 400)
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
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
                                    "Transaksi Masih Kosong!!",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Silahkan melakukan transaksi atau beli pakaian yang anda suka",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF707070),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  InkWell(
                                    onTap: () {
                                      Get.to(SearchPage());
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
                                          "Cari Pakaian",
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
                          : GridView.builder(
                              itemCount: result.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(OrderDetailsPage(
                                      id_alamat_user:
                                          "${result[index]['id_alamat_user']}",
                                      id_transaksi:
                                          "${result[index]['id_transaksi']}",
                                    ));
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFFC1C1C1),
                                          blurRadius: 4,
                                          offset:
                                              Offset(0, 0), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .shopping_cart_checkout_outlined,
                                                        color: Colors.amber,
                                                        size: 25,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                            "Belanja",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${DateFormat("dd-MMM-yyyy HH:mm").format(DateTime.parse(result[index]['tanggal_beli']))}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xff727272),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 7),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: (result[index][
                                                                      'status'] ==
                                                                  'belum dibayar' ||
                                                              result[index][
                                                                      'status'] ==
                                                                  'pembayaran dikonfirmasi')
                                                          ? const Color(
                                                              0xFFF6ECCF)
                                                          : const Color(
                                                              0x4F10DF28),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${result[index]['status']}"
                                                            .capitalizeFirst!,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: (result[index][
                                                                          'status'] ==
                                                                      'belum dibayar' ||
                                                                  result[index][
                                                                          'status'] ==
                                                                      'pembayaran dikonfirmasi')
                                                              ? const Color(
                                                                  0xFFFFAA00)
                                                              : const Color(
                                                                  0xFF048D44),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                color: Color(0xFFC2C2C2),
                                              ),
                                              const SizedBox(height: 2),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          color: Colors.white,
                                                          // image: DecorationImage(
                                                          //   image: MemoryImage(
                                                          //       base64Decode(
                                                          //           "${result[index]['produk'][0]['gambar']}")),
                                                          //   repeat: ImageRepeat
                                                          //       .noRepeat,
                                                          //   fit: BoxFit.contain,
                                                          // ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 8),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              // "${result2[index]['nama_produk']}",
                                                              "Nama produk",
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              // "${result[index]['transaksi'][0]['jumlah_beli']} Barang",
                                                              "2 barang",
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xff727272)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Total Belanja",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Rp ${NumberFormat('#,###').format(result[index]['total_pembayaran'])}"
                                                    .replaceAll(",", "."),
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 15,
                                childAspectRatio: 10 / 3.7,
                              ),
                              shrinkWrap: true,
                              primary: false,
                              physics: const ScrollPhysics(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
