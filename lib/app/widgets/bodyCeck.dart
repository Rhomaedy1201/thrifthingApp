// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BodyCeck extends StatelessWidget {
  const BodyCeck({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    final myAppBar = AppBar();
    final bodyHeight = mediaQueryHeight -
        myAppBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Container();
  }
}
