import 'package:flutter/material.dart';
import '/app/bodyPages/transaksi.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TransactionBody(),
        SizedBox(height: 10),
      ],
    );
  }
}
