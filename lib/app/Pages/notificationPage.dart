import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
          elevation: 1,
          shadowColor: Color(0xFFF4F1F6),
          title: const Text(
            "Notifikasi",
            style: TextStyle(
              color: Color(0xFF414141),
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              child: Text(
                "Terbaru",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  width: double.infinity,
                  color: Color.fromARGB(255, 240, 230, 255),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.discount_outlined,
                            size: 22,
                            color: Color(0xFF9C62FF),
                          ),
                          Container(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaksi",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff727272),
                                  ),
                                ),
                                Text(
                                  "Anda sudah melakukan transaksi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  "Silahkan melakukan pembayaran jika dalam 24jam tidak bayar maka transaksi akan gagal",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff727272),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
