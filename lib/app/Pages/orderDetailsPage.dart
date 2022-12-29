import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
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
  @override
  void initState() {
    getTransaksi();
    getAlamat();
    super.initState();
  }

  String noResi = "";
  bool isLoading = false;
  bool isLoadingAlamat = false;

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
    setState(() {
      isLoading = true;
    });

    Uri url = Uri.parse(
        "$apiGetTransaksi?id_alamat_user=${widget.id_alamat_user}&id_transaksi=${widget.id_transaksi}");
    var response = await http.get(url);
    result = json.decode(response.body)['result'];

    setState(() {
      isLoading = false;
    });
  }

  // get alamat user
  var alamat;
  Future<void> getAlamat() async {
    setState(() {
      isLoadingAlamat = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    var currentId = lastId;
    Uri url = Uri.parse("$apiGetDetailAlamat?id_user=$currentId");
    var response = await http.get(url);
    alamat = jsonDecode(response.body)['result'];

    setState(() {
      isLoadingAlamat = false;
    });
  }

  var resultUpdateStatus;
  bool loadingStatus = false;
  Future<void> updateStatus() async {
    setState(() {
      loadingStatus = true;
    });

    try {
      Uri url = Uri.parse(
          "$updateStatusTrans?id_transaksi=${widget.id_transaksi}&status=Diterima");
      var response = await http.put(url);
      setState(() {
        resultUpdateStatus = json.decode(response.body)[0]['type'];
      });
      print(response.body);
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      loadingStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: loadingStatus
                ? const SmallLoadingWidget()
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                        height: 47,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: result.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              onPressed: result[index]['transaksi'][0]
                                              ['status'] ==
                                          "Diproses" ||
                                      result[index]['transaksi'][0]['status'] ==
                                          "Dikirim"
                                  ? resultUpdateStatus == "Diterima"
                                      ? null
                                      : () {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.warning,
                                            text:
                                                'Apakah yakin sudah menerima barang?',
                                            confirmBtnColor: Colors.deepPurple,
                                            cancelBtnText: "Batal",
                                            confirmBtnText: "Terima",
                                            showCancelBtn: true,
                                            onCancelBtnTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            onConfirmBtnTap: () async {
                                              updateStatus();
                                              setState(() {
                                                getTransaksi();
                                              });
                                              Get.back();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      Color(0xFF1FA324),
                                                  content: Text(
                                                    'Barang sudah diterima👌',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9C62FF),
                              ),
                              child: const Text(
                                "Terima Pesanan",
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          },
                        )),
                  ),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
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
            body: RefreshIndicator(
              onRefresh: () => getTransaksi(),
              child: ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Container(
                        // color: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${result[index]['transaksi'][0]['status']}"
                                          .capitalizeFirst!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ),
                                    result[index]['transaksi'][0]['status'] !=
                                            "Sudah dibayar"
                                        ? Container()
                                        : result[index]['transaksi'][0]
                                                    ['status'] ==
                                                "Diproses"
                                            ? Container()
                                            : const Text(
                                                "Menunggu confirmasi penjual",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(PaymentPage(
                                      idTransaksi:
                                          "${result[index]['id_transaksi']}",
                                      id_alamat_penerima:
                                          "${result[index]['id_alamat_user']}",
                                    ));
                                  },
                                  child: Row(
                                    children: const [
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
                            const SizedBox(height: 5),
                            const Divider(
                              color: Color(0xFFCECECE),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tanggal pembelian",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff727272)),
                                ),
                                Text(
                                  "${DateFormat("dd-MMM-yyyy HH:mm").format(DateTime.parse(result[index]['transaksi'][0]['tanggal_beli']))}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: Color(0xFFF1F1F1),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 20, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail Produk",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFC1C1C1),
                                    blurRadius: 4,
                                    offset: Offset(0, 0), // Shadow position
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: MemoryImage(base64Decode(
                                                  "${result[0]['produk'][0]['gambar']}")),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      Container(
                                        width: 285,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${result[0]['produk'][0]['nama_produk']}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "1 x Rp${NumberFormat('#,###').format(result[0]['produk'][0]['harga'])}"
                                                  .replaceAll(",", "."),
                                              style: const TextStyle(
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
                                  const Divider(
                                    color: Color(0xFFCECECE),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Total Harga",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff727272),
                                        ),
                                      ),
                                      Text(
                                        "Rp${NumberFormat('#,###').format(result[0]['transaksi'][0]['total_pembayaran'])}"
                                            .replaceAll(",", "."),
                                        style: const TextStyle(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Info Pengiriman",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const DeliveryStatusPage());
                                  },
                                  child: Row(
                                    children: const [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            (result[index]['pengiriman'][0]
                                                            ['no_resi'] ==
                                                        null ||
                                                    result[index]['pengiriman']
                                                            [0]['no_resi'] ==
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
                                            children: const [
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
                                      const SizedBox(height: 10),
                                      const Text(
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
                                isLoadingAlamat
                                    ? const SmallLoadingWidget()
                                    : Container(
                                        width: 250,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${result[index]['pengiriman'][0]['nama_pengiriman']} reguler"
                                                  .capitalize!,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              (result[index]['pengiriman'][0]
                                                              ['no_resi'] ==
                                                          null ||
                                                      result[index]
                                                                  ['pengiriman']
                                                              [0]['no_resi'] ==
                                                          "")
                                                  ? "- (Penjual belum update No. Resi)"
                                                  : "${result[index]['pengiriman'][0]['no_resi']}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "${alamat[index]['nama_lengkap_alamat']}\n${alamat[index]['no_hp_alamat']}\n${alamat[index]['detail_jalan']} (${alamat[index]['detail_patokan']})\n" +
                                                  "KAB. ${alamat[index]['kota']}, ${alamat[index]['provinsi']} ${alamat[index]['kode_pos']}"
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
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: Color(0xFFF1F1F1),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: result.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Rincian Pembayaran",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Metode pembayaran",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff727272)),
                                ),
                                Text(
                                  "Bank ${result[index]['metode_pembayaran'][0]['nama_bank']}"
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(
                              color: Color(0xFFCECECE),
                            ),
                            const SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Harga (${result[index]['transaksi'][0]['jumlah_beli']} barang)",
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff727272)),
                                ),
                                Text(
                                  "Rp${NumberFormat('#,###').format(result[index]['produk'][0]['harga'])}"
                                      .replaceAll(",", "."),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Ongkos Kirim",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff727272)),
                                ),
                                Text(
                                  "Rp${NumberFormat('#,###').format(result[index]['pengiriman'][0]['harga_pengiriman'])}"
                                      .replaceAll(",", "."),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            const Divider(
                              color: Color(0xFFCECECE),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Belanja",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Rp${NumberFormat('#,###').format(result[index]['transaksi'][0]['total_pembayaran'])}"
                                      .replaceAll(",", "."),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
