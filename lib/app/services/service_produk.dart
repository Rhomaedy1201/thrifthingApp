import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trifthing_apps/app/utils/base_url.dart';
import '/app/models/model_produk.dart';

class ServiceProduk {
  Future getData() async {
    try {
      final _baseUrl = "$apiProdukUser";
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body)[0]['result'];
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

  Future getProductUseId({required String idKategori}) async {
    try {
      final _baseUrl = "$apiProdukUser?id_kategori=$idKategori";
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body)[0]['result'];
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
