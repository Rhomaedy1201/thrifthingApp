import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/app/Pages/deliveryStatusPage.dart';
import '/app/Pages/paymentPage.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {
  var id_alamat_user, id_transaksi;
  OrderDetailsPage({super.key, this.id_alamat_user, this.id_transaksi});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String noResi = "";

  SnackBar resiTrue = const SnackBar(
    content: Text(
      "No Resi telah tersalin",
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    backgroundColor: Color(0xff727272),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  );

  SnackBar resiFalse = const SnackBar(
    content: Text(
      "No Resi masih belum diupdate oleh penjual!!",
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    backgroundColor: Color(0xff727272),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
  );

  // get transaksi
  List result = [];
  Future<void> getTransaksi() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/transaksi/get_transaksi.php?id_alamat_user=${widget.id_alamat_user}&id_transaksi=${widget.id_transaksi}");
    var response = await http.get(url);
    result = json.decode(response.body)['result'];
    setState(() {});
    // print(result);
  }

  // get alamat user
  var alamat;
  Future<void> getAlamat() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/detail_alamat_user/get_detail_alamat.php?id_user=2");
    var response = await http.get(url);
    alamat = jsonDecode(response.body)['result'];
    print(alamat);
  }

  @override
  void initState() {
    getTransaksi();
    getAlamat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 2,
        shadowColor: Color(0xFFF4F1F6),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 22,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${result[0]['transaksi'][0]['status']}".capitalizeFirst!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(PaymentPage(
                          idTransaksi: "1",
                        ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Lihat Detail",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Icon(
                            Icons.navigate_next_outlined,
                            color: Color(0xff727272),
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(
                  color: Color(0xFFCECECE),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tanggal pembelian",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff727272)),
                    ),
                    Text(
                      "${result[0]['transaksi'][0]['tanggal_beli']}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 8,
            color: Color(0xFFF1F1F1),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail Produk",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFC1C1C1),
                            blurRadius: 4,
                            offset: Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(base64Decode(
                                          "${result[0]['produk'][0]['gambar']}")),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Container(
                                width: 285,
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${result[0]['produk'][0]['nama_produk']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "1 x Rp${result[0]['produk'][0]['harga']}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff727272),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: Color(0xFFCECECE),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Total Harga",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff727272),
                                ),
                              ),
                              Text(
                                "Rp${result[0]['transaksi'][0]['total_pembayaran']}",
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 15,
                    childAspectRatio: 7 / 2.5,
                  ),
                  shrinkWrap: true,
                  primary: false,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 8,
            color: Color(0xFFF1F1F1),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Info Pengiriman",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(DeliveryStatusPage());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Lihat Pengiriman",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Icon(
                            Icons.navigate_next_outlined,
                            color: Color(0xff727272),
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kurir",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff727272),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 70,
                            child: InkWell(
                              onTap: () {
                                (result[0]['pengiriman'][0]['no_resi'] ==
                                            null ||
                                        result[0]['pengiriman'][0]['no_resi'] ==
                                            "")
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(resiFalse)
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(resiTrue);
                                Clipboard.setData(
                                  ClipboardData(
                                    text: noResi.toString(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "No Resi",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff727272),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.copy,
                                    size: 18,
                                    color: Color(0xff727272),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Alamat",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xff727272),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${result[0]['pengiriman'][0]['nama_pengiriman']} reguler"
                                .capitalize!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (result[0]['pengiriman'][0]['no_resi'] == null ||
                                    result[0]['pengiriman'][0]['no_resi'] == "")
                                ? "- (Penjual belum update No. Resi)"
                                : "${result[0]['pengiriman'][0]['no_resi']}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${alamat[0]['nama_lengkap_alamat']}\n${alamat[0]['no_hp_alamat']}\n${alamat[0]['detail_jalan']} (${alamat[0]['detail_patokan']})\n" +
                                "KAB. ${alamat[0]['kota']}, ${alamat[0]['provinsi']} ${alamat[0]['kode_pos']}"
                                    .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 8,
            color: Color(0xFFF1F1F1),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rincian Pembayaran",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Metode pembayaran",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff727272)),
                    ),
                    Text(
                      "Bank ${result[0]['metode_pembayaran'][0]['nama_bank']}"
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff000000)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(
                  color: Color(0xFFCECECE),
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Harga (${result[0]['transaksi'][0]['jumlah_beli']} barang)",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff727272)),
                    ),
                    Text(
                      "Rp${result[0]['produk'][0]['harga']}",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff000000)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Ongkos Kirim",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff727272)),
                    ),
                    Text(
                      "Rp${result[0]['pengiriman'][0]['harga_pengiriman']}",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff000000)),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Divider(
                  color: Color(0xFFCECECE),
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Belanja",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    Text(
                      "Rp${result[0]['transaksi'][0]['total_pembayaran']}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
