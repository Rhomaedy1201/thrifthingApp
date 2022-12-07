import 'dart:convert';

import 'package:http/http.dart' as http;
import '/app/Pages/detailProductPage.dart';
import '/app/models/model_produk.dart';

class RepositoryProduk {
  final _baseUrl =
      "http://localhost/restApi_goThrift/produk_user/get_produk_user.php";

  DetailProductPage detailPage = DetailProductPage();

  Future getData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body)[0]['result'];
        // print(it);
        List<ProdukUser> produk =
            it.map((e) => ProdukUser.fromJson(e)).toList();
        return produk;
      } else {
        print("salah lohhhh");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
