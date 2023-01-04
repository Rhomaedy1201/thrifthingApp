import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trifthing_apps/app/utils/base_url.dart';

class EditProfile extends StatefulWidget {
  String? id_user, nama_lengkap, no_hp;
  EditProfile({
    super.key,
    this.id_user,
    this.nama_lengkap,
    this.no_hp,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // pilih image
  File? image;
  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imagePicked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {
        image = File(imagePicked.path);
        updateFotoProfile();
      });
    } else {
      log("gambar kosong");
    }
  }

  GetConnect connect = GetConnect();
  Future<void> updateFotoProfile() async {
    try {
      Uint8List imageBytes = await image!.readAsBytesSync();
      final form = FormData({
        'profile': MultipartFile(image, filename: 'profile-GoThrift.png'),
      });
      final response = await connect.post(
        "$apiUpdateUser?nama_lengkap=${widget.nama_lengkap}&no_hp=${widget.no_hp}&id_user=${widget.id_user}",
        form,
      );
      print(response.body);
    } catch (e) {
      print(e.toString());
    }
  }

  List result = [];
  Future getUser() async {
    Uri url = Uri.parse("$apiGetUser?id_user=${widget.id_user}");
    var response = await http.get(url);
    result = json.decode(response.body)['result'];
    // print(result);
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 0,
        shadowColor: Color(0xFFF4F1F6),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  borderRadius: BorderRadius.circular(27),
                  splashColor: Color(0xFFDECAFF),
                  highlightColor: Color(0xFFDECAFF),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF9C62FF),
                      borderRadius: BorderRadius.circular(50),
                      image: (result[index]['profile'] != "")
                          ? image != null
                              ? DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(
                                      result[index]['profile'],
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                )
                          : image != null
                              ? DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Color(0x4D000000),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  "Ubah foto",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Tentang Anda",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff727272),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {},
                splashColor: Color(0xFFDECAFF),
                highlightColor: Color(0xFFDECAFF),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Nama Lengkap",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${result[index]['nama_lengkap']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.navigate_next_rounded,
                            size: 25,
                            color: Color(0xFF868686),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                splashColor: const Color(0xFFDECAFF),
                highlightColor: const Color(0xFFDECAFF),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "No Handphone",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${result[index]['no_hp']}",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.navigate_next_rounded,
                            size: 25,
                            color: Color(0xFF868686),
                          )
                        ],
                      )
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
