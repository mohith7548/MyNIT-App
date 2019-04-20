import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/pages/app/developer/dev_grid_page.dart';
import 'package:nit_andhra/pages/app/developer/developer_class.dart';

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => _DeveloperPageState();
}

/// This page shows all the developers of MyNiT

class _DeveloperPageState extends State<DeveloperPage> {
  AppState appState;
  List<Developer> developers;

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet the Developers'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('developers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          developers = snapshot.data.documents
              .map((DocumentSnapshot doc) => Developer.from(doc.data))
              .toList();
          return DevGridPage(developers: developers);
        },
      ),
    );
  }
}
