import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:trifthing_apps/app/Pages/main/home_screen.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
import '/app/controllers/controll.dart';
import '/app/loadingPages/loadingHome.dart';
import '/app/auth/forget/forgetPasswordPage.dart';
// import '/app/Pages/home_screen.dart';
import '/app/auth/register/registerPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}
// 
class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  var txtEmail = TextEditingController();
  var txtKata_sandi = TextEditingController();

  bool email = false;
  bool sandi = false;

  bool isLoading = false;

  @override
  void initState() {
    _incrementCheckLogin();
    _incrementCheckIdUser();
    super.initState();
  }

  Future<String?> resetCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('valueLogin', true);
  }

  Future<bool?> _incrementCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? lastValue = await Controller1.getCheckLogin();
    bool? current = lastValue;
    await prefs.setBool('valueLogin', current!);
  }

  var userData;
  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    Uri url = Uri.parse(
        "$apiLoginUser?email=${txtEmail.text.toString()}&kata_sandi=${txtKata_sandi.text.toString()}");
    var response = await http.get(url);

    print(response.body);
    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      userData = (convertDataToJson as List<dynamic>);
      print(userData[0]['type']);

      isLoading = false;

      if (userData[0]['type'] == true) {
        resetCheckLogin();
        resetCheckIdUser();
        Get.offAll(HomeScreen());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xC027AD2C),
            content: Text(
              'Login Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'Email atau Sandi Anda Salah!!!',
          confirmBtnColor: Colors.deepPurple,
        );
      }
    });
  }

  Future<String?> resetCheckIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idUser', userData[0]['id_user']);
  }

  Future<String?> _incrementCheckIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    String? currentId = lastId;
    await prefs.setString('idUser', currentId);
    print(currentId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
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
                  child: Lottie.asset('assets/lottie/iconAuth/login.json'),
                ),
                const SizedBox(height: 23),
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: txtEmail,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (value) {
                    setState(() {
                      if (txtEmail.text.isNotEmpty) {
                        email = false;
                        if (txtKata_sandi.text.isNotEmpty) {
                          loginUser();
                          // repoLogin.login(txtEmail.text.toString(),
                          //     txtKata_sandi.text.toString());
                        } else {
                          sandi = true;
                        }
                      } else {
                        email = true;
                      }
                    });
                  },
                  decoration: const InputDecoration(
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
                  margin: const EdgeInsets.only(left: 50, top: 8),
                  child: Text(
                    (email == false) ? "" : "Email wajib di isi!",
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                TextField(
                  controller: txtKata_sandi,
                  autofocus: false,
                  autocorrect: false,
                  cursorColor: Colors.grey,
                  obscureText: isHidden,
                  obscuringCharacter: "*",
                  onSubmitted: (value) {
                    setState(() {
                      if (txtEmail.text.isNotEmpty) {
                        email = false;
                        if (txtKata_sandi.text.isNotEmpty) {
                          loginUser();
                          // repoLogin.login(txtEmail.text.toString(),
                          //     txtKata_sandi.text.toString());
                        } else {
                          sandi = true;
                        }
                      } else {
                        email = true;
                      }
                    });
                  },
                  style:
                      const TextStyle(fontSize: 18, color: Color(0xFF969696)),
                  decoration: InputDecoration(
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF969696),
                        size: 28,
                      ),
                    ),
                    hintText: "Sandi Anda",
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Color(0xFF969696)),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFC0C0C0)),
                    ),
                    suffix: SizedBox(
                      width: 30,
                      height: 20,
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        icon: Icon(isHidden == true
                            ? Icons.visibility_off_outlined
                            : Icons.visibility),
                        color: const Color(0xffB8B8B8),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50, top: 8),
                  child: Text(
                    (sandi == false) ? "" : "Kata sandi wajib di isi!",
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         Get.to(ForgetPasswordPage());
                //       },
                //       child: const Text(
                //         "Lupa Sandi?",
                //         style: TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.deepPurple,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                isLoading
                    ? const SmallLoadingWidget()
                    : Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.deepPurple,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            setState(() {
                              if (txtEmail.text.isNotEmpty) {
                                email = false;
                                if (txtKata_sandi.text.isNotEmpty) {
                                  loginUser();
                                  // repoLogin.login(txtEmail.text.toString(),
                                  //     txtKata_sandi.text.toString());
                                } else {
                                  sandi = true;
                                }
                              } else {
                                email = true;
                              }
                            });
                          },
                          child: const Center(
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //       height: 2,
                //       width: 140,
                //       color: const Color(0xFFE5E5E5),
                //     ),
                //     const Text("Atau",
                //         style:
                //             TextStyle(fontSize: 16, color: Color(0xff868686))),
                //     Container(
                //       height: 2,
                //       width: 140,
                //       color: const Color(0xFFE5E5E5),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20),
                // Container(
                //   width: double.infinity,
                //   height: 55,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     color: const Color(0xFFEDF2F6),
                //   ),
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(15),
                //     onTap: () {},
                //     child: Container(
                //       margin: const EdgeInsets.only(right: 20),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: const [
                //           Image(
                //             image: AssetImage('assets/logo/google.png'),
                //             width: 22,
                //             height: 22,
                //           ),
                //           SizedBox(width: 20),
                //           Text(
                //             "Masuk dengan Google",
                //             style: TextStyle(
                //                 fontSize: 17,
                //                 fontWeight: FontWeight.w500,
                //                 color: Color(0xFF4E4E4E)),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum Punya Akun?",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff868686),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 7),
                    InkWell(
                      onTap: () {
                        Get.to(RegisterPage());
                      },
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
