import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/model/faculty.dart';
import 'package:nit_andhra/model/student.dart';
import 'package:nit_andhra/pages/app-carousel/app_carousel.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/main_app.dart';
import 'package:nit_andhra/pages/app/profile/edit_profile_page.dart';
import 'package:nit_andhra/methods.dart' as methods;

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
  runApp(MyNit());
}

class MyNit extends StatefulWidget {
  @override
  _MyNitState createState() => _MyNitState();
}

class _MyNitState extends State<MyNit> {
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isSignedIn = false;

  /// This user may be student or faculty and is final because it's not changed
  var user;
  String type, col;
  bool _isLoading = true;
  bool hasNoProfile = false;
  bool _isDarkThemeEnabled = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: (_isDarkThemeEnabled) ? appDarkThemeData : appLightThemeData,
      debugShowCheckedModeBanner: false,
      home: (_isSignedIn)
          ? ((_isLoading)
      // TODO: Replace wth splash screen
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : ((hasNoProfile)
          ? AppState(
          firebaseUser: firebaseUser,
          user: user,
          child: EditProfilePage())
          : AppState(
        firebaseUser: firebaseUser,
        user: user,
        isDarkThemeEnabled: _isDarkThemeEnabled,
        changeTheme: () => _changeTheme(),
        child: MainApp(firebaseUser: firebaseUser),
      )))
          : AppCarousel(),
    );
  }

  _getCurrentUser() async {
    firebaseUser = await _auth.currentUser().catchError((error) {
      print(error);
    });
    print('FirebaseUser: ${firebaseUser.toString()}');
    if (firebaseUser != null) {
      // shared preferences are retrieved only when user is present i.e, SignedIn.
      _getSharedPreferences();
      setState(() {
        print('_signedIn: true --> ${DateTime.now()}');
        _isSignedIn = true;
      });
    }
  }

  void _getSharedPreferences() async {
    type = await methods.getPrefs(saveInName: 'type');
    _isDarkThemeEnabled = await methods.getPrefs(saveInName: 'isDarkThemeEnabled') ?? false;
    print('_isDarkThemeEnabled: $_isDarkThemeEnabled --> ${DateTime.now()}');
    print('type: $type');
    col = 'users-$type';
    print('collection: $col --> ${DateTime.now()}');
    _getUserFromDatabase();
  }

  void _getUserFromDatabase() async {
    print('in getting user');
    Firestore.instance
        .collection(col)
        .document(firebaseUser.uid)
        .get()
        .then((snapshot) {
      print(snapshot.data);
      if (type == 'student') {
        user = Student.from(snapshot.data);
        _checkAndSendToProfilePage();
        print('_isLoading = false --> ${DateTime.now()}');
        setState(() => _isLoading = false);
      } else if (type == 'faculty') {
        user = Faculty.from(snapshot.data);
        _checkAndSendToProfilePage();
        print('_isLoading = false --> ${DateTime.now()}');
        setState(() => _isLoading = false);
      }
    });
  }

  _checkAndSendToProfilePage() {
    print("displayName: '${user.displayName}' --> ${DateTime.now()}");
    if (user.photoUrl == null || user.displayName == null) {
      print('hasNoProfile: $hasNoProfile --> ${DateTime.now()}');
      setState(() => hasNoProfile = true);
      // Sent through checking bool value in build function
    } else {
      hasNoProfile = false;
    }
  }

  _changeTheme() {
    print('toggled theme');
    setState(() {
      _isDarkThemeEnabled = !_isDarkThemeEnabled;
    });
  }
}