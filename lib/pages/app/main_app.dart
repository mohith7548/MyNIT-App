import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/clubs/clubs_page.dart';
import 'package:nit_andhra/pages/app/profile/profile_page.dart';
import 'package:nit_andhra/methods.dart' as methods;
import 'package:nit_andhra/navigarion_drawer.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/blog/blog_page.dart';
import 'package:nit_andhra/pages/app/home/home_page.dart';
import 'package:nit_andhra/pages/app/library/library_page.dart';
import 'package:nit_andhra/pages/app/notifications/notifications_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MainApp extends StatefulWidget {
  MainApp({Key key, @required this.firebaseUser}) : super(key: key);

  final FirebaseUser firebaseUser;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int notificationId = 0;

  HomePage homePage;
  BlogPage blogPage;
  ClubsPage clubsPage;
  LibraryPage libraryPage;
  NotificationsPage notificationsPage;

  AppState appState;
  int i = 0;
  List<Widget> pages;

  static _openNavDrawer() => _scaffoldKey.currentState.openDrawer();

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
    _initializePages();
    _configureLocalNotifications();
  }

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: i,
          children: pages,
        ),
        drawer: AppNavigationDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              title: Text('Blog'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              title: Text('Clubs'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Library'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notifications'),
            ),
          ],
          currentIndex: i,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              i = index;
            });
          },
        ),
      ),
    );
  }

  void _initializePages() {
    homePage = HomePage(openDrawerFunction: () => _openNavDrawer());
    blogPage = BlogPage(openDrawerFunction: () => _openNavDrawer());
    clubsPage = ClubsPage(openDrawerFunction: () => _openNavDrawer());
    libraryPage = LibraryPage(openDrawerFunction: () => _openNavDrawer());
    notificationsPage =
        NotificationsPage(openDrawerFunction: () => _openNavDrawer());
    pages = [
      homePage,
      blogPage,
      clubsPage,
      libraryPage,
      notificationsPage,
    ];
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
        _showFlutterLocalNotifications(
            message['title'], message['body'], message['tag']);
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
        _handleTag(message['tag']);
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
        _handleTag(message['tag']);
      },
    );
  }

  _configureLocalNotifications() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings,
//        selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    /// Here payload is tag
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      _handleTag(payload);
    }
  }

  _showFlutterLocalNotifications(
      String title, String body, String payload) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'my_nit_id', 'nit_andhra', 'MyNiT app for Nit-A.P students',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificationId++, title, body, platformChannelSpecifics,
        payload: payload);
  }

  _handleTag(String tag) {
    if (tag == 'profile-create' || tag == 'profile-update') {
      methods.sendTo(
        context: context,
        page: ProfilePage(),
        appState: appState,
      );
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit MyNiT'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(
                      'No',
                      style: textStyle.copyWith(color: Colors.blue),
                    ),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text(
                      'Yes',
                      style: textStyle.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
