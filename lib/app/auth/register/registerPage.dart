import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '/app/auth/login/loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isHidden = true;
  List? result;
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNama_lengkap = TextEditingController();
  TextEditingController txtNo_hp = TextEditingController();
  TextEditingController txtKata_sandi = TextEditingController();

  bool email = false;
  bool nama = false;
  bool noHp = false;
  bool sandi = false;

  void postdataUser() async {
    Uri url =
        Uri.parse("http://localhost/restApi_goThrift/users/post_users.php?");
    var data = {
      'email': txtEmail.text,
      'nama_lengkap': txtNama_lengkap.text,
      'no_hp': txtNo_hp.text,
      'kata_sandi': txtKata_sandi.text,
    };

    final response = await http.post(url, body: data);
    print(response.body);
    txtEmail.text = "";
    txtNama_lengkap.text = "";
    txtNo_hp.text = "";
    txtKata_sandi.text = "";
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      text: 'Berhasil Mendaftar akun!',
      onConfirmBtnTap: () {
        Get.offAll(LoginPage());
      },
      confirmBtnColor: Colors.deepPurple,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF767676)),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Lottie.asset('assets/lottie/iconAuth/register.json'),
                ),
                SizedBox(height: 30),
                const Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: txtEmail,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  style: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.alternate_email_outlined,
                        color: Color(0xFF969696),
                        size: 28,
                      ),
                    ),
                    hintText: "Email ID",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, top: 5),
                  child: Text(
                    (email == false) ? "" : "Email wajib di isi!",
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                TextField(
                  controller: txtNama_lengkap,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  style: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.face_rounded,
                        color: Color(0xFF969696),
                        size: 28,
                      ),
                    ),
                    hintText: "Nama Lengkap",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, top: 5),
                  child: Text(
                    (nama == false) ? "" : "Nama wajib di isi!",
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                TextField(
                  maxLength: 12,
                  controller: txtNo_hp,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  style: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    counterText: '',
                    icon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.phone_in_talk_outlined,
                        color: Color(0xFF969696),
                        size: 28,
                      ),
                    ),
                    hintText: "No HP",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, top: 5),
                  child: Text(
                    (noHp == false) ? "" : "No Hp wajib di isi!",
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                TextField(
                  controller: txtKata_sandi,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  obscureText: isHidden,
                  obscuringCharacter: "*",
                  style: TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF969696),
                        size: 28,
                      ),
                    ),
                    hintText: "Sandi Anda",
                    hintStyle:
                        TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    suffix: SizedBox(
                      width: 30,
                      height: 20,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        icon: Icon(isHidden == true
                            ? Icons.visibility_off_outlined
                            : Icons.visibility),
                        color: Color(0xffB8B8B8),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50, top: 5),
                  child: Text(
                    (sandi == false) ? "" : "Kata Sandi wajib di isi!",
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepPurple,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      if (txtEmail.text.isNotEmpty) {
                        setState(() {
                          email = false;
                        });
                        if (txtNama_lengkap.text.isNotEmpty) {
                          setState(() {
                            nama = false;
                          });
                          if (txtNo_hp.text.isNotEmpty) {
                            setState(() {
                              noHp = false;
                            });
                            if (txtKata_sandi.text.isNotEmpty) {
                              setState(() {
                                sandi = false;
                              });
                              postdataUser();
                            } else {
                              setState(() {
                                sandi = true;
                              });
                            }
                          } else {
                            setState(() {
                              noHp = true;
                            });
                          }
                        } else {
                          setState(() {
                            nama = true;
                          });
                        }
                      } else {
                        setState(() {
                          email = true;
                        });
                      }
                    },
                    child: Center(
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah Punya Akun?",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff868686),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        Get.offAll(LoginPage());
                      },
                      child: Text(
                        "Masuk Sekarang",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
