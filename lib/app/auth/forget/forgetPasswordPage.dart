import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '/app/auth/forget/resetPasswordPage.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
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
                      'assets/lottie/iconAuth/16766-forget-password-animation.json'),
                ),
                SizedBox(height: 50),
                const Text(
                  "Lupa\nKata Sandi?",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "Jangan Kawatir! itu terjadi. Silahkan Masukkan alamat Email Akun kamu dibawah!",
                  style: TextStyle(fontSize: 16, color: Color(0xff727272)),
                ),
                SizedBox(height: 60),
                const TextField(
                  controller: null,
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
                      Get.to(ResetPasswordPage());
                    },
                    child: Center(
                      child: Text(
                        "Kirim",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
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
  }
}
