import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class ShippingOption extends StatefulWidget {
  var pengiriman;
  var idKotaPengirim, idKotaPenerima, berat, kurir;
  var typePengiriman, hargaPengiriman, estimasiPengiriman;
  ShippingOption({
    super.key,
    this.pengiriman,
    this.idKotaPengirim,
    this.idKotaPenerima,
    this.berat,
    this.kurir,
    this.typePengiriman,
    this.hargaPengiriman,
    this.estimasiPengiriman,
  });

  @override
  State<ShippingOption> createState() => _ShippingOptionState();
}

class _ShippingOptionState extends State<ShippingOption> {
  bool selectJasa = false;

  List service = [];
  var resultPengiriman;
  getPengiriman() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    var dataPengiriman = {
      "key": "d94bc123ecd740dfcfb52e76e0439035",
      "origin": "${widget.idKotaPengirim}",
      "destination": "${widget.idKotaPenerima}",
      "weight": "${widget.berat}",
      "courier": "${widget.kurir}",
    };
    final response = await http.post(url, body: dataPengiriman);
    resultPengiriman = jsonDecode(response.body);
    if (resultPengiriman['rajaongkir']['status']['code'] == 200) {
      setState(() {
        service = resultPengiriman['rajaongkir']['results'][0]['costs'];
        print(service);
      });
    } else {
      print("response status code checkout produk salah");
    }
  }

  bool loading = false;
  bool regular = true;
  bool nextDay = false;
  @override
  void initState() {
    print(widget.pengiriman);
    print(widget.idKotaPengirim);
    print(widget.idKotaPenerima);
    print(widget.berat);
    print(widget.kurir);
    getPengiriman();
    Timer(Duration(seconds: 2), () {
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
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
            backgroundColor: Color(0xFFEEEEEE),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
              elevation: 2,
              shadowColor: Color(0xFFF4F1F6),
              title: const Text(
                "Opsi Pengiriman",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 22,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              height: 75,
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop("sas");
                },
                child: Text(
                  "Pilih",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9C62FF),
                  minimumSize: Size(double.infinity, 55),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
            body: ListView(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: Color(0xFFEEEEEE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pilih Jasa Pengiriman".toUpperCase(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff727272),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Estimasi tanggal diterima tergantung pada waktu pengemasan Penjual dan waktu pengiriman ke lokasi anda",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 3),
                InkWell(
                  onTap: () {
                    setState(() {
                      nextDay = false;
                      regular = true;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    height: 65,
                    child: Row(
                      children: [
                        Container(
                          width: bodyWidth * 0.025,
                          color: (regular == true)
                              ? Color(0xFF7F42E8)
                              : Color(0xFFD3D3D3),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          width: bodyWidth * 0.975,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${service[0]['service']}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Rp${service[0]['cost'][0]['value']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF7F42E8),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Ekstimasi diterima kurang lebih dari ${service[0]['cost'][0]['etd']}"
                                        .capitalizeFirst!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff727272),
                                    ),
                                  ),
                                ],
                              ),
                              (regular == true)
                                  ? Icon(
                                      Icons.check,
                                      size: 30,
                                      color: Color(0xFF7F42E8),
                                    )
                                  : Text("")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3),
                InkWell(
                  onTap: () {
                    setState(() {
                      regular = false;
                      nextDay = true;
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    height: 65,
                    child: Row(
                      children: [
                        Container(
                          width: bodyWidth * 0.025,
                          color: (nextDay == true)
                              ? Color(0xFF7F42E8)
                              : Color(0xFFD3D3D3),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 13),
                          width: bodyWidth * 0.975,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${service[1]['service']}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Rp${service[1]['cost'][0]['value']}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF7F42E8),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Ekstimasi diterima kurang lebih dari ${service[1]['cost'][0]['etd']}"
                                        .capitalizeFirst!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff727272),
                                    ),
                                  ),
                                ],
                              ),
                              (nextDay == true)
                                  ? Icon(
                                      Icons.check,
                                      size: 30,
                                      color: Color(0xFF7F42E8),
                                    )
                                  : Text("")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop("POS");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          child: Text(
                            "POS (Pos Indonesia)",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          alignment: Alignment.bottomLeft,
                        ),
                        (widget.pengiriman == "POS")
                            ? Icon(
                                Icons.check,
                                size: 25,
                              )
                            : Text(""),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C62FF),
                      minimumSize: const Size(double.infinity, 55),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop("TIKI");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          child: Text(
                            "TIKI (Titipan Kilat)",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          alignment: Alignment.bottomLeft,
                        ),
                        (widget.pengiriman == "TIKI")
                            ? Icon(
                                Icons.check,
                                size: 25,
                              )
                            : Text("")
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9C62FF),
                      minimumSize: Size(double.infinity, 55),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
