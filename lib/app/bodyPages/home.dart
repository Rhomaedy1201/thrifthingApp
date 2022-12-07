import 'package:flutter/material.dart';
import '/app/widgets/categoryProduct.dart';
import '/app/widgets/itemsRecomendation.dart';

class HomeBody extends StatelessWidget {
  int valueChat = 0;
  int valueCart = 0;
  int valueNotification = 0;

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          Container(
            width: bodyWidth * 10,
            height: bodyHeight * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              image: DecorationImage(
                  image: AssetImage('assets/images/banner2.webp'),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kategori Produk",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4B5C),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        "Lihat semua",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 13,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          CategoryProduct(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rekomendasi",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4B5C),
                  ),
                ),
              ],
            ),
          ),
          ItemsRecomendation(),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
