import 'dart:convert';
import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/Pages/main/searchPage.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import 'package:trifthing_apps/app/services/service_cart.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
import '../orders/checkoutPage.dart';

class DetailProductPage extends StatefulWidget {
  var idProduk, idUser, idKategori;
  DetailProductPage({super.key, this.idProduk, this.idUser, this.idKategori});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  var idProduk, idUser, idKategori;

  List result = [];
  bool isLoading = false;

  int? stok;
  int jmlBeli = 1;

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final _baseUrl =
          "$apiProdukUser?id_produk=${widget.idProduk.toString()}&id_user=${widget.idUser.toString()}&id_kategori=${widget.idKategori.toString()}";
      final response = await http.get(Uri.parse(_baseUrl));
      print(response.body);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body)[0]['result'];
        stok = result[0]['stok'];
      } else {
        print("response status code detail produk salah");
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  String? currentId;
  var cekAddress;
  ceckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastId;
    });
    Uri url = Uri.parse("$apiGetDetailAlamat?id_user=${currentId.toString()}");
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode != null) {
      cekAddress = json.decode(response.body)['type'];
      setState(() {});
    } else {
      print("response status code profile user salah");
    }
  }

  bool? resultToCart;
  bool loadingToCart = false;
  Future<void> postToCart() async {
    setState(() {
      loadingToCart = true;
    });

    resultToCart = await ServiceCart().addToCart(
      idProduk: "${widget.idProduk}",
      idPembeli: "${currentId}",
      idPenjual: "${result[0]['id_user']}",
      jumlah: "$jmlBeli",
      total: "${result[0]['harga'] * jmlBeli}",
    );

    if (resultToCart == true) {
      showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Get.back();
            },
          );
          return AlertDialog(
            backgroundColor: Color.fromARGB(138, 15, 15, 15),
            actions: [
              Column(
                children: [
                  Container(
                    width: 270,
                    height: 50,
                    child: Lottie.asset(
                        "assets/lottie/iconAlert/icon-success2.json"),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Menambahkan ke Keranjang!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFDEDEDE),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              )
            ],
          );
        },
      );
    }

    setState(() {
      loadingToCart = false;
    });
  }

  int? harga;

  @override
  void initState() {
    getData();
    print("detail id = ${widget.idProduk}");
    print("detail id user = ${widget.idUser}");
    print("detail id kat = ${widget.idKategori}");
    ceckUser();
    // getAlamat();
    super.initState();
  }

  bool wishlist = false;
  bool follow = false;
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
        leadingWidth: 50,
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () => Get.to(
                    const SearchPage(),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFEDECF5),
                    ),
                    width: bodyWidth * 0.81,
                    height: 43,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(width: 15),
                        Icon(
                          Icons.search_outlined,
                          color: Color(0xFF727272),
                          size: 21,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Cari Barang...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF727272),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Color(0xffECEAF3),
            resizeToAvoidBottomInset: false,
            appBar: myAppBar,
            bottomNavigationBar: Container(
              width: bodyWidth * 10,
              height: bodyHeight * 0.1,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: isLoading
                  ? const SmallLoadingWidget()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF828282),
                                  ),
                                ),
                                Text(
                                  "Rp${NumberFormat('#,###').format(result[0]['harga'] * jmlBeli)}"
                                      .replaceAll(",", "."),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF414141),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  postToCart();
                                },
                                child: Container(
                                  width: bodyWidth / 1.8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF9C62FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_shopping_cart_outlined,
                                        size: 26,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        "Tambah ke Keranjang",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                getData();
              },
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: bodyWidth * 10,
                        height: bodyHeight * 0.40,
                        color: Color(0xFFE0E0E0),
                        child: Image(
                          image:
                              MemoryImage(base64.decode(result[0]['gambar'])),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: bodyWidth * 10,
                        height: bodyHeight * 0.18,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 17, right: 17, top: 17, bottom: 11),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    result[0]['nama_kategori'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffB1ACD4),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        wishlist = !wishlist;
                                      });
                                    },
                                    child: (wishlist)
                                        ? const FaIcon(
                                            FontAwesomeIcons.heart,
                                            size: 25,
                                            color: Color(0xff9C9FA8),
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            size: 25,
                                            color: Color(0xFFFF0099),
                                          ),
                                  ),
                                ],
                              ),
                              Text(
                                result[0]['nama_produk'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Text(
                                "Rp ${NumberFormat('#,###,000').format(result[0]['harga'])}"
                                    .replaceAll(",", "."),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF9C62FF),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 55,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0x9AFFE945),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Color(0xffFFC700),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              "4.9",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xffFFC700)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Container(
                                        width: 1,
                                        height: 25,
                                        color: Color(0xff9C9FA8),
                                      ),
                                      const SizedBox(width: 15),
                                      Text(
                                        "${result[0]['terjual']} Terjual",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFB8B8B8),
                                        width: 0.9,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: jmlBeli <= 1
                                              ? null
                                              : () {
                                                  setState(() {
                                                    jmlBeli -= 1;
                                                  });
                                                },
                                          child: Icon(
                                            Icons.remove,
                                            size: 18.5,
                                            color: jmlBeli <= 1
                                                ? const Color(0xFFB8B8B8)
                                                : const Color(0xFF9C62FF),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "$jmlBeli",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: jmlBeli == result[0]['stok']
                                              ? null
                                              : () {
                                                  setState(() {
                                                    jmlBeli += 1;
                                                  });
                                                },
                                          child: Icon(
                                            Icons.add,
                                            size: 18.5,
                                            color: jmlBeli == result[0]['stok']
                                                ? const Color(0xFFB8B8B8)
                                                : const Color(0xFF9C62FF),
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
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: bodyWidth * 10,
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                    backgroundImage: MemoryImage(
                                        base64Decode(result[0]['profile']))),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result[0]['nama_lengkap'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF9D9D9D),
                                          size: 16,
                                        ),
                                        Text(
                                          (result[0]['kota'] == null)
                                              ? "Almat Kosong"
                                              : result[0]['kota'].toString(),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff727272)),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.star_border_rounded,
                                  size: 18,
                                  color: Color(0xff727272),
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "4.9",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff727272),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "rata - rata ulasan",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff727272),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: bodyWidth * 10,
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 17, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rincian Produk"),
                              Divider(color: Color(0xFFC6C6C6), height: 30),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: bodyWidth * 0.26,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Stok",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Kondisi",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Bahan",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Merek",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Ukuran",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Berat",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Motif",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Dikirim dari",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: bodyWidth * 0.62,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${result[0]['stok']}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              (result[0]['kondisi'] == "" ||
                                                      result[0]['kondisi'] ==
                                                          null)
                                                  ? "-"
                                                  : result[0]['kondisi'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              (result[0]['bahan'] == "" ||
                                                      result[0]['bahan'] ==
                                                          null)
                                                  ? "-"
                                                  : result[0]['bahan'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              (result[0]['merek'] == "" ||
                                                      result[0]['merek'] ==
                                                          null)
                                                  ? "-"
                                                  : result[0]['merek'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              (result[0]['ukuran'] == "" ||
                                                      result[0]['ukuran'] ==
                                                          null)
                                                  ? "-"
                                                  : result[0]['ukuran'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "${result[0]['berat'] / 1000} kg",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              (result[0]['motif'] == "" ||
                                                      result[0]['motif'] ==
                                                          null)
                                                  ? "-"
                                                  : result[0]['motif'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "KOTA ${result[0]['kota']} - ${result[0]['kecamatan']} - ${result[0]['provinsi']}"
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff727272),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text("Deskripsi"),
                              Divider(color: Color(0xFFC6C6C6), height: 30),
                              Text(
                                (result[0]['deskripsi'] == "" ||
                                        result[0]['deskripsi'] == null)
                                    ? "-"
                                    : result[0]['deskripsi'],
                                style: TextStyle(
                                  color: Color(0xff727272),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
  }
}
