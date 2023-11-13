import 'package:flutter/material.dart';
import 'package:qena_movie/screens/Movie/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = 0;
  // late PageController _controller;

  @override
  void initState() {
    super.initState();
    // _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          // controller: _controller,
          // onPageChanged: (v) {},
          children: [
            DashboardScreen(),
          ],
        ),
      ),
    );
  }
}
