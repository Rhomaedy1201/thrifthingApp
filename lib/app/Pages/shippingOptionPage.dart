import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ShippingOption extends StatefulWidget {
  var pengiriman;
  ShippingOption({super.key, this.pengiriman});

  @override
  State<ShippingOption> createState() => _ShippingOptionState();
}

class _ShippingOptionState extends State<ShippingOption> {
  @override
  void initState() {
    print(widget.pengiriman);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF9C62FF)),
        elevation: 2,
        shadowColor: Color(0xFFF4F1F6),
        title: const Text(
          "Opsi Pengiriman",
          style: TextStyle(
            color: Color(0xFF414141),
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop("POS");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Text(
                      "POS (Pos Indonesia)",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                  (widget.pengiriman == "POS")
                      ? Icon(
                          Icons.check,
                          size: 25,
                        )
                      : Text(""),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C62FF),
                minimumSize: Size(double.infinity, 55),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop("TIKI");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    child: Text(
                      "TIKI (Titipan Kilat)",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                  (widget.pengiriman == "TIKI")
                      ? Icon(
                          Icons.check,
                          size: 25,
                        )
                      : Text("")
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C62FF),
                minimumSize: Size(double.infinity, 55),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
