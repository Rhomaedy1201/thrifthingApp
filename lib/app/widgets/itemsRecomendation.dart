import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trifthing_apps/app/models/model_produk.dart';
import 'package:trifthing_apps/app/repositorys/repo_produk.dart';
import '/app/Pages/detailProductPage.dart';
import 'package:http/http.dart' as http;

class ItemsRecomendation extends StatefulWidget {
  @override
  State<ItemsRecomendation> createState() => _ItemsRecomendationState();
}

class _ItemsRecomendationState extends State<ItemsRecomendation> {
  List<ProdukUser> listProduk = [];
  RepositoryProduk repoProduk = RepositoryProduk();

  getData() async {
    listProduk = await repoProduk.getData();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
              color: Color(0xFFEFECF7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.white,
                    image: DecorationImage(
                      image:
                          MemoryImage(base64.decode(listProduk[index].gambar)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp${listProduk[index].harga}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9C62FF),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "${listProduk[index].nama_produk}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 10 / 13,
      ),
      shrinkWrap: true,
      primary: false,
    );
  }
}
