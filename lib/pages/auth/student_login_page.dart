import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nit_andhra/main.dart';
import 'package:nit_andhra/methods.dart';
import 'package:nit_andhra/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:nit_andhra/methods.dart' as methods;

class StudentLoginPage extends StatefulWidget {
  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email, _password, _rePassword, _regNo, _fullName, _branch, sex = 'F';
  TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  bool _inProgress = false;
  String _type = 'existing-user';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String deviceTokenId;

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
//    _showDailyNotifications();
  }

  _showDailyNotifications() async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var time = Time(7, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'my_nit_id', 'nit_andhra', 'MyNiT app for Nit-A.P students',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(

        /// id of daily wisher...
        1,
        'Hey! Good Morning',
        'Have a Great day.',
        time,
        platformChannelSpecifics);
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _inProgress = true;
      });
      print('Email: $_email    Password: $_password');

      var snapshot = await FirebaseDatabase.instance
          .reference()
          .child('student')
          .child(_regNo)
          .once()
          .catchError((error) {
        print(error.toString());
        handleError(error.toString());
      });

      if (snapshot.value != null) {
        // Save preferences
        savePrefs(saveInName: 'type', data: 'student');
        String _offEmail = snapshot.value['email'];
        String _signedin = snapshot.value['signedin'];
        print(snapshot.value['rollNo'].runtimeType);
        String _rollNo = snapshot.value['rollNo'];
        _fullName = snapshot.value['fullName'];
        _branch = snapshot.value['branch'];
        print(
            '_offEmail: $_offEmail -- _signedIn: $_signedin -- _fullName: $_fullName -- _branch: $_branch');

        if (_offEmail == _email) {
          // given email matched with email in database !
          // Proceed with sign in process
          print('Email matched');
          if (_signedin == 'T') {
            print('True');
            _loginExistingUser(_email, _password);
          } else if (_signedin == 'F') {
            print('False');
            if (_password == _rePassword) {
              _createUser(_email, _password, _rollNo);
            } else {
              handleError('both passwords don\'t match');
            }
          } else {
            handleError('_signedIn is neither T nor F');
          }
        } else {
          handleError("Your email doesn't match with the official email!");
        }
      } else {
        handleError('Snapshot is null!');
      }
    }
  }

  void _createUser(String email, String password, String rollNo) async {
    print('Signin method');
    // Also change the 'signedin' variable to 'T' in firebaseDatabase
    Map<String, String> map = {'signedin': 'T'};
    FirebaseDatabase.instance
        .reference()
        .child('student')
        .child(_regNo)
        .update(map)
        .catchError((error) {
      print(error.toString());
      handleError(error.toString());
    });
    user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      print(error.toString());
      handleError(error.toString());
    });
    print(user.toString());
    if (user != null) {
      _createUserInDatabase(rollNo);
    } else {
      handleError('user is null. error while creating!');
    }
    // Show the user HomeScreen of the App
  }

  void _createUserInDatabase(String rollNo) async {
    deviceTokenId = await _firebaseMessaging.getToken();
    print('deviceTokenId: $deviceTokenId');
    Student student = Student.data(
      fullName: _fullName,
      sex: sex,
      deviceTokenId: deviceTokenId,
      regNo: int.parse(_regNo),
      rollNo: int.parse(rollNo),
      branch: _branch,
      dailyBlogLimit: 0,
    );
    final data = student.toMap();
    print(data);
    Firestore.instance
        .collection('users-student')
        .document(user.uid)
        .setData(data)
        .catchError((error) => print(error))
        .whenComplete(() {
      // When complete sent to MainApp
      sendToMainApp();
    }).catchError((error) {
      handleError(error.toString());
    });
  }

  void _loginExistingUser(String email, String password) async {
    print('Login method');
    user = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      print(error.toString());
      handleError(error.toString());
    });
    print(user.toString());
    if (user != null) {
      deviceTokenId = await _firebaseMessaging.getToken();
      print('deviceTokenId: $deviceTokenId');
      Firestore.instance
          .collection('users-student')
          .document(user.uid)
          .updateData({'deviceTokenId': deviceTokenId}).catchError((error) {
        handleError(error.toString());
      }).whenComplete(() {
        sendToMainApp();
      });
    } else {
      handleError('user is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/student.jpeg'),
            colorFilter: new ColorFilter.mode(Colors.black54, BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 18.0,
                ),
              ),
            ),
            child: ListView(
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _userTypeChooser(),
//                (_type == 'new-user') ? _fullNameField() : Container(),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Registration number',
                    icon: Icon(Icons.confirmation_number),
                  ),
                  maxLength: 6,
                  enabled: !_inProgress,
                  validator: validateRegNo,
                  onSaved: (value) => _regNo = value,
                  keyboardType: TextInputType.number,
                ),
//                (_type == 'new-user') ? _branchSelect : Container(),
//            Container(height: 16.0,),
                TextFormField(
                  validator: validateEmail,
                  onSaved: (value) => _email = value,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    icon: Icon(Icons.email),
                  ),
                  enabled: !_inProgress,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  validator: validatePassword,
                  controller: _passwordController,
                  onSaved: (value) => _password = value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  enabled: !_inProgress,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                (_type == 'new-user') ? _confirmPassword() : Container(),
                const SizedBox(height: 20.0),
                (_type == 'new-user') ? _sexSelect() : Container(),
                SizedBox(height: 24.0),
                (_inProgress)
                    ? new Center(child: CircularProgressIndicator())
                    : _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendToMainApp() {
    // Check user has profile or not
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyNit()),
        (Route<dynamic> route) => false);
  }

  void handleError(String s) {
    setState(() {
      _inProgress = false;
    });
    methods.showSnackbar(
      scaffoldState: _scaffoldKey.currentState,
      msg: s,
      seconds: 5,
    );
  }

  String validateConfirmPassword(String value) {
    if (value != _passwordController.text) {
      return 'both passwords don\'t match';
    }
    if (value.isEmpty) {
      return 'please confirm password';
    }
    if (value.length < 6) {
      return 'please enter more than 6 characters';
    }
    return null;
  }

  Widget _userTypeChooser() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile(
            title: const Text('New User'),
            value: 'new-user',
            groupValue: _type,
            onChanged: (value) {
              setState(() {
                _type = value;
                print(_type);
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Existing User'),
            value: 'existing-user',
            groupValue: _type,
            onChanged: (value) {
              setState(() {
                _type = value;
                print(_type);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _confirmPassword() {
    return TextFormField(
      validator: validateConfirmPassword,
      onSaved: (value) => _rePassword = value,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        icon: Icon(Icons.lock),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
    );
  }

  Widget _fullNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Your full name',
        icon: Icon(Icons.account_circle),
      ),
      enabled: !_inProgress,
      validator: validateName,
      onSaved: (value) => _fullName = value,
      keyboardType: TextInputType.text,
    );
  }

  Widget _sexSelect() {
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile(
            title: const Text('Male'),
            value: 'M',
            groupValue: sex,
            onChanged: (value) {
              setState(() {
                sex = value;
                print(sex);
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Female'),
            value: 'F',
            groupValue: sex,
            onChanged: (value) {
              setState(() {
                sex = value;
                print(sex);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return RaisedButton(
      child: Text('Submit'),
      shape: new StadiumBorder(),
      splashColor: Colors.tealAccent,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      onPressed: _submit,
    );
  }

  void _configureFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}
