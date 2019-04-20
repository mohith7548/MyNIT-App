import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState extends InheritedWidget {

  AppState({
    Key key,
    @required this.firebaseUser,
    @required this.user,
    @required this.child,
    this.isDarkThemeEnabled = false,
    this.changeTheme,
  }) : super (key: key, child: child);

  final FirebaseUser firebaseUser;
  final user;
  final Widget child;
  final bool isDarkThemeEnabled;
  final VoidCallback changeTheme;

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return firebaseUser != oldWidget.firebaseUser;
  }

  static AppState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppState);
  }

}