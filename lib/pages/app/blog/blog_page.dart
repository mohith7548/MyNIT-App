import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/blog/post_class.dart';
import 'package:nit_andhra/methods.dart' as methods;
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nit_andhra/pages/app/blog/single_post.dart';
import 'package:nit_andhra/pages/app/blog/add_post_page.dart';

class BlogPage extends StatefulWidget {
  BlogPage({Key key, this.openDrawerFunction}) : super(key: key);

  final VoidCallback openDrawerFunction;

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;
  ScrollController _scrollController;
  List<Post> posts;
  AppState appState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
    )..addListener(() => setState(() {}));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _controller.reverse();
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, isScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: appMenuButton(widget.openDrawerFunction),
              centerTitle: true,
              forceElevated: true,
              title: Text(
                'Blog',
                style: titleStyle,
              ),
            ),
          ];
        },
        body: new RefreshIndicator(
          onRefresh: _onRefresh,
          color: appColors.refreshColor,
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('flutter-posts')
                .orderBy('postTime', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return const Center(child: CircularProgressIndicator());
              return ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return SinglePost(
                    document: document,
                    FUID: appState.firebaseUser.uid,
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildAddPostFab(),
    );
  }

  Widget _buildAddPostFab() {
    return (appState.user.dailyBlogLimit >= 2)
        ? Container()
        : FloatingActionButton(
            child: Icon(Icons.mode_edit),
            tooltip: 'Add a Post',
            onPressed: () {
              // Send to AddPostPage
              methods.sendTo(
                context: context,
                page: AddPostPage(),
                appState: appState,
              );
            },
          );
  }
}
