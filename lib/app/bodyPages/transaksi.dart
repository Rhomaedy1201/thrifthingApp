import 'dart:convert';

import 'package:flutter/material.dart';

class TransactionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 19),
            child: const Text(
              "Transaksi",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 5,
            color: Color(0xffECEAF3),
            width: double.infinity,
          ),
          const SizedBox(height: 15),
          // ItemsTransaction()
        ],
      ),
    );
  }
}
