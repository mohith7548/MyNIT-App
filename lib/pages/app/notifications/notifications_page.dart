import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/app_state.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key, this.openDrawerFunction}) : super(key: key);
  final VoidCallback openDrawerFunction;

  @override
  NotificationsPageState createState() {
    return new NotificationsPageState();
  }
}

class NotificationsPageState extends State<NotificationsPage> {
  /// This Page contains all the documents present in the 'notifications' collection
  /// present in the user document.

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
    final appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: appMenuButton(widget.openDrawerFunction),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: titleStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: appColors.refreshColor,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('users-${appState.user.type}')
              .document('${appState.firebaseUser.uid}')
              .collection('notifications')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            return ListView(
              padding: const EdgeInsets.all(0.0),
              children: snapshot.data.documents.map((DocumentSnapshot snapshot) {
                switch(snapshot['type']) {
                  case '':
                    return ListTile(
                      title: Text(
                        snapshot['title'],
                        style: textStyle,
                      ),
                      onTap: () {},
                    );
                  default:
                    return ListTile(
                      title: Text(
                        snapshot['title'],
                        style: textStyle,
                      ),
                      onTap: () {},
                    );
                }
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
