import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // const CartPage({super.key});
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: BackButton(color: Color(0xFF727272)),
        title: Text(
          "Keranjang Saya",
          style: TextStyle(color: Color(0xFF727272), fontSize: 20),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {},
            child: Center(
              child: Container(
                padding: EdgeInsets.all(18),
                child: FaIcon(
                  FontAwesomeIcons.commentDots,
                  color: Color(0xFF9C9FA8),
                  size: 25,
                ),
              ),
            ),
          )
        ],
      ),
    );
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Color(0xff6754B4);
    }

    return Scaffold(
      appBar: myAppBar,
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: bodyHeight * 0.01,
              ),
              Container(
                width: bodyWidth * 10,
                height: bodyHeight * 0.045,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffB5B4B4),
                    ),
                    bottom: BorderSide(
                      color: Color(0xffB5B4B4),
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Container(
                            child: FaIcon(
                              FontAwesomeIcons.store,
                              size: 16,
                              color: Color(0xFF9B9B9B),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Lazy Sunday",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
