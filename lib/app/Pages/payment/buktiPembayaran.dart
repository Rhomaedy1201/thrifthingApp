import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';

class BuktiPembayaran extends StatefulWidget {
  var id_tansaksi, id_alamat_user;
  BuktiPembayaran({super.key, this.id_tansaksi, this.id_alamat_user});

  @override
  State<BuktiPembayaran> createState() => _BuktiPembayaranState();
}

class _BuktiPembayaranState extends State<BuktiPembayaran> {
  File? image;
  bool isLoading = false;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {
        image = File(imagePicked.path);
      });
    } else {
      log("image kosong");
    }
  }

  GetConnect connect = GetConnect();
  Future<void> updateBuktiPembayaran() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uint8List imageBytes = await image!.readAsBytesSync();
      final form = FormData({
        'bukti_pembayaran':
            MultipartFile(image, filename: 'bukti_pembayaran.png'),
      });
      final response = await connect.post(
        '$apiUpdateBuktiPembayaran?id_transaksi=${widget.id_tansaksi}&id_alamat_user=${widget.id_alamat_user}&status=Sudah dibayar',
        form,
      );
      // print(response.body);
      if (response.body[0]['type'] == true) {
        Get.back();
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                Get.back();
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
                      backgroundColor: Color(0x890F0F0F),
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
                              "Berhasil Update Bukti Pembayaran",
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
              },
            );
            return AlertDialog(
              backgroundColor: Color(0x00FFFFFF),
              elevation: 0,
              actions: [
                Column(
                  children: [
                    Container(
                      width: 700,
                      height: 700,
                      child: Lottie.asset(
                          "assets/lottie/iconAlert/happy-success.json"),
                    ),
                  ],
                )
              ],
            );
          },
        );
      } else {
        print("gagal merubah bukti pembayaran");
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  List result = [];
  Future<void> getTransaksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse(
          "$apiGetTransaksi?id_transaksi=${widget.id_tansaksi}&id_user=${widget.id_alamat_user}");
      var response = await http.get(url);
      result = json.decode(response.body)['result'];
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  bool loading = false;

  @override
  void initState() {
    getTransaksi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 2,
              shadowColor: const Color(0xFFF4F1F6),
              iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
              title: const Text(
                "Bukti pembayaran",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 20,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              height: 70,
              child: ElevatedButton(
                onPressed: image != null
                    ? () {
                        updateBuktiPembayaran();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C62FF),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (result[index]['bukti_pembayaran'] != "")
                            ? const Icon(
                                Icons.check_circle,
                                size: 45,
                                color: Colors.green,
                              )
                            : image != null
                                ? const Icon(
                                    Icons.check_circle,
                                    size: 45,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.close,
                                    size: 45,
                                    color: Colors.red,
                                  ),
                        const SizedBox(height: 10),
                        const Text(
                          "Silahkan pilih foto sebagai bukti pembayaran transaksi anda ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xff727272),
                          ),
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () async {
                            await getImage();
                          },
                          child: Container(
                            width: 230,
                            height: 300,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F1F2),
                              borderRadius: BorderRadius.circular(10),
                              image: (result[index]['bukti_pembayaran'] != "")
                                  ? image != null
                                      ? DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.contain,
                                        )
                                      : DecorationImage(
                                          image: MemoryImage(
                                            base64Decode(
                                              result[index]['bukti_pembayaran'],
                                            ),
                                          ),
                                          fit: BoxFit.contain,
                                        )
                                  : image != null
                                      ? DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.contain,
                                        )
                                      : null,
                            ),
                            child: (result[index]['bukti_pembayaran'] != "")
                                ? null
                                : image != null
                                    ? null
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            FontAwesomeIcons.solidFileImage,
                                            size: 40,
                                            color: Color(0xff727272),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Klik untuk memilih foto",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff727272),
                                            ),
                                          )
                                        ],
                                      ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          );
  }
}
