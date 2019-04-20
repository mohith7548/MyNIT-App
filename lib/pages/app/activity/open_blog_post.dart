import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/blog/single_post.dart';

class OpenBlogPost extends StatefulWidget {
  final String postReference;

  OpenBlogPost({Key key, @required this.postReference}) : super(key: key);

  @override
  _OpenBlogPostState createState() => _OpenBlogPostState();
}

class _OpenBlogPostState extends State<OpenBlogPost> {
  DocumentSnapshot postSnapshot;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getPostFromDatabase();
  }

  _getPostFromDatabase() async {
    Firestore.instance
        .document(widget.postReference)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _isLoaded = true;
        postSnapshot = documentSnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Post'),
      ),
      body: (_isLoaded)
          ? ListView(
              children: <Widget>[
                SinglePost(
                  FUID: appState.firebaseUser.uid,
                  document: postSnapshot,
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
