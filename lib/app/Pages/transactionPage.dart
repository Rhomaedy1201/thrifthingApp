import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/orderDetailsPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import '/app/bodyPages/transaksi.dart';
import 'package:http/http.dart' as http;

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<dynamic> result = [];
  Future<void> getTransaksi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    var currentId = lastId;
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/transaksi/get_transaksi.php?id_alamat_user=${currentId}");
    var response = await http.get(url);
    result = json.decode(response.body)['result'];
    setState(() {});
  }

  @override
  void initState() {
    getTransaksi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TransactionBody(),
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: GridView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(OrderDetailsPage(
                        id_alamat_user: "${result[index]['id_alamat_user']}",
                        id_transaksi: "${result[index]['id_transaksi']}",
                      ));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFC1C1C1),
                            blurRadius: 4,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_checkout_outlined,
                                          color: Colors.amber,
                                          size: 25,
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Belanja",
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${result[index]['transaksi'][0]['tanggal_beli']}",
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 25,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: (result[index]['transaksi'][0]
                                                        ['status'] ==
                                                    'belum dibayar' ||
                                                result[index]['transaksi'][0] ==
                                                    'pembayaran dikonfirmasi')
                                            ? Color(0xFFF6ECCF)
                                            : Color(0x4F10DF28),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${result[index]['transaksi'][0]['status']}"
                                              .capitalizeFirst!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: (result[index]['transaksi']
                                                            [0]['status'] ==
                                                        'belum dibayar' ||
                                                    result[index]['transaksi']
                                                            [0] ==
                                                        'pembayaran dikonfirmasi')
                                                ? Color(0xFFFFAA00)
                                                : Color(0xFF048D44),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Color(0xFFC2C2C2),
                                ),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: MemoryImage(base64Decode(
                                              "${result[index]['produk'][0]['gambar']}")),
                                          repeat: ImageRepeat.noRepeat,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${result[index]['produk'][0]['nama_produk']}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "${result[index]['transaksi'][0]['jumlah_beli']} Barang",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xff727272)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Belanja",
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "Rp ${result[index]['transaksi'][0]['total_pembayaran']}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 15,
                  childAspectRatio: 10 / 3.7,
                ),
                shrinkWrap: true,
                primary: false,
                physics: ScrollPhysics(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
