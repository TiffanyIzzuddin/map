import 'package:flutter/material.dart';
import 'package:wastetrack/widget/bottom_nav_bar.dart';

void main() {
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

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Salomon Bottom Bar Example'),
        ),
        body: Center(
          child: Text(
            'Selected Tab: $_currentIndex',
            style: TextStyle(fontSize: 24),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
            onTabSelected: _onTabSelected, currentIndex: _currentIndex));
  }
}
