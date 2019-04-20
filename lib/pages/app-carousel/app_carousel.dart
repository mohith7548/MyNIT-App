import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app-carousel/screen_one.dart';
import 'package:nit_andhra/pages/app-carousel/screen_three.dart';
import 'package:nit_andhra/pages/app-carousel/screen_two.dart';

class AppCarousel extends StatefulWidget {
  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel>
    with SingleTickerProviderStateMixin {
  List<Widget> screens = [
    ScreenOne(),
    ScreenTwo(),
    ScreenThree(),
  ];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(vsync: this, length: screens.length, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Automatically changes the pages
      body: TabBarView(
        controller: _controller,
        children: screens,
      ),
    );
  }
}
