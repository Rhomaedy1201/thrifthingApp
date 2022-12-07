import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/app/Pages/myAddressPage.dart';
import '/app/Pages/transactionPage.dart';
import '/app/Pages/wishlistPage.dart';
import '/app/controllers/controll.dart';
import '/app/auth/login/loginPage.dart';

class ProfileBody extends StatefulWidget {
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  List<Widget> iconsAcount = [
    const FaIcon(
      FontAwesomeIcons.fileLines,
      size: 27,
      color: Color(0xFF9C9FA8),
    ),
    const FaIcon(
      FontAwesomeIcons.heart,
      size: 27,
      color: Color(0xFF9C9FA8),
    ),
    const FaIcon(
      FontAwesomeIcons.faceGrinWide,
      size: 27,
      color: Color(0xFF9C9FA8),
    ),
    const FaIcon(
      FontAwesomeIcons.addressCard,
      size: 27,
      color: Color(0xFF9C9FA8),
    ),
  ];

  var result;
  String? currentId;

  Future<void> getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastId;
    });
    Uri url = Uri.parse(
        "http://localhost/restApi_goThrift/users/get_users.php?id_user=${currentId.toString()}");
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode != null) {
      result = json.decode(response.body)['result'];
      setState(() {});
    } else {
      print("response status code profile user salah");
    }
  }

  final List<Widget> _widgetOption = [
    WishlistPage(),
    const TransactionPage(),
  ];

  void removeLogin() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      text: 'Apakah anda yakin ingin logout?',
      confirmBtnColor: Colors.deepPurple,
      cancelBtnText: "Batal",
      confirmBtnText: "Keluar",
      showCancelBtn: true,
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
      onConfirmBtnTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('valueLogin');
        await prefs.remove('idUser');
        Get.offAll(LoginPage());
      },
    );
  }

  final List<String> menuList = [
    "Daftar Transaksi",
    "Wishlist",
    "Kategori",
    "Alamat Saya",
  ];

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

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
    return ListView.builder(
        itemCount: result == null ? 0 : result!.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(
                                  base64Decode(result[index]['profile']))),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  result[index]['nama_lengkap'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  result[index]['email'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff727272),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(0xff727272),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Akun Saya",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                GridView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          // Get.offAll(_widgetOption[0]);
                        } else if (index == 1) {
                          print("2");
                        } else if (index == 2) {
                          print("3");
                        } else if (index == 3) {
                          Get.to(MyAddressPage(
                            idUser: currentId.toString(),
                          ));
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    iconsAcount[index],
                                    const SizedBox(width: 20),
                                    Text(
                                      menuList[index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff727272)),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Color(0xff727272),
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            const Divider(
                              color: Color(0xff727272),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 15,
                    childAspectRatio: 7 / 1,
                  ),
                  shrinkWrap: true,
                  primary: false,
                ),
                const SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  highlightColor: Color(0xFFE7DAFF),
                  onTap: () {
                    removeLogin();
                  },
                  child: Container(
                    width: bodyWidth * 10,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFF9C62FF),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9C62FF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ListMenuAcount extends StatelessWidget {
  ListMenuAcount({
    Key? key,
    this.nama,
    this.icon,
  }) : super(key: key);

  String? nama;
  final icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Menu Aku");
      },
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 13,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon,
                    const SizedBox(width: 20),
                    Text(
                      "${nama}",
                      style: TextStyle(fontSize: 16, color: Color(0xff727272)),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff727272),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            const Divider(
              color: Color(0xff727272),
            )
          ],
        ),
      ),
    );
  }
}
