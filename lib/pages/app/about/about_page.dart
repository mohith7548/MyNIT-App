import 'package:flutter/material.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/developer/developer_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  ScrollController _scrollController;
  AppState appState;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appState = AppState.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('About MyNiT'),
              background: Image.asset(
                'assets/images/college.jpg',
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _infoCard(),
                _whyMyNitCard(),
                _madeBecause(),
                _gotoDevelopers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gotoDevelopers() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RaisedButton(
        onPressed: () {
          _sendTo(DeveloperPage());
        },
        shape: StadiumBorder(),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Know about the Developers',
          style: textStyle.copyWith(color: Theme.of(context).accentColor),
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _madeBecause() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Made because...',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6.0),
              _bulletPoint(
                  'Often students need to spend time with the notice board, remember things and make note. It is made easy with “MyNiT”.'),
              const SizedBox(height: 8.0),
              _bulletPoint(
                  'Students need to stand in Queue to get the required book. They don’t know how many books are available and has to spend a lot time, searching in Library. This is Overcome with the Digital Library Section in “MyNiT”.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whyMyNitCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Why MyNiT?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6.0),
              _bulletPoint('To help Students connect to each other'),
              _bulletPoint(
                  'To save trees, by decreasing the Paper used for Notice board'),
              _bulletPoint(
                  'To update student about the present things going in College as quick as possible.'),
              _bulletPoint('To help Student with Digital Library.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'MyNiT is an Android App designed specifically for students of “NIT A.P”. It helps students to connect with everyone in the college from anywhere on the internet. Presently, it targets only Android users. It is still in Alpha Version.',
            style: TextStyle(height: 1.2, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _bulletPoint(String msg) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.chevron_right),
      title: Text(
        msg,
        style: textStyle.copyWith(height: 1.1),
      ),
    );
  }

  void _sendTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppState(
          firebaseUser: appState.firebaseUser,
          user: appState.user,
          isDarkThemeEnabled: appState.isDarkThemeEnabled,
          changeTheme: appState.changeTheme,
          child: page,
        ),
      ),
    );
  }
}
