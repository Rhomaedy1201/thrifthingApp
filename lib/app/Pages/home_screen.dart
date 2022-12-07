import 'dart:async';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/controllers/controll.dart';
import '../Pages/cartPage.dart';
import '../Pages/notificationPage.dart';
import '../Pages/transactionPage.dart';
import '../Pages/wishlistPage.dart';
import '../bodyPages/profile.dart';
import '../bodyPages/home.dart';
import '../Pages/searchPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int valueChat = 0;
  int valueCart = 0;
  int valueNotification = 0;
  int _currentIndex = 0;
  var idUser;

  _HomeScreenState({this.idUser});

  final List<Widget> _widgetOption = [
    HomeBody(),
    WishlistPage(),
    TransactionPage(),
    ProfileBody(),
  ];

  void tes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    String? currentId = lastId;
  }

  @override
  void initState() {
    tes();
    super.initState();
  }

  void _onItemTaped(index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
                  onTap: () => Get.to(
                    SearchPage(),
                    arguments: true,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFEDECF5),
                    ),
                    width: bodyWidth * 0.63,
                    height: 43,
                    child: Row(
                      children: const <Widget>[
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
            const SizedBox(width: 10),
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
                    badgeColor: Color(0xFF9C62FF),
                    showBadge: valueNotification < 1 ? false : true,
                    child: InkWell(
                      child: const FaIcon(
                        FontAwesomeIcons.bell,
                        color: Color(0xFF9C9FA8),
                        size: 25,
                      ),
                      onTap: () {
                        setState(() {
                          Get.to(NotificationPage());
                        });
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
                    badgeColor: Color(0xFF9C62FF),
                    // animationType: BadgeAnimationType.slide,
                    showBadge: valueCart < 1 ? false : true,
                    child: InkWell(
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF9C9FA8),
                        size: 27,
                      ),
                      onTap: () {
                        Get.to(CartPage());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Badge(
                    badgeContent: Text(
                      "$valueChat",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    padding: const EdgeInsets.all(4),
                    badgeColor: const Color(0xFF9C62FF),
                    // animationType: BadgeAnimationType.slide,
                    showBadge: valueChat < 1 ? false : true,
                    child: InkWell(
                      child: const FaIcon(
                        FontAwesomeIcons.commentDots,
                        color: Color(0xFF9C9FA8),
                        size: 25,
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
    int _selectedIndex = 0;
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar,
      body: _widgetOption[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.houseChimney,
              size: 21,
              color: Color(0xFF9C9FA8),
            ),
            label: "Home",
            activeIcon: FaIcon(
              FontAwesomeIcons.houseChimney,
              size: 21,
            ),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.heart,
              size: 21,
              color: Color(0xFF9C9FA8),
            ),
            label: "Wishlist",
            activeIcon: FaIcon(
              FontAwesomeIcons.solidHeart,
              size: 21,
            ),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.fileLines,
              size: 21,
              color: Color(0xFF9C9FA8),
            ),
            label: "Transaksi",
            activeIcon: FaIcon(
              FontAwesomeIcons.solidFileLines,
              size: 21,
            ),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.user,
              size: 21,
              color: Color(0xFF9C9FA8),
            ),
            label: "Profile",
            activeIcon: FaIcon(
              FontAwesomeIcons.solidUser,
              size: 21,
            ),
          ),
        ],
        selectedItemColor: const Color(0xFF9C62FF),
        onTap: _onItemTaped,
      ),
    );
  }
}
