import 'dart:convert';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import '/app/Pages/editAddressPage.dart';
import '/app/Pages/newAddressPage.dart';
import 'package:http/http.dart' as http;

class MyAddressPage extends StatefulWidget {
  var idUser;
  MyAddressPage({super.key, this.idUser});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  List result = [];
  var idUSer;
  _MyAddressPageState({this.idUSer});

  void getAddress() async {
    Uri url =
        Uri.parse("$apiGetDetailAlamat?id_user=${widget.idUser.toString()}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        result = json.decode(response.body)['result'];
      });
    } else {
      print("response alamat address 200");
    }
  }

  @override
  void initState() {
    setState(() {
      getAddress();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 2,
        shadowColor: const Color(0xFFF4F1F6),
        title: const Text(
          "Alamat Saya",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 22,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getAddress();
        },
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFFF1F1F1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: const Text(
                "Alamat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff727272),
                ),
              ),
            ),
            DynamicHeightGridView(
              itemCount: result.length,
              crossAxisCount: 1,
              mainAxisSpacing: 2,
              shrinkWrap: true,
              builder: (ctx, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(EditAddressPage(
                          namaLengkap: result[index]['nama_lengkap_alamat'],
                          noTelp: result[index]['no_hp_alamat'],
                          idProv: result[index]['id_provinsi'],
                          namaProv: result[index]['provinsi'],
                          idKota: result[index]['id_kota'],
                          namaKota: result[index]['kota'],
                          kodePos: result[index]['kode_pos'],
                          namaJln: result[index]['detail_jalan'],
                          namaPatokan: result[index]['detail_patokan'],
                        ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        // color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  result[index]['nama_lengkap_alamat'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                SizedBox(width: 9),
                                Container(
                                  width: 0.8,
                                  height: 20,
                                  color: Color(0xFFA2A2A2),
                                ),
                                SizedBox(width: 9),
                                Text(
                                  result[index]['no_hp_alamat'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff727272),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${result[index]['detail_jalan']} (${result[index]['detail_patokan']})",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff727272),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "KAB. ${result[index]['kota']}, ${result[index]['provinsi']}, ID ${result[index]['kode_pos']}"
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff727272),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 0.8,
                      width: double.infinity,
                      color: Color(0xFFC3C3C3),
                    )
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(NewAddressPage());
                },
                child: Container(
                  height: 55,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Tambah Alamat Baru",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C62FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
