import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/home/announcements_tab.dart';
import 'package:nit_andhra/pages/app/home/achievements_tab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.openDrawerFunction}) : super(key: key);

  final VoidCallback openDrawerFunction;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool isScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: appMenuButton(widget.openDrawerFunction),
              centerTitle: true,
              title: const Text('Home', style: titleStyle),
              pinned: true,
              floating: true,
              forceElevated: true,
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: 'Announcements',
                    icon: const Icon(Icons.announcement),
                  ),
                  Tab(
                    text: 'Achievements',
                    icon: const Icon(Icons.collections_bookmark),
                  ),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            AnnouncementsPage(),
            AchievementsPage(),
          ],
        ),
      ),
    );
  }
}
