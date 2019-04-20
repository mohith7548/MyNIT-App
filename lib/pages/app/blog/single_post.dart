import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/blog/post_class.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/blog/open_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nit_andhra/methods.dart' as methods;

class SinglePost extends StatefulWidget {
  final DocumentSnapshot document;
  final String FUID;

  const SinglePost({Key key, this.document, this.FUID}) : super(key: key);

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  final liked = Icons.favorite;
  final notLiked = Icons.favorite_border;
  final _formatter = DateFormat('dd MMM, yyyy  ').add_jm();
  Firestore firestore = Firestore.instance;
  DocumentReference userLikeReference;
  DocumentReference activityReference;
  AppState appState;
  int postLikes;
  bool _isLiked = false;
  bool _userLikeStatusLoaded = false;

  @override
  void initState() {
    super.initState();
    userLikeReference = firestore
        .document(widget.document.reference.path)
        .collection('postLikedUsers')
        .document(widget.FUID);
    _didUserLikePost();
  }

  _didUserLikePost() async {
    DocumentSnapshot snapshot = await userLikeReference.get();
    if (snapshot.data != null) {
      if (this.mounted) {
        setState(() {
          _isLiked = true;
        });
      }
    }
    _userLikeStatusLoaded = true;
  }

  _toggleLikeStatus() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  _likePost() async {
    if (this.mounted) {
      _toggleLikeStatus();
    }

    /// 1. Fetch the latest postLikes value, increment it and Update it using transactions.
    /// 2. Write a document in potLikeUsers collection with UID having a 'timeStamp' field.
    /// 3. Store the activity in user's database.
    firestore.runTransaction((Transaction transaction) {
      return transaction
          .get(widget.document.reference)
          .then((DocumentSnapshot snapshot) async {
        final post = Post.from(snapshot);
        final activityMap = {
          'title': 'You have liked a post',
          'description': post.postDescription,
          'type': 'blog-edit',
          'postReference': post.reference.path,
          'timeStamp': DateTime.now(),
        };
        post.postLikes += 1;
        print('inside add-like transaction');
        await transaction.update(post.reference, {'postLikes': post.postLikes});
        print('after updating post likes');
        await transaction.set(userLikeReference, {'timeStamp': DateTime.now()});
        print('inside setting user like');
        await transaction.set(activityReference, activityMap);
        print('after setting in activity');
      });
    }).whenComplete(() {
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: 'Post Liked!',
        milliSeconds: 800,
      );
    }).catchError((error) {
      if (this.mounted) _toggleLikeStatus();
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: error.toString(),
        milliSeconds: 800,
      );
    });
  }

  _dislikePost() async {
    if (this.mounted) {
      _toggleLikeStatus();
    }

    /// 1. Fetch the latest value of postLikes and decrement it and update again
    /// 2. Delete the user like document
    /// 3. Add this in activity of user's database
    firestore.runTransaction((Transaction transaction) {
      return transaction
          .get(widget.document.reference)
          .then((DocumentSnapshot snapshot) async {
        final post = Post.from(snapshot);
        if (post.postLikes <= 0) {
          return;
        }
        final activityMap = {
          'title': 'You have disliked a post',
          'description': post.postDescription,
          'type': 'blog-edit',
          'postReference': post.reference.path,
          'timeStamp': DateTime.now(),
        };
        post.postLikes -= 1;
        print('inside dis-like transaction');
        await transaction.update(post.reference, {'postLikes': post.postLikes});
        print('after updating post likes');
        await transaction.delete(userLikeReference);
        print('after deleting userLike document');
        await transaction.set(activityReference, activityMap);
        print('after setting in activity');
      });
    }).whenComplete(() {
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: 'Post Disiked!',
        milliSeconds: 800,
      );
    }).catchError((error) {
      if (this.mounted) _toggleLikeStatus();
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: error.toString(),
        milliSeconds: 800,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    activityReference = firestore
        .collection('users-${appState.user.type}')
        .document(appState.firebaseUser.uid)
        .collection('activity')
        .document();
//    print('inside build function: ${widget.document.reference.path} - $_isLiked');
    postLikes = widget.document['postLikes'];
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    widget.document['postOwnerImageUrl'],
                  ),
                  radius: 24.0,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.document['postOwner'],
                      style: darkText,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      _formatter.format(widget.document['postTime']),
                      style: primaryText,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Hero(
            tag: '${widget.document.reference.path}',
            child: GestureDetector(
              onTap: () => methods.sendTo(
                    context: context,
                    page: OpenImage(document: widget.document),
                    appState: appState,
                  ),
              child: CachedNetworkImage(
                imageUrl: widget.document['postImageUrl'],
                placeholder: Image.asset('assets/images/image_placeholder.png'),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.document['postDescription'].toString().trim(),
              style: primaryText,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        if (_userLikeStatusLoaded) {
                          print(widget.document.reference.path);
                          print(_isLiked);
                          (_isLiked) ? _dislikePost() : _likePost();
                        } else
                          methods.showSnackbar(
                            scaffoldState: Scaffold.of(context),
                            msg: 'Try again!',
                            milliSeconds: 800,
                          );
                      },
                      icon: Icon(
                        (_isLiked) ? liked : notLiked,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      (postLikes == 1)
                          ? '$postLikes  Like'
                          : '$postLikes  Likes',
                      style: primaryText,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        _shareImage(context);
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Share',
                      style: primaryText,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _shareImage(BuildContext context) async {
    methods.showSnackbar(
      scaffoldState: Scaffold.of(context),
      msg: 'Please wait..',
      milliSeconds: 800,
    );
    try {
      http
          .readBytes(widget.document['postImageUrl'])
          .then((Uint8List list) async {
        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/image.jpg').create();
        file.writeAsBytesSync(list);
        final channel = const MethodChannel('channel:me.albie.share/share');
        channel.invokeMethod('shareFile', 'image.jpg');
      });
    } catch (e) {
      print(e.toString());
      methods.showSnackbar(
        scaffoldState: Scaffold.of(context),
        msg: e.toString(),
        milliSeconds: 800,
      );
    }
  }
}
