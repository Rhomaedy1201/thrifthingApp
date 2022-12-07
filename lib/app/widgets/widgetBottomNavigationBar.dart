import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WidgetBottomNavigationBar extends StatefulWidget {
  const WidgetBottomNavigationBar({super.key});

  @override
  State<WidgetBottomNavigationBar> createState() =>
      _WidgetBottomNavigationBarState();
}

class _WidgetBottomNavigationBarState extends State<WidgetBottomNavigationBar> {
  int _currentIndex = 0;

  static const List<Widget> widgetOption = [
    Text("Home"),
    Text("Wishlist"),
    Text("Transaksi"),
    Text("Profile"),
  ];

  void _onItemTaped(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 13,
      unselectedFontSize: 13,
      items: [
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
      selectedItemColor: Color(0xFF6754B4),
      onTap: _onItemTaped,
    );
  }
}
