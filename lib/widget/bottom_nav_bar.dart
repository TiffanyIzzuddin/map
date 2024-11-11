import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  BottomNavBar({required this.onTabSelected, required this.currentIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Batas tepi kanan dan kiri
      child: SalomonBottomBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabSelected,
        items: [
          /// Explore
          SalomonBottomBarItem(
            icon: Icon(Icons.explore),
            title: Text("Explore"),
            selectedColor: Color(0xFFFF9843),
          ),

          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Color(0xFFFF9843),
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Color(0xFFFF9843),
          ),
        ],
      ),
    );
  }
}
