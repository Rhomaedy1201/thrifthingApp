import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trifthing_apps/app/controllers/controll.dart';
import '/app/Pages/checkoutPage.dart';

class DetailProductPage extends StatefulWidget {
  var idProduk, idUser, idKategori;
  DetailProductPage({super.key, this.idProduk, this.idUser, this.idKategori});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  var idProduk, idUser, idKategori;

  List result = [];

  var resultAlamat;
  var modelsAlamat;
  var idKotaPenerima;

  int? stok;
  int jmlBeli = 1;

  void plus() {
    setState(() {
      jmlBeli = jmlBeli + 1;
    });
  }

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
        idKotaPenerima = modelsAlamat[0]['id_kota'];
        print(idKotaPenerima);
      });
    } else {
      print("response status code Alamat ceckout salah");
    }
  }

  getData() async {
    final _baseUrl =
        "http://localhost/restApi_goThrift/produk_user/get_produk_user.php?id_produk=${widget.idProduk.toString()}&id_user=${widget.idUser.toString()}&id_kategori=${widget.idKategori.toString()}";
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body)[0]['result'];
        stok = result[0]['stok'];
      });
    } else {
      print("response status code detail produk salah");
    }
  }

  String? currentId;
  var cekAddress;
  ceckUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastId;
    });
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/detail_alamat_user/get_detail_alamat.php?id_user=${currentId.toString()}");
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode != null) {
      cekAddress = json.decode(response.body)['type'];
      setState(() {});
    } else {
      print("response status code profile user salah");
    }
  }

  int? harga;

  @override
  void initState() {
    getData();
    print("detail id = ${widget.idProduk}");
    print("detail id user = ${widget.idUser}");
    print("detail id kat = ${widget.idKategori}");
    ceckUser();
    getAlamat();
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
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Color(0xFFE1E0EB),
                    ),
                    width: bodyWidth * 0.72,
                    height: 37,
                    child: Row(
                      children: const [
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
            const SizedBox(width: 13),
            Badge(
              badgeContent: Text(
                "0",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              padding: const EdgeInsets.all(4),
              badgeColor: Color(0xFF6754B4),
              showBadge: 0 < 1 ? false : true,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF9C9FA8),
                  size: 27,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 13),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: result.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    width: 85,
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF9C62FF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: FaIcon(
                      FontAwesomeIcons.commentDots,
                      size: 26,
                      color: Color(0xFF9C62FF),
                    )),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 85,
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF9C62FF),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 29,
                      color: Color(0xFF9C62FF),
                    )),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      if (cekAddress == true) {
                        Get.to(CheckoutPage(
                          idProduk: result[0]['id_produk'],
                          idUser: result[0]['id_user'],
                          idKat: result[0]['id_kategori'],
                          idKotaPengirim: result[0]['id_kota'],
                          idKotaPenerima: idKotaPenerima.toString(),
                          berat: result[0]['berat'],
                          pengiriman: "pos",
                        ));
                      } else {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          text:
                              'Lengkapi Data diri anda terlibih dahulu\nseperti alamat dll.',
                          confirmBtnColor: Colors.deepPurple,
                          confirmBtnText: "Ok",
                          onConfirmBtnTap: () async {
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    },
                    child: Container(
                      width: bodyWidth * 0.49,
                      height: 46,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFF9C62FF),
                      ),
                      child: const Center(
                        child: Text(
                          "Beli Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: bodyWidth * 10,
                height: bodyHeight * 0.40,
                color: Color(0xFFE0E0E0),
                child: Image(
                  image: MemoryImage(base64.decode(result[0]['gambar'])),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                width: bodyWidth * 10,
                height: bodyHeight * 0.18,
                color: Colors.white,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 17, right: 17, top: 17, bottom: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        result[0]['nama_kategori'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffB1ACD4),
                        ),
                      ),
                      Text(
                        result[0]['nama_produk'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff000000),
                        ),
                      ),
                      Text(
                        "Rp ${result[0]['harga']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9C62FF),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 55,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0x9AFFE945),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                              SizedBox(width: 15),
                              Container(
                                width: 1,
                                height: 25,
                                color: Color(0xff9C9FA8),
                              ),
                              SizedBox(width: 15),
                              Text(
                                "${result[0]['terjual']} Terjual",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                wishlist = !wishlist;
                              });
                            },
                            child: (wishlist)
                                ? FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: 25,
                                    color: Color(0xff9C9FA8),
                                  )
                                : FaIcon(
                                    FontAwesomeIcons.solidHeart,
                                    size: 25,
                                    color: Color(0xFFFF0099),
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
                height: bodyHeight * 0.12,
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundImage: MemoryImage(
                                  base64Decode(result[0]['profile']))),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result[0]['nama_lengkap'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color(0xFF9D9D9D),
                                    size: 16,
                                  ),
                                  Text(
                                    (result[0]['kota'] == null)
                                        ? "Almat Kosong"
                                        : result[0]['kota'].toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xff727272)),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                          InkWell(
                            onTap: () {
                              setState(() {
                                follow = !follow;
                              });
                            },
                            child: (follow == false)
                                ? Container(
                                    width: 60,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF9C62FF),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Follow",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF9C62FF),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff727272),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Following",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xff727272),
                                        ),
                                      ),
                                    ),
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${result[0]['stok']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff727272),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      (result[0]['kondisi'] == "" ||
                                              result[0]['kondisi'] == null)
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
                                              result[0]['bahan'] == null)
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
                                              result[0]['merek'] == null)
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
                                              result[0]['ukuran'] == null)
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
                                              result[0]['motif'] == null)
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
    );
  }
}
