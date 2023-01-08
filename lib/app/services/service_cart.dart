import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:trifthing_apps/app/models/cart_modal.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';

class ServiceCart {
  Future<List<CartModal>> getCart({required String id_user_pembeli}) async {
    List<CartModal> result = [];
    var response = await http.get(
      Uri.parse("$getCartApi?id_user_pembeli=$id_user_pembeli"),
    );

    // print(response.body);

    try {
      if (response.statusCode == 200) {
        List data = json.decode(response.body)['result'];

        data.forEach((element) {
          result.add(CartModal.fromJson(element));
        });
        return result;
      } else {
        log(response.statusCode.toString() + "Cek");
      }
      return result;
    } catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<bool?> cekTypeCart({required String id_user_pembeli}) async {
    bool? result;
    var response = await http.get(
      Uri.parse("$getCartApi?id_user_pembeli=$id_user_pembeli"),
    );

    // print(response.body);
    try {
      if (response.statusCode == 200) {
        result = await json.decode(response.body)['type'];

        return result;
      } else {
        log(response.statusCode.toString());
      }

      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteCartUseId({required String idKeranjang}) async {
    bool? result;
    var response = await http.delete(
      Uri.parse("$deleteCartId?id_keranjang=$idKeranjang"),
    );

    // print(response.body);
    try {
      if (response.statusCode == 200) {
        result = await json.decode(response.body)[0]['type'];

        return result;
      } else {
        log(response.statusCode.toString());
      }

      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> addToCart({
    required String idProduk,
    required String idPembeli,
    required String idPenjual,
    required String jumlah,
    required String total,
  }) async {
    bool? result;

    var response = await http.post(
      Uri.parse("$postCart"),
      body: {
        'id_produk': idProduk,
        'id_user_pembeli': idPembeli,
        'id_user_penjual': idPenjual,
        'jumlah': jumlah,
        'total': total,
      },
    );

    print(response.body);
    try {
      if (response.statusCode == 200) {
        result = await json.decode(response.body)[0]['type'];

        return result;
      } else {
        log(response.statusCode.toString());
      }

      return result;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool?> deleteAllCart({required String idKeranjang}) async {
    bool? result;
    var response = await http.delete(
      Uri.parse("$deleteCartAll?id_user_pembeli=$idKeranjang"),
    );

    print(response.body);
    try {
      if (response.statusCode == 200) {
        result = await json.decode(response.body)[0]['type'];

        return result;
      } else {
        log(response.statusCode.toString());
      }

      return result;
    } catch (e) {
      log(e.toString());
    }
  }
}
