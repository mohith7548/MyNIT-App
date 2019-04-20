import 'dart:async';
import 'dart:io';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/secure_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nit_andhra/methods.dart' as methods;

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File _image;
  final TextEditingController _descController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isEditable = true;
  SecureString secureString = SecureString();
  AppState appState;
  final firestore = Firestore.instance;

  Future getImage() async {
    if (_isEditable) {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }
  }

  _getDownloadUrl() async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('post_images_flutter')
        .child('${secureString.generateAlphaNumeric(length: 20)}.jpeg');
    final StorageUploadTask uploadTask = ref.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageDownloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print('_getDownloadUrl: $imageDownloadUrl');
    return imageDownloadUrl;
  }

  _post() async {
    print('_descController.text : ${_descController.text}');
    if (appState.user.dailyBlogLimit >= 2) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'You have completed your daily blog limit',
        milliSeconds: 800,
      );
      return;
    }
    if (_image == null ||
        _descController.text == '' ||
        _descController.text.isEmpty) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'please fill all details',
        milliSeconds: 800,
      );
      return;
    }
    setState(() {
      _isEditable = false;
    });
    final imageUrl = await _getDownloadUrl();
    print('inside _post method: $imageUrl');

    var batch = firestore.batch();
    DocumentReference postReference =
        firestore.collection('flutter-posts').document();

    DocumentReference activityReference = firestore
        .collection('users-${appState.user.type}')
        .document(appState.firebaseUser.uid)
        .collection('activity')
        .document();

    DocumentReference useUpdateReference = firestore
        .collection('users-${appState.user.type}')
        .document(appState.firebaseUser.uid);

    Map<String, dynamic> postMap = {
      'postDescription': _descController.text.trim(),
      'postImageUrl': imageUrl.toString(),
      'postOwner': appState.user.fullName,
      'postLikes': 0,
      'postOwnerImageUrl': appState.user.photoUrl,
      'postTime': DateTime.now(),
    };
    Map<String, dynamic> activityMap = {
      'title': 'You have posted a photo in Blog Page',
      'timeStamp': DateTime.now(),
      'type': 'blog-add',
      'description': _descController.text.trim(),
      'postReference': postReference.path,
    };

    batch.setData(postReference, postMap);
    batch.setData(activityReference, activityMap);
    // Decrease the dailyBlogLimit
    batch.updateData(
        useUpdateReference, {'dailyBlogLimit': ++appState.user.dailyBlogLimit});
    print('dailyBlogLimit: ${appState.user.dailyBlogLimit}');
    batch.commit().whenComplete(() {
      _afterComplete();
    }).catchError((error) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: error.toString(),
        milliSeconds: 800,
      );
      setState(() {
        _isEditable = true;
      });
    });
  }

  _afterComplete() {
    methods.showSnackbar(
      scaffoldState: _scaffoldKey.currentState,
      msg: 'Update Sucessful!',
      milliSeconds: 800,
    );
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

//  _showSnackBar(String value) {
//    _scaffoldKey.currentState.showSnackBar(
//      SnackBar(
//        content: Text(value),
//        duration: Duration(seconds: 4),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Write a New Post', style: titleStyle),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: getImage,
                child: Image(
                  image: _image == null
                      ? AssetImage('assets/images/post_placeholder.png')
                      : FileImage(_image),
                ),
              ),
              SizedBox(height: 32.0),
              TextField(
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Describe the post',
//                helperText: 'Keep it short.',
                  labelText: 'Post Description',
                ),
                enabled: _isEditable,
                controller: _descController,
                maxLines: 3,
              ),
              SizedBox(height: 32.0),
              (_isEditable)
                  // Change this button
                  ? RawMaterialButton(
                      onPressed: () => _post(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.create),
                          SizedBox(width: 16.0),
                          Text(
                            'Add Post',
                            style: titleStyle.copyWith(fontSize: 24.0),
                          ),
                        ],
                      ),
                      fillColor: Colors.lime,
                      splashColor: Colors.yellowAccent,
                      shape: StadiumBorder(),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
