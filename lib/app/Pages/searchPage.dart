import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trifthing_apps/app/utils/base_url.dart';
import '/app/Pages/displayResultSearch.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController txtSearch = TextEditingController();
  var result;
  var cekData;

  getData() async {
    final _baseUrl =
        "$apiSearchProduk?nama_produk=${txtSearch.text.toString()}";
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      result = jsonDecode(response.body)[0]['result'];
      cekData = jsonDecode(response.body)[0]['data'];
      // print(result);
      // print(cekData);
      if (cekData > 0) {
        Get.to(DisplayResultSearch(
          namaProduk: txtSearch.text.toString(),
          data: cekData,
        ));
      } else {
        print("data pencarian produk ${txtSearch.text.toString()}, Kosong!!");
        Get.to(DisplayResultSearch(
          namaProduk: txtSearch.text.toString(),
          data: cekData,
        ));
      }
      setState(() {});
    } else {
      print("response status code detail produk salah");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: BackButton(color: Color(0xFF9C62FF)),
        centerTitle: false,
        // leadingWidth: 40,
        titleSpacing: 0,
        title: Container(
          margin: EdgeInsets.only(right: 15),
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFEDECF5),
          ),
          child: TextField(
            controller: txtSearch,
            textInputAction: TextInputAction.search,
            autofocus: true,
            autocorrect: false,
            enableInteractiveSelection: true,
            cursorColor: Color(0xFF9C62FF),
            onSubmitted: (value) {
              getData();
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                size: 25,
                color: Color(0xff727272),
              ),
              hintText: 'Cari di GoThrift',
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Terakhir di Cari",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Hapus Semua",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17),
                LastSearch(),
                LastSearch(),
                LastSearch(),
                LastSearch(),
                LastSearch(),
                SizedBox(height: 20),
                Text(
                  "Kategori Produk",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                SearchCategory(
                  bodyWidth: bodyWidth,
                  icon: 'FontAwesomeIcons.shirt',
                  title: 'Baju atau kaos',
                  valueItem: 20,
                ),
                SearchCategory(
                  bodyWidth: bodyWidth,
                  icon: 'FontAwesomeIcons.shirt',
                  title: 'Baju atau kaos',
                  valueItem: 20,
                ),
                SearchCategory(
                  bodyWidth: bodyWidth,
                  icon: 'FontAwesomeIcons.shirt',
                  title: 'Baju atau kaos',
                  valueItem: 20,
                ),
                SearchCategory(
                  bodyWidth: bodyWidth,
                  icon: 'FontAwesomeIcons.shirt',
                  title: 'Baju atau kaos',
                  valueItem: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchCategory extends StatelessWidget {
  const SearchCategory({
    Key? key,
    required this.bodyWidth,
    required this.title,
    required this.icon,
    required this.valueItem,
  }) : super(key: key);

  final double bodyWidth;
  final String title;
  final String icon;
  final int valueItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: bodyWidth * 10,
        height: 55,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFD1D1D1),
              blurRadius: 3,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Color(0xFF9C62FF),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.shirt,
                  color: Color(0xFFFFFFFF),
                  size: 25,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Jumlah ${valueItem}",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastSearch extends StatelessWidget {
  const LastSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.alarm_on_sharp,
                  size: 22,
                  color: Color(0xFFC8C8C8),
                ),
                SizedBox(width: 23),
                Text(
                  "Jaket bekas",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 180)
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.close,
              color: Color(0xFFC8C8C8),
            ),
          )
        ],
      ),
    );
  }
}
