import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';
import 'buktiPembayaran.dart';
import '../main/home_screen.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  var idTransaksi;
  var id_alamat_penerima;

  PaymentPage({
    super.key,
    this.idTransaksi,
    this.id_alamat_penerima,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    getTransaksi();
    print(widget.idTransaksi);
    print(widget.id_alamat_penerima);
    super.initState();
  }

  var noRekening;
  DateTime dt = DateTime.now();
  bool isLoading = false;

  // get transaksi
  List result = [];
  Future<void> getTransaksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse(
          "$apiGetTransaksi?id_alamat_user=${widget.id_alamat_penerima}&id_transaksi=${widget.idTransaksi}");
      var response = await http.get(url);
      result = json.decode(response.body)['result'];
    } catch (e) {
      log(e.toString());
    }

    Timer(
      const Duration(seconds: 2),
      () async {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Color(0xFFEBEBEB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 2,
              shadowColor: const Color(0xFFF4F1F6),
              iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
              title: const Text(
                "Info Pembayaran",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 22,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getTransaksi();
              },
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      (result[index]['transaksi'][0]['bukti_pembayaran'] == "")
                          ? Container()
                          : Container(
                              width: double.infinity,
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9C62FF),
                                    blurRadius: 2,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Pembayaran Berhasil!",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF01C78C),
                                    ),
                                  ),
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 22,
                                    color: Color(0xFF01C78C),
                                  )
                                ],
                              ),
                            ),
                      // SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9C62FF),
                              blurRadius: 2,
                              offset: Offset(0, 0), // Shadow position
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Pembayaran:",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Text(
                                "Rp ${NumberFormat('#,###,000').format(result[index]['transaksi'][0]['total_pembayaran'])}"
                                    .replaceAll(",", "."),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF9C62FF)),
                              ),
                              Text(
                                "Bayar pesanan sesuai jumlah di atas",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF01C78C)),
                              ),
                              Text(
                                "dicek dalam 24 jam setelah bukti transfer diupload",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Gunakan ATM / iBankng / mBanking / Setor \ntunai untuk transfer ke rekening berikut ini:",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff727272),
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9C62FF),
                              blurRadius: 2,
                              offset: Offset(0, 0), // Shadow position
                            ),
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 20,
                                    child: const Image(
                                      image: AssetImage("assets/logo/bri.png"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 251,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${result[index]['metode_pembayaran'][0]['nama_bank']}"
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "No. Rekening: ${result[index]['metode_pembayaran'][0]['no_rekening']}",
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "Nama pemilik: ${result[index]['metode_pembayaran'][0]['nama_pemilik_bank']}",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text: noRekening.toString()));
                                },
                                child: const Text(
                                  "SALIN",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF01C78C)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 16, top: 15),
                            child: const Text(
                              "* Hanya menerima dari Bank BRI",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff727272)),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 19,
                              height: 19,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Silahkan upload bukti transfer sebelum tanggal:\n${dt.day + 1}-${dt.month}-${dt.year} ${dt.hour}:${dt.minute}",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff727272),
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.to(BuktiPembayaran(
                              id_tansaksi: widget.idTransaksi,
                              id_alamat_user: widget.id_alamat_penerima,
                            ));
                          },
                          child: Text(
                            (result[index]['transaksi'][0]
                                        ['bukti_pembayaran'] !=
                                    "")
                                ? "Lihat bukti transfer"
                                : "Upload bukti transfer sekarang",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9C62FF),
                            minimumSize: Size(double.infinity, 55),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAll(HomeScreen());
                            Get.back();
                          },
                          child: Text(
                            (result[0]['transaksi'][0]['bukti_pembayaran'] !=
                                    "")
                                ? "Kembali ke home"
                                : "Upload bukti transfer nanti",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9C62FF)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEBEBEB),
                            minimumSize: Size(double.infinity, 55),
                            side:
                                BorderSide(width: 2, color: Color(0xFF9C62FF)),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
  }
}
