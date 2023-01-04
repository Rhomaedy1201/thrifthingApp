import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:trifthing_apps/app/Pages/main/home_screen.dart';

class RepositoryLogin {
  var data;

  void login(var email, var password) async {
    final _baseUrl =
        "http://localhost/restApi_goThrift/users/login_user.php?email=${email.toString()}&kata_sandi=${password.toString()}";
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        Get.offAll(HomeScreen());
      } else {
        print("repo login salah");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getID() {
    print("repo = $data");
  }

  RepositoryLogin({this.data});
}
