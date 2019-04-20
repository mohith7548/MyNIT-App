import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/activity/open_blog_post.dart';
import 'package:nit_andhra/pages/app/profile/profile_page.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  /// This page tracks all the things that user does in this app.
  /// Here is the list of possible types in ActivityPage.
  ///
  /// 1. profile-update : Profile is updated. Tap to go to the ProfilePage
  /// 4. blog-add : When posted a post. Tap to open that Blog post
  /// 5. blog-edit : When edited an existing post. Tap to open that Blog post
  ///

  AppState appState;

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    if (this.mounted) {
      setState(() {
        // Rebuild the widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Activity')),
      body: new RefreshIndicator(
        onRefresh: _onRefresh,
        color: appColors.refreshColor,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('users-${appState.user.type}/${appState.firebaseUser
              .uid}/activity')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            return ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot snapshot) {
                return _compareAndGetWidget(context, snapshot);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _compareAndGetWidget(BuildContext context, DocumentSnapshot snapshot) {
    switch (snapshot['type']) {
      case 'blog-add':
        return ListTile(
          title: Text(snapshot['title']),
          subtitle: Text(snapshot['description']),
          onTap: () =>
              _sendTo(context,
                OpenBlogPost(postReference: snapshot['postReference']),
              ),
        );
        break;

      case 'blog-edit':
        return ListTile(
          title: Text(snapshot['title']),
          subtitle: Text(snapshot['description']),
          onTap: () =>
              _sendTo(context,
                OpenBlogPost(postReference: snapshot['postReference']),
              ),
        );
        break;

      case 'profile-update':
        return ListTile(
          title: Text(snapshot['title']),
          onTap: () => _sendTo(context, ProfilePage()),
        );
        break;

      default:
        return Container();
        break;
    }
  }

  _sendTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AppState(
              firebaseUser: appState.firebaseUser,
              user: appState.user,
              changeTheme: appState.changeTheme,
              isDarkThemeEnabled: appState.isDarkThemeEnabled,
              child: page,
            ),
      ),
    );
  }
}
