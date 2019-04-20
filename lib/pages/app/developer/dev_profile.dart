import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/developer/developer_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nit_andhra/methods.dart' as methods;

class DevProfile extends StatefulWidget {
  final Developer developer;

  const DevProfile({Key key, this.developer}) : super(key: key);

  @override
  _DevProfileState createState() => _DevProfileState();
}

class _DevProfileState extends State<DevProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.developer.imageUrl,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          _buildContent(),
          Positioned(
            right: 16.0,
            top: 190.0,
            child: _buildLinks(),
          )
        ],
      ),
    );
  }

  Widget _buildLinks() {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () async {
            final url = widget.developer.facebookLink;
            if (await canLaunch(url)) {
              launch(url);
            } else {
              methods.showSnackbar(
                scaffoldState: Scaffold.of(context),
                msg: 'bad facebook url',
              );
            }
          },
          child: Image.asset(
            'assets/images/fb_icon.png',
            height: 40.0,
            width: 40.0,
          ),
        ),
        const SizedBox(width: 16.0),
        InkWell(
          onTap: () async {
            final url = widget.developer.githubLink;
            if (await canLaunch(url)) {
              launch(url);
            } else {
              methods.showSnackbar(
                scaffoldState: Scaffold.of(context),
                msg: 'bad github url',
              );
            }
          },
          child: Image.asset(
            'assets/images/github_icon.png',
            height: 40.0,
            width: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(),
          _buildInfo(),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.developer.firstName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0, // * _animation.value,
            ),
          ),
          Text(
            widget.developer.lastName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0, // * _animation.value,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            widget.developer.place,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 15.0, // * _animation.value,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 255.0, // * _animation.value,
            height: 1.0, //* _animation.value,
            color: Colors.white,
          ),
          Text(
            widget.developer.about,
            style: TextStyle(
              color: Colors.white,
              height: 1.2,
              fontSize: 14.0, // * _animation.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Hero(
      tag: widget.developer.facebookLink,
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, top: 32.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.white30)),
        child: CircleAvatar(
          backgroundImage:
              CachedNetworkImageProvider(widget.developer.imageUrl),
          radius: 55.0, //* _animation.value,
          backgroundColor: Colors.white30,
        ),
      ),
    );
  }
}
