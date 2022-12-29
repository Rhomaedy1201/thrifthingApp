import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trifthing_apps/app/models/model_produk.dart';
import 'package:trifthing_apps/app/services/service_produk.dart';
import 'package:trifthing_apps/app/widgets/shimmer_loading_products.dart';
import 'package:trifthing_apps/app/widgets/small_loading.dart';
import '/app/Pages/detailProductPage.dart';

class ItemsRecomendation extends StatefulWidget {
  @override
  State<ItemsRecomendation> createState() => _ItemsRecomendationState();
}

class _ItemsRecomendationState extends State<ItemsRecomendation> {
  List<ProdukUser> listProduk = [];
  ServiceProduk serviceProduk = ServiceProduk();

  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });

    listProduk = await serviceProduk.getData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const ShimmerLoadingProducts()
        : Column(
            children: [
              GridView.builder(
                itemCount: listProduk.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(DetailProductPage(
                        idProduk: listProduk[index].id_produk,
                        idUser: listProduk[index].id_user,
                        idKategori: listProduk[index].id_kategori,
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: const Color(0xFFECEAF3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 5),
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.white,
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64.decode(listProduk[index].gambar)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rp${NumberFormat('#,###').format(listProduk[index].harga)}"
                                      .replaceAll(",", "."),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9C62FF),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${listProduk[index].nama_produk}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF727272),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 10 / 13,
                ),
                shrinkWrap: true,
                primary: false,
              ),
            ],
          );
  }
}
