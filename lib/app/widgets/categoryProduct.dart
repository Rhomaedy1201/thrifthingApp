import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trifthing_apps/app/Pages/main/categoryPage.dart';
import 'package:trifthing_apps/app/models/category_modal.dart';
import 'package:trifthing_apps/app/services/service_category.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';

class CategoryProduct extends StatefulWidget {
  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  @override
  void initState() {
    super.initState();
    getDataCategory();
  }

  bool isLoading = false;
  List<CategoryModal> listCategory = [];
  Future<void> getDataCategory() async {
    setState(() {
      isLoading = true;
    });

    listCategory = await ServiceCategory().getCategory();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SmallLoadingWidget()
        : Center(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 105,
              child: Center(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemExtent: 99,
                itemCount: listCategory.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(CategoryPage(
                            idKat: "${listCategory[index].idKategori}",
                            type: false,
                            index: index,
                          ));
                        },
                        borderRadius: BorderRadius.circular(10),
                        splashColor: const Color(0xFF9C62FF),
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFECEAF3),
                          ),
                          padding: const EdgeInsets.all(7),
                          child: Center(
                            child: Image(
                              image: MemoryImage(
                                base64Decode(listCategory[index].gambar!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        listCategory[index].namaKategori!.capitalizeFirst!,
                        style: const TextStyle(
                            color: Color(0xFF727272), fontSize: 14),
                      ),
                    ],
                  );
                },
              )),
            ),
          );
  }
}
