import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/methods.dart' as methods;
import 'package:nit_andhra/pages/app/developer/developer_page.dart';
import 'package:nit_andhra/pages/app/about/about_page.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/profile/profile_page.dart';
import 'package:nit_andhra/pages/app/saved_images/saved_images_page.dart';
import 'package:nit_andhra/pages/auth/login_page.dart';
import 'package:nit_andhra/pages/app/activity/activity_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppNavigationDrawer extends StatefulWidget {
  @override
  _AppNavigationDrawerState createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  AppState appState;

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(appState.firebaseUser.email),
            accountName: Text(appState.user.fullName),
            currentAccountPicture: GestureDetector(
              onTap: () => methods.sendTo(
                    appState: appState,
                    context: context,
                    page: ProfilePage(),
                  ),
              child: Hero(
                tag: 'profile-pic',
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(appState.user.photoUrl),
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/college.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
            ),
          ),
          ListTile(
            title: Text('Dark Theme'),
            trailing: Switch(
              value: appState.isDarkThemeEnabled,
              onChanged: (bool b) {
                methods.savePrefs(saveInName: 'isDarkThemeEnabled', data: b);
                appState.changeTheme();
              },
            ),
          ),
          ListTile(
            title: Text('Activity'),
            leading: Icon(
              Icons.query_builder,
              color: appColors.activity,
            ),
            onTap: () {
              Navigator.pop(context);
              methods.sendTo(
                appState: appState,
                context: context,
                page: ActivityPage(),
              );
            },
          ),
          ListTile(
            title: Text('Saved Images'),
            leading: Icon(
              Icons.file_download,
              color: appColors.savedImages,
            ),
            onTap: () {
              Navigator.pop(context);
              methods.sendTo(
                appState: appState,
                context: context,
                page: SavedImagesPage(),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('About MyNiT'),
            leading: Icon(
              Icons.info,
              color: appColors.about,
            ),
            onTap: () {
              Navigator.pop(context);
              methods.sendTo(
                appState: appState,
                context: context,
                page: AboutPage(),
              );
            },
          ),
          ListTile(
            title: Text('Meet the Developers'),
            leading: Icon(
              Icons.developer_mode,
              color: appColors.developer,
            ),
            onTap: () {
              Navigator.pop(context);
              methods.sendTo(
                appState: appState,
                context: context,
                page: DeveloperPage(),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(
              Icons.power_settings_new,
              color: appColors.logout,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to Logout?'),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: new Text(
                          'No',
                          style: textStyle.copyWith(color: Colors.blue),
                        ),
                      ),
                      new FlatButton(
                        onPressed: () => _logOutUser(),
                        child: new Text(
                          'Yes',
                          style: textStyle.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _logOutUser() {
    // Sign out user from app
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}
