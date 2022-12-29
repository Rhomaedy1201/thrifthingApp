import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:trifthing_apps/app/utils/base_url.dart';
import 'package:trifthing_apps/app/models/category_modal.dart';

class ServiceCategory {
  Future<List<CategoryModal>> getCategory() async {
    List<CategoryModal> listCategory = [];
    var response = await http.get(
      Uri.parse("$apiGetKategory"),
    );

    // print(response.body);
    try {
      if (response.statusCode == 200) {
        List data = json.decode(response.body)['result'];

        data.forEach((element) {
          listCategory.add(CategoryModal.fromJson(element));
        });
        return listCategory;
      } else {
        log(response.statusCode.toString());
      }
      return listCategory;
    } catch (e) {
      log(e.toString());
    }
    return listCategory;
  }
}
