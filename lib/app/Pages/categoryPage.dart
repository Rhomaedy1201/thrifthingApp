import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trifthing_apps/app/Pages/detailProductPage.dart';
import 'package:trifthing_apps/app/models/category_modal.dart';
import 'package:trifthing_apps/app/models/model_produk.dart';
import 'package:trifthing_apps/app/services/service_category.dart';
import 'package:trifthing_apps/app/services/service_produk.dart';
import 'package:trifthing_apps/app/widgets/big_loading.dart';

class CategoryPage extends StatefulWidget {
  var idKat, type, index;
  CategoryPage({this.idKat, this.type, this.index, super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    getDataCategory();
    if (widget.type) {
      getProduk();
    } else {
      getProdukId("${widget.idKat}");
    }
  }

  bool isLoading = false;

  var cek;

  int? isActive;
  List<CategoryModal> listCategory = [];
  Future<void> getDataCategory() async {
    setState(() {
      isLoading = true;
    });
    listCategory = await ServiceCategory().getCategory();

    isActive = widget.type == true ? listCategory.length : widget.index;

    setState(() {
      isLoading = false;
    });
  }

  List<ProdukUser> listProduk = [];
  Future<void> getProduk() async {
    setState(() {
      isLoading = true;
    });

    listProduk = await ServiceProduk().getData();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getProdukId(String idKat) async {
    setState(() {
      isLoading = true;
    });

    listProduk = await ServiceProduk().getProductUseId(idKategori: "$idKat");

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget menuCategory() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            reverse: true,
            itemCount: listCategory.length + 1,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: index != listCategory.length
                    ? InkWell(
                        borderRadius: BorderRadius.circular(15),
                        splashColor: const Color(0xFF6F1CFF),
                        highlightColor: const Color(0xFF6F1CFF),
                        onTap: () {
                          setState(() {
                            isActive = index;
                            print("$index ");
                            print("${listCategory.length}");

                            if (listCategory.length == index) {
                              getProduk();
                            } else {
                              getProdukId(listCategory[index].idKategori!);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isActive == index)
                                ? const Color(0xFF6F1CFF)
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 27),
                          child: Text(
                            listCategory[index].namaKategori!.replaceFirst(
                                  listCategory[index].namaKategori![0],
                                  listCategory[index]
                                      .namaKategori![0]
                                      .toUpperCase(),
                                ),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: (isActive == index)
                                  ? Colors.white
                                  : const Color(0xff727272),
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        borderRadius: BorderRadius.circular(15),
                        splashColor: const Color(0xFF6F1CFF),
                        highlightColor: const Color(0xFF6F1CFF),
                        onTap: () {
                          setState(() {
                            isActive = index;
                            if (listCategory.length == index) {
                              getProduk();
                            } else {
                              getProdukId(listCategory[index].idKategori!);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isActive == index)
                                ? const Color(0xFF6F1CFF)
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 27),
                          child: Text(
                            "All",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: (isActive == index)
                                  ? Colors.white
                                  : const Color(0xff727272),
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      );
    }

    Widget productCategory() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: GridView.builder(
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
                  color: const Color(0xFFEFECF7),
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
                          SizedBox(height: 3),
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
      );
    }

    return isLoading
        ? const Scaffold(
            body: BigLoadingWidget(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
              elevation: 2,
              shadowColor: Color(0xFFF4F1F6),
              title: const Text(
                "Kategori Produk",
                style: TextStyle(
                  color: Color(0xFF414141),
                  fontSize: 21,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  menuCategory(),
                  productCategory(),
                ],
              ),
            ),
          );
  }
}
