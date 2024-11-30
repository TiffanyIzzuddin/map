import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wastetrack/page/explore.dart';
import 'package:wastetrack/page/profile.dart';
import 'package:wastetrack/widget/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter diinisialisasi
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF3468C0),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ExplorePage(), // Page untuk Explore
    Center(child: Text('Home Page')), // Page untuk Home
    ProfilePage(), // Page untuk Profile
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
            onTabSelected: _onTabSelected, currentIndex: _currentIndex));
  }
}
