import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/Pages/orderDetailsPage.dart';

class TransactionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 19),
            child: Text(
              "Transaksi",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 5,
            color: Color(0xffECEAF3),
            width: double.infinity,
          ),
          SizedBox(height: 15),
          ItemsTransaction()
        ],
      ),
    );
  }
}

class ItemsTransaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 19),
      child: GridView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(OrderDetailsPage());
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFC1C1C1),
                    blurRadius: 4,
                    offset: Offset(0, 0), // Shadow position
                  ),
                ],
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart_checkout_outlined,
                                  color: Colors.amber,
                                  size: 25,
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Belanja",
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "10 Nov 2022",
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff727272),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0x4F10DF28),
                              ),
                              child: Center(
                                child: Text(
                                  "Belum dibayar",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF048D44),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Color(0xFFC2C2C2),
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/itemsImage/item3.jpeg'),
                                  repeat: ImageRepeat.noRepeat,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Baju Bekas Air Jordan Original",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "1 Barang",
                                    style: TextStyle(
                                        fontSize: 10, color: Color(0xff727272)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Belanja",
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Rp 120.000",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 15,
          childAspectRatio: 10 / 3.7,
        ),
        shrinkWrap: true,
        primary: false,
      ),
    );
  }
}
