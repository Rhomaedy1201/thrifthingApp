import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

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
  var idKotaPengirim, idKotaPenerima, berat, jmlBeli;
  DateTime now = DateTime.now();
  CheckoutPage({
    super.key,
    this.idProduk,
    this.idUser,
    this.idKat,
    this.pengiriman,
    this.idKotaPengirim,
    this.idKotaPenerima,
    this.berat,
    this.jmlBeli,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int? totalPembayaran;

  DetailsAlamat alamat = DetailsAlamat();
  String? currentId;

  var loading = false;

  var resultAlamat;
  var modelsAlamat;
  var idKota;

  // memanggil alamat pembeli
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
        print(modelsAlamat[0]['id_alamat_user']);
      });
    } else {
      print("response status code Alamat ceckout salah");
    }
  }

  // memanggil data produk
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

  // memanggil pengiriman seperti pos
  var resultPengiriman;
  getPengiriman() async {
    getData();
    getAlamat();
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    var data = {
      "origin": "${widget.idKotaPengirim}",
      "destination": "${widget.idKotaPenerima}",
      "weight": "${widget.berat}",
      "courier": "${widget.pengiriman}",
    };
    var dataHeader = {
      "key": "d94bc123ecd740dfcfb52e76e0439035",
      "content-type": "application/x-www-form-urlencoded",
    };

    final response = await http.post(
      url,
      headers: dataHeader,
      body: data,
    );
    resultPengiriman = jsonDecode(response.body);
    print(resultPengiriman['rajaongkir']['status']['code']);
    if (resultPengiriman['rajaongkir']['status']['code'] == 200) {
      print(resultPengiriman['rajaongkir']['results'][0]['code']);
      // print(resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]
      //     ['value']);
      setState(() {});
    } else {
      print("response status code checkout produk salah");
    }
  }

  // generate id transkasi
  var idTrans;
  Future<void> TransaksiId() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/transaksi/get_idTransaksi.php");
    var response = await http.get(url);
    var resultId = json.decode(response.body)['result'][0]['id_transaksi'];
    idTrans = resultId + 1;
    print(" t : ${idTrans}");
  }

  // melakukan transaksi
  Future<void> postTransaksi() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String datetime = dateFormat.format(DateTime.now());

    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/transaksi/pos_transaksi.php");
    var data = {
      "id_transaksi": "${idTrans.toString()}",
      "id_alamat_user": "${modelsAlamat[0]['id_alamat_user']}",
      "id_pengiriman": "1",
      "harga_pengiriman":
          "${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
      "no_resi": "",
      "id_rekening": "${result[0]['id_rekening']}",
      "total_pembayaran":
          "${result[0]['harga'] + resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
      "bukti_pembayaran": "",
      "tanggal_beli": "$datetime",
      "tanggal_terima": "",
      "status": "belum dibayar",
    };

    var response = await http.post(url, body: data);
    var hasil = json.decode(response.body);
    if (hasil[0]['type'] == true) {
      postDetailTransaksi();
      Get.offAll(PaymentPage());
    } else {
      print("terjadi kesalahan untuk post transaksi");
    }
    print(response.body);
  }

  Future<void> postDetailTransaksi() async {
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/transaksi/pos_detail_transaksi.php");
    var data = {
      "id_transaksi": "${idTrans.toString()}",
      "id_produk": "${result[0]['id_produk']}",
      "jumlah": "${widget.jmlBeli}",
    };

    var response = await http.post(url, body: data);
    print("post detail : ${response.body}");
  }

  int ongkir = 20000;
  int? hargaBr;
  int? totalPesan;
  int? subTotalProduk;
  var pengiriman = "pos";
  var estimasi;
  var typePegriman;
  int? hargaPengiriman;
  var estimasiPengiriman;
  List<int>? convertEstimasi;

  var pembayaran = "bri";

  @override
  void initState() {
    TransaksiId();
    getAlamat();
    getData();
    getPengiriman();
    print(widget.idKotaPenerima);
    print(widget.idUser);
    print(widget.berat);
    print(widget.pengiriman);
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = true;
      });
    });
    setState(() {});
    print("back");
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
                  // FutureBuilder(
                  //   future: getPengiriman(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Expanded(
                  //         child: Text("laoding..."),
                  //       );
                  //     } else if (snapshot.hasData) {
                  //       return
                  //     }
                  //     return Text("Show data");
                  //   },
                  // ),
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
                          "Rp${result[0]['harga'] + resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF9C62FF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
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
                                    "x${widget.jmlBeli}",
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
                                              "${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['service']}",
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
                                "Total Pesan (${widget.jmlBeli} Produk):",
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
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                    height: 220,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 17, vertical: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Metode Pembayaran :",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    pembayaran = "bri";
                                                  });
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0xFFC6C6C6),
                                                        blurRadius: 3,
                                                        offset: Offset(0,
                                                            0), // Shadow position
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 5,
                                                      right: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            child: Image(
                                                              image: AssetImage(
                                                                  "assets/logo/bri.png"),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15),
                                                          Text(
                                                            "Bank BRI",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      (pembayaran == "bri")
                                                          ? Icon(Icons.check,
                                                              color: Color(
                                                                  0xFF9C62FF))
                                                          : Text("")
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
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF9C62FF),
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
                                    "Rp${resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
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
                                    "Rp${result[0]['harga'] + resultPengiriman['rajaongkir']['results'][0]['costs'][0]['cost'][0]['value']}",
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
