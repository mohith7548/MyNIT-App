import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/profile/background_image_with_circular_avatar.dart';
import 'package:nit_andhra/pages/app/profile/edit_profile_page.dart';

const _iconFlex = 1;
const _detailFlex = 6;
const _topPadding = 24.0;
const _rightPadding = 16.0;
const _leftPadding = 16.0;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: false,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.create),
                tooltip: 'Edit Profile',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppState(
                          firebaseUser: appState.firebaseUser,
                          user: appState.user,
                          child: EditProfilePage(),
                        ),
                  ),
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Hero(
                tag: 'profile-pic',
                child: BackgroundImageWithCircularAvatar(appState.user.photoUrl),
              ),
              title: Text((appState.user.displayName == "") ? 'My Profile' : appState.user.displayName),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _BioSection(),
                _DateOfBirthSection(),
                _RegNo(),
                _RollNo(),
                _Email(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BioSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.only(top: _topPadding, right: _rightPadding, left: _leftPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: _iconFlex,
            child: Icon(
              Icons.info,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: _detailFlex,
            child: Text(
              'This is ${appState.user.fullName}. ${appState.user.bio}',
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOfBirthSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.only(top: _topPadding, right: _rightPadding, left: _leftPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _iconFlex,
            child: Icon(
              Icons.date_range,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: _detailFlex,
            child: Text(
              (appState.user.dateOfBirth == "") ? 'null' : appState.user.dateOfBirth,
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegNo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.only(top: _topPadding, right: _rightPadding, left: _leftPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _iconFlex,
            child: Icon(
              Icons.confirmation_number,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: _detailFlex,
            child: Text(
              appState.user.regNo.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RollNo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.only(top: _topPadding, right: _rightPadding, left: _leftPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _iconFlex,
            child: Icon(
              Icons.confirmation_number,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: _detailFlex,
            child: Text(
              appState.user.rollNo.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Container(
      padding: const EdgeInsets.only(top: _topPadding, right: _rightPadding, left: _leftPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _iconFlex,
            child: Icon(
              Icons.email,
              color: Colors.teal,
            ),
          ),
          Expanded(
            flex: _detailFlex,
            child: Text(
              appState.firebaseUser.email,
              textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
