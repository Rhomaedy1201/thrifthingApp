import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/models/cart_modal.dart';
import 'package:trifthing_apps/app/services/service_cart.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
import '/app/controllers/controll.dart';
import '/app/models/details_alamat_model.dart';
import '../payment/paymentPage.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class CheckoutPage extends StatefulWidget {
  var idKotaPengirim, berat;
  DateTime now = DateTime.now();
  CheckoutPage({
    super.key,
    this.idKotaPengirim,
    this.berat,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;
  bool loadingProductFromCart = false;

  List<CartModal> resultFromCart = [];
  int subTotal = 0;
  int subJumlahBeli = 0;

  Future<void> getProductCart() async {
    setState(() {
      loadingProductFromCart = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();

    resultFromCart = await ServiceCart().getCart(id_user_pembeli: "$lastId");

    if (resultFromCart.length > 0) {
      int total = 0;
      int jumlah = 0;
      for (var i = 0; i < resultFromCart.length; i++) {
        // sub total harga produk
        total += resultFromCart[i].total!;
        subTotal = total;
        // sub jumlah beli
        jumlah += resultFromCart[i].jumlah!;
        subJumlahBeli = jumlah;
      }
    } else {
      subTotal = 0;
    }

    setState(() {
      loadingProductFromCart = false;
    });
  }

  String? currentId;

  List resultAlamat = [];
  var idKota;

  bool loadingPengiriman = false;

  // memanggil pengiriman seperti pos dan get alamat
  // Rest Api Pengiriman RajaOngkir
  // Rest Api Alamat user
  var resultPengiriman;
  getPengiriman() async {
    // get alamat user
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastId;
      isLoading = true;
    });

    try {
      Uri url =
          Uri.parse("$apiGetDetailAlamat?id_user=${currentId.toString()}");
      final response2 = await http.get(url);
      if (response2.statusCode == 200) {
        resultAlamat = json.decode(response2.body)['result'];
        idKota = resultAlamat[0]['id_kota'];
        print(resultAlamat[0]['id_alamat_user']);
      } else {
        print("response status code Alamat ceckout salah");
      }
    } catch (e) {
      log("detail alamat $e");
    }

    setState(() {
      loadingPengiriman = true;
    });
    try {
      // get pengiriman
      Uri url2 = Uri.parse("https://api.rajaongkir.com/starter/cost");
      var data = {
        "origin": "${widget.idKotaPengirim}",
        "destination": "$idKota",
        "weight": "${1500}",
        "courier": "pos",
      };
      var dataHeader = {
        "key": "d94bc123ecd740dfcfb52e76e0439035",
        "content-type": "application/x-www-form-urlencoded",
      };

      final response = await http.post(
        url2,
        headers: dataHeader,
        body: data,
      );

      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          resultPengiriman = jsonDecode(response.body);
        });
      } else {
        log("api rajaongkir ${response.statusCode}");
      }
    } catch (e) {
      log("pengiriman $e");
    }

    setState(() {
      isLoading = false;
      loadingPengiriman = false;
    });
  }

  // generate id transkasi
  var idTrans;
  Future<void> TransaksiId() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse("$apiGetIdTransaksi");
      var response = await http.get(url);
      var resultId = json.decode(response.body)['result'][0]['id_transaksi'];
      idTrans = resultId + 1;
      print(" t : ${idTrans}");
    } catch (e) {
      log("trans id $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  bool loadingTransaksi = false;
  // melakukan transaksi
  Future<void> postTransaksi() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String datetime = dateFormat.format(DateTime.now());

    setState(() {
      loadingTransaksi = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();

    try {
      Uri url = Uri.parse("$apiPostTransaksi");
      var data = {
        "id_transaksi": "${idTrans.toString()}",
        "id_alamat_user": "$lastId",
        "id_pengiriman": "1",
        "harga_pengiriman":
            "${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
        "no_resi": "",
        "id_rekening": "1",
        "total_pembayaran":
            "${subTotal + resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
        "bukti_pembayaran": "",
        "tanggal_beli": "$datetime",
        "tanggal_terima": "",
        "status": "belum dibayar",
      };

      var response = await http.post(url, body: data);
      var hasil = json.decode(response.body);
      if (hasil[0]['type'] == true) {
        postDetailTransaksi();
        Get.offAll(PaymentPage(
          idTransaksi: idTrans.toString(),
          id_alamat_penerima: "$lastId",
        ));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF1FA324),
            content: Text(
              'Checkout barang berhasil, silahkan melakukan pembayaran!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print("terjadi kesalahan untuk post transaksi");
      }
    } catch (e) {
      log("pos trans $e");
    }

    setState(() {
      loadingTransaksi = false;
    });
  }

  Future<void> postDetailTransaksi() async {
    try {
      Uri url = Uri.parse("$apiPostDetailTransaksi");
      var data = {
        "id_transaksi": "${idTrans.toString()}",
        "id_produk": "${1}",
        "jumlah": "${1}",
      };

      var response = await http.post(url, body: data);
      print("post detail : ${response.body}");
    } catch (e) {
      log("post detail $e");
    }
  }

  int ongkir = 20000;
  int? hargaBr;
  int? totalPesan;
  int? subTotalProduk;
  var estimasi;
  var typePegriman;
  int? hargaPengiriman;
  var estimasiPengiriman;
  List<int>? convertEstimasi;

  var pembayaran = "bri";

  @override
  void initState() {
    getProductCart();
    TransaksiId();
    getPengiriman();
    // print(widget.idKotaPenerima);
    // print(widget.idUser);
    // print(widget.berat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;

    Widget alamatPengiriman() {
      return InkWell(
        onTap: () {},
        child: Container(
          width: bodyWidth * 10,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: resultAlamat.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, indexAlamat) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Color(0xFF9C62FF),
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Container(
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Alamat pengiriman",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "${resultAlamat[indexAlamat]['nama_lengkap_alamat']} | ${resultAlamat[indexAlamat]['no_hp_alamat']}",
                                // "",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "${resultAlamat[indexAlamat]['detail_jalan']}, ${resultAlamat[indexAlamat]['detail_patokan']}",
                                // "",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "KAB. ${resultAlamat[indexAlamat]['kota']}, ${resultAlamat[indexAlamat]['provinsi']}"
                                    .toUpperCase(),
                                // "",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "${resultAlamat[indexAlamat]['kode_pos']}",
                                // "",
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )),
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
              );
            },
          ),
        ),
      );
    }

    Widget produkItem() {
      return Column(
        children: [
          Container(
            width: double.infinity,
            height: 10,
            color: const Color(0xFFF5F5F5),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
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
                      // result[index]['nama_lengkap'],
                      "Nama Penjual",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: resultFromCart.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                width: bodyWidth * 10,
                color: const Color(0xFFF5F5F5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              base64.decode(resultFromCart[index].gambar!),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                resultFromCart[index].namaProduk!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###,000').format(resultFromCart[index].harga)}"
                                    .replaceAll(",", "."),
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
                          "x${resultFromCart[index].jumlah}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      );
    }

    Widget loadingOpsiPengiriman() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE3E3E3),
          highlightColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 130,
                height: 23,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 200,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(25 / 2),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget opsiPengiriman() {
      return loadingPengiriman
          ? loadingOpsiPengiriman()
          : Column(
              children: [
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF9252FF),
                ),
                InkWell(
                  onTap: () async {
                    // final pindah = Get.to<String>(ShippingOption(pengiriman: ,));
                    // final tes = await Get.to(ShippingOption(
                    //   pengiriman: pengiriman,
                    //   idKotaPengirim: widget.idKotaPengirim,
                    //   idKotaPenerima: widget.idKotaPenerima,
                    //   berat: widget.berat,
                    //   kurir: resultPengiriman['rajaongkir']
                    //       ['results'][0]['code'],
                    //   typePengiriman: typePegriman,
                    //   hargaPengiriman: hargaPengiriman,
                    //   estimasiPengiriman: estimasiPengiriman,
                    // ));

                    // setState(() {
                    // pengiriman = tes;
                    // });
                  },
                  // highlightColor: Colors.purple,
                  child: Container(
                      width: double.infinity,
                      color: const Color(0xFFF2EAFF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: resultAlamat.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${resultPengiriman['rajaongkir']['results'][index]['costs'][0]['service']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Estimasi pengiriman ${resultPengiriman['rajaongkir']['results'][index]['costs'][0]['cost'][0]['etd']}"
                                            .capitalize!,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff727272)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Rp${NumberFormat('#,###,000').format(resultPengiriman['rajaongkir']['results'][index]['costs'][0]['cost'][0]['value'])}"
                                            .replaceAll(",", "."),
                                        // "",
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
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
                          );
                        },
                      )),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF9252FF),
                ),
              ],
            );
    }

    Widget loadingTotalProduk() {
      return Container(
        width: double.infinity,
        height: 50,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: const Color(0xFFE3E3E3),
              highlightColor: Colors.white,
              child: Container(
                width: 180,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: const Color(0xFFE3E3E3),
              highlightColor: Colors.white,
              child: Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget totalProduk() {
      return loadingPengiriman
          ? loadingTotalProduk()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
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
                            "Total Pesan (${subJumlahBeli} Produk):",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Rp${NumberFormat('#,###,000').format(subTotal)}"
                                .replaceAll(",", "."),
                            style: const TextStyle(
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
                      color: const Color(0xFFF5F5F5),
                    ),
                  ],
                );
              },
            );
    }

    Widget metodePembayaran() {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                  height: 220,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Metode Pembayaran :",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  pembayaran = "bri";
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFC6C6C6),
                                      blurRadius: 3,
                                      offset: Offset(0, 0), // Shadow position
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 5, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: const Image(
                                            image: AssetImage(
                                                "assets/logo/bri.png"),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          "Bank BRI",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    (pembayaran == "bri")
                                        ? const Icon(Icons.check,
                                            color: Color(0xFF9C62FF))
                                        : const Text("")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Pilih",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C62FF),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
        },
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
                    style: TextStyle(fontSize: 15, color: Color(0xff727272)),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Transfer Bank - Bank BRI",
                    style: TextStyle(fontSize: 14, color: Colors.black),
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
      );
    }

    Widget loadingRincianPembayaran() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Shimmer.fromColors(
          baseColor: const Color(0xFFE3E3E3),
          highlightColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 220,
                height: 23,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 160,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 160,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(25 / 2),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    Widget rincianPembayaran() {
      return Column(
        children: [
          Container(
            width: bodyWidth * 10,
            height: 10,
            color: const Color(0xFFF5F5F5),
          ),
          loadingPengiriman
              ? loadingRincianPembayaran()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 12, top: 15, bottom: 15, right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: const [
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
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal untuk produk",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###,000').format(subTotal)}"
                                    .replaceAll(",", "."),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal Pengiriman",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###,000').format(resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value'])}"
                                    .replaceAll(",", "."),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Pembayaran",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Rp${NumberFormat('#,###,000').format(subTotal + resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value'])}"
                                    .replaceAll(",", "."),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9C62FF),
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
            width: bodyWidth * 10,
            height: 5,
            color: Color(0xFFF5F5F5),
          ),
        ],
      );
    }

    Widget loadingBottomBar() {
      return Shimmer.fromColors(
        baseColor: const Color(0xFFE3E3E3),
        highlightColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 160,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 160,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(25 / 2),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget body() {
      return Column(
        children: [
          alamatPengiriman(),
          produkItem(),
          opsiPengiriman(),
          totalProduk(),
          metodePembayaran(),
          rincianPembayaran(),
        ],
      );
    }

    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
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
                child: loadingProductFromCart
                    ? const SmallLoadingWidget()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loadingTransaksi
                                  ? const SmallLoadingWidget()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF9C62FF),
                                        minimumSize: const Size(180, 65),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        postTransaksi();
                                      },
                                      child: const Text(
                                        "Buat Pesanan",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                              loadingPengiriman
                                  ? loadingBottomBar()
                                  : Container(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Total Pembayaran",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF585858),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Rp${NumberFormat('#,###').format(subTotal + resultPengiriman['rajaongkir']['results'][index]['costs'][0]['cost'][0]['value'])}"
                                                .replaceAll(",", "."),
                                            style: const TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF9C62FF)),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          );
                        },
                      )),
            body: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    body(),
                  ],
                ),
              ),
            ),
          );
  }
}
