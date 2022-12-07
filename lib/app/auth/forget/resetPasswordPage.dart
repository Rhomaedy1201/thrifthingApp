import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/app/auth/login/loginPage.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isHidden = true;
  bool submit = false;
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
                  height: 280,
                  child: Lottie.asset(
                      'assets/lottie/iconAuth/change-password.json'),
                ),
                SizedBox(height: 50),
                const Text(
                  "Reset\nKata Sandi",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: null,
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
                    hintText: "Kata sandi baru",
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
                SizedBox(height: 25),
                TextField(
                  controller: null,
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
                    hintText: "Konfirmasi kata sandi",
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
                SizedBox(height: 45),
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
                      setState(() {
                        submit = !submit;
                        Future.delayed(const Duration(seconds: 3), () {
                          Get.offAll(LoginPage());
                        });
                      });
                    },
                    child: Container(
                      margin: (submit == true)
                          ? EdgeInsets.only(right: 25)
                          : EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (submit == true)
                              ? Lottie.asset(
                                  'assets/iconAuth/loading-white.json')
                              : Text(""),
                          Text(
                            (submit == false) ? "Kirim" : "Mengirim...",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
