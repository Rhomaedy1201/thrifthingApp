import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CategoryProduct extends StatelessWidget {
  bool satu = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFECEAF3),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.shirt,
                      color: Color(0xFF6754B4),
                      size: 33,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Baju Kaos",
                style: TextStyle(color: Color(0xFF727272), fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFECEAF3),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/iconCategory/hodie.png',
                      height: 65,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Jaket",
                style: TextStyle(color: Color(0xFF727272), fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFECEAF3),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.shoePrints,
                      color: Color(0xFF6754B4),
                      size: 33,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Sepatu",
                style: TextStyle(color: Color(0xFF727272), fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFECEAF3),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/iconCategory/kemeja.png',
                      height: 75,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Kemeja",
                style: TextStyle(color: Color(0xFF727272), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
