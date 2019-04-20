import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'single_announcement.dart';
import 'dart:async';

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    if(this.mounted) {
      setState(() {
        // Rebuild the widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
//      padding: const EdgeInsets.all(8.0),
      child: new RefreshIndicator(
        color: appColors.refreshColor,
        onRefresh: _onRefresh,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('announcements')
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            return ListView(
              padding: EdgeInsets.all(0.0),
              children: snapshot.data.documents.map((DocumentSnapshot snapshot) {
                if(snapshot['type'] == 'all' || snapshot['type'] == appState.user.type) {
                  return SingleAnnouncement(snapshot: snapshot);
                }
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

