import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Pages/cart/cartPage.dart';
import '/app/Pages/notificationPage.dart';
import '../Pages/main/searchPage.dart';

class AppBarHome extends StatefulWidget {
  const AppBarHome({super.key});

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  int valueChat = 0;
  int valueCart = 0;
  int valueNotification = 0;
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: () => Get.to(SearchPage(), arguments: true),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: Color(0xFFE1E0EB),
                    ),
                    width: bodyWidth * 0.63,
                    height: 37,
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Icon(
                          Icons.search_outlined,
                          color: Color(0xFF727272),
                          size: 21,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Cari Barang...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF727272),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Container(
              width: bodyWidth * 0.26,
              height: 37,
              // color: Colors.red,
              child: Row(
                children: [
                  Badge(
                    badgeContent: Text(
                      "$valueNotification",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    padding: EdgeInsets.all(4),
                    badgeColor: Color(0xFF6754B4),
                    showBadge: valueNotification < 1 ? false : true,
                    child: InkWell(
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xFF9C9FA8),
                        size: 27,
                      ),
                      onTap: () {
                        Get.off(NotificationPage());
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Badge(
                    badgeContent: Text(
                      "$valueCart",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    padding: EdgeInsets.all(4),
                    badgeColor: Color(0xFF6754B4),
                    // animationType: BadgeAnimationType.slide,
                    showBadge: valueCart < 1 ? false : true,
                    child: InkWell(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF9C9FA8),
                        size: 27,
                      ),
                      onTap: () {
                        Get.to(CartPage());
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Badge(
                    badgeContent: Text(
                      "$valueChat",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    padding: EdgeInsets.all(4),
                    badgeColor: Color(0xFF6754B4),
                    // animationType: BadgeAnimationType.slide,
                    showBadge: valueChat < 1 ? false : true,
                    child: InkWell(
                      child: Icon(
                        Icons.wechat_outlined,
                        color: Color(0xFF9C9FA8),
                        size: 27,
                      ),
                      onTap: () {
                        setState(() {
                          valueChat += 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return myAppBar;
  }
}
