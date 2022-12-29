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

// class ItemsTransaction extends StatefulWidget {
//   @override
//   State<ItemsTransaction> createState() => _ItemsTransactionState();
// }

// class _ItemsTransactionState extends State<ItemsTransaction> {
  // List result = [];
  // Future<void> getTransaksi() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? lastId = await Controller1.getCheckIdUser();
  //   var currentId = lastId;
  //   Uri url = Uri.parse(
  //       "http://localhost/restApi_goThrift/transaksi/get_transaksi.php?id_alamat_user=${currentId}");
  //   var response = await http.get(url);
  //   result = json.decode(response.body)['result'];
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   getTransaksi();
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 19),
  //     child: 
  //   );
  // }
// }
