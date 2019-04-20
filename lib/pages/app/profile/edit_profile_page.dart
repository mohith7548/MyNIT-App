import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nit_andhra/main.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter_image_pick_crop/flutter_image_pick_crop.dart';
import 'package:nit_andhra/methods.dart' as methods;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;

//  final _fullNameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  String _fullName, _displayName, _bio;
  DateTime _formDate = DateTime.now();
  String _dateString;
  bool _isFirstTime = true;
  bool _isEditable = true;

  String _platformMessage = 'Unknown';
  String _camera = 'fromCameraCropImage';
  String _gallery = 'fromGalleryCropImage';
  File imageFile;
  bool _isImageSelected = false;

  final Firestore firestore = Firestore.instance;

  _getProfilePicDownloadUrl(String UID) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('profle_images_flutter')
        .child('$UID.jpeg');
    final StorageUploadTask uploadTask = ref.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageDownloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print('_getDownloadUrl: $imageDownloadUrl');
    return imageDownloadUrl;
  }

  _update(String type, FirebaseUser firebaseUser) async {
    if (!_isImageSelected) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'Please use a profile image',
      );
      return;
    }
    print('${_displayNameController.text} ${_bioController.text}');
    if (!_isEditable) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'Update in Progress',
      );
    }
    if (validateName(_displayNameController.text) &&
        validateBio(_bioController.text)) {
      setState(() {
        _isEditable = false;
      });
      try {
        var formatter = DateFormat('dd/MM/yyyy');
        _dateString = formatter.format(_formDate);
        String photoUrl;
        photoUrl = await _getProfilePicDownloadUrl(firebaseUser.uid);
        print('_update: $photoUrl');
        var batch = Firestore.instance.batch();
        Map<String, dynamic> map = {
          'dateOfBirth': _dateString,
          'displayName': _displayNameController.text.trim(),
          'bio': _bioController.text.trim(),
          'photoUrl': photoUrl.toString(),
        };
        Map<String, dynamic> activityMap = {
          'type': 'profile-update',
          'title': 'Profile is updated',
          'timeStamp': DateTime.now(),
        };
        DocumentReference updateProfileReference =
            firestore.collection('users-$type').document(firebaseUser.uid);
        DocumentReference activtyReference = firestore
            .collection('users-$type')
            .document(firebaseUser.uid)
            .collection('activity')
            .document();
        batch.updateData(updateProfileReference, map);
        batch.setData(activtyReference, activityMap);

        batch.commit().whenComplete(() {
          _afterComplete(firebaseUser);
        }).catchError((error) {
          methods.showSnackbar(
            scaffoldState: _scaffoldKey.currentState,
            msg: error.toString(),
          );
          setState(() {
            _isEditable = true;
          });
        });
      } catch (e) {
        methods.showSnackbar(
          scaffoldState: _scaffoldKey.currentState,
          msg: e.toString(),
        );
        setState(() {
          _isEditable = true;
        });
      }
    } else {
      setState(() {
        _isEditable = true;
      });
    }
  }

  _afterComplete(FirebaseUser firebaseUser) {
    print('After update-completion session');
    methods.showSnackbar(
      scaffoldState: _scaffoldKey.currentState,
      msg: 'Update Sucessful!',
      seconds: 4,
    );
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyNit()),
          (Route<dynamic> route) => false);
    });
  }

  initGalleryPickUp() async {
    String result;
    _isImageSelected = true;
    try {
//      result = await FlutterImagePickCrop.pickAndCropImage(_gallery);
    } catch (e) {
      result = e.message;
      _isImageSelected = false;
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      imageFile = new File(result);
      _platformMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final bool _hasImage = (appState.user.photoUrl == null) ? false : true;
    if (_isFirstTime) {
      _displayNameController.text = appState.user.displayName;
      _bioController.text = appState.user.bio;

      if (appState.user.dateOfBirth != null) {
        var formatter = DateFormat('dd/MM/yyyy');
        _formDate = formatter.parse(appState.user.dateOfBirth);
//        print(_formDate);
      }

      _isFirstTime = false;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.update,
              color: Colors.yellowAccent,
            ),
            onPressed: () {
              _update(appState.user.type, appState.firebaseUser);
            },
            tooltip: 'Update Profile',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: initGalleryPickUp,
                child: new Hero(
                  tag: 'profile-pic',
                  child: CircleAvatar(
                    backgroundImage: imageFile == null
                        ? ((_hasImage)
                            ? CachedNetworkImageProvider(appState.user.photoUrl)
                            : AssetImage(
                                'assets/images/${appState.user.sex}-user.png'))
                        : FileImage(imageFile),
                    radius: 80.0,
                  ),
                ),
              ),
              Text('Tap to choose your image'),
              const SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  filled: true,
                  icon: const Icon(Icons.person),
                  hintText: (appState.user.displayName == "")
                      ? 'Friends call you as'
                      : appState.user.displayName,
                  labelText: 'Display Name *',
                ),
                enabled: _isEditable,
                controller: _displayNameController,
                onChanged: (String value) {
                  _displayName = value;
                },
              ),
              const SizedBox(height: 8.0),
              _DatePicker(
                labelText: 'Date of Birth',
                selectedDate: _formDate,
                selectDate: (DateTime date) {
                  setState(() {
                    _formDate = date;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              TextField(
                decoration: const InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Tell us about yourself',
                  helperText: 'Keep it short, this is just a info.',
                  labelText: 'Life story',
                ),
                enabled: _isEditable,
                controller: _bioController,
                onChanged: (String value) {
                  _bio = value;
                },
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateName(String value) {
    if (value.isEmpty || value == "") {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'DisplayName is required.',
        seconds: 4,
      );
      return false;
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'Please enter only alphabetical characters.',
        seconds: 4,
      );
      return false;
    }
    return true;
  }

  bool validateBio(String value) {
    if (value.isEmpty || value == "") {
      methods.showSnackbar(
        scaffoldState: _scaffoldKey.currentState,
        msg: 'Bio is required.',
        seconds: 4,
      );
      return false;
    }
    return true;
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1947, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              DateFormat.yMMMd().format(selectedDate),
              style: valueStyle,
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            )
          ],
        ),
      ),
    );
  }
}
