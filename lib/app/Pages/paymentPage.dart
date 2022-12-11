import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/app/Pages/buktiPembayaran.dart';
import '/app/Pages/home_screen.dart';
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
  var bank = "bri";
  var noRekening = 1203981293818312;
  var pemilikRek = "Muhammad Rhomaedi";
  var idTransaksi;
  DateTime dt = DateTime.now();
  List<PlatformFile> files = [];

  _PaymentPageState({this.idTransaksi});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        shadowColor: Color(0xFFF4F1F6),
        iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
        title: Text(
          "Info Pembayaran",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 22,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 140,
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
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                      "Rp 95.000",
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                    "Gunakan ATM / iBankng / mBanking / Setor tunai \nuntuk transfer ke rekening berikut ini:",
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                          child: Image(
                            image: AssetImage("assets/logo/bri.png"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 270,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "BRI",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "No. Rekening: $noRekening",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "No. Rekening: $pemilikRek",
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
                        Clipboard.setData(
                            ClipboardData(text: noRekening.toString()));
                      },
                      child: Text(
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
            Container(
              padding: EdgeInsets.only(left: 16, top: 15),
              child: Text(
                "* Hanya menerima dari Bank BRI",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff727272)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  Get.to(BuktiPembayaran());
                },
                child: Text(
                  "Upload bukti transfer sekarang",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  (widget.idTransaksi == null || widget.idTransaksi == "")
                      ? Get.offAll(HomeScreen())
                      : Get.back();
                },
                child: Text(
                  "Upload bukti transfer nanti",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9C62FF)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEBEBEB),
                  minimumSize: Size(double.infinity, 55),
                  side: BorderSide(width: 2, color: Color(0xFF9C62FF)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
