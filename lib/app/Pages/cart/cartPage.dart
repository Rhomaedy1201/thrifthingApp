import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // const CartPage({super.key});
  bool isChecked = false;

  List listItems = [
    'Sepatu',
    'Sandal',
    'Topi',
  ];

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 0,
        shadowColor: Color.fromARGB(255, 255, 255, 255),
        title: Column(
          children: [
            const Text(
              "Keranjang Saya",
              style: TextStyle(
                color: Color(0xFF414141),
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${listItems.length} Produk",
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF828282),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );

    Widget bottomNavBar() {
      return Container(
        width: bodyWidth * 10,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Total:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF828282),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Rp300.000",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF414141),
                  ),
                ),
              ],
            ),
            Container(
              width: 220,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C62FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Check Out",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget items() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFBBB7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6F65),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.delete,
                    size: 27,
                    color: Colors.white,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              key: Key(listItems[index]),
              onDismissed: (direction) {
                setState(() {
                  listItems.removeAt(index);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFE4E4E4),
                      blurRadius: 3,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCECECE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 220,
                            // color: Colors.amber,
                            child: const Text(
                              "Nama Produk ",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 9),
                          Row(
                            children: const [
                              Text(
                                "Rp20.000",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9C62FF),
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                "x2",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8A8A8A),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              confirmDismiss: (direction) {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Confirm"),
                      content: Text(
                        "Are you sure to delete this project ?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            childAspectRatio: 10 / 3,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: myAppBar,
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavBar(),
      body: ListView(
        children: [
          items(),
        ],
      ),
    );
  }
}
