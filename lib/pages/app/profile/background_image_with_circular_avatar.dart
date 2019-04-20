import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nit_andhra/pages/app/app_state.dart';

class BackgroundImageWithCircularAvatar extends StatelessWidget {
  final String _image;

  BackgroundImageWithCircularAvatar(this._image);

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final bool _hasImage = (_image == '') ? false : true;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (_hasImage)
                  ? CachedNetworkImageProvider(_image)
                  : AssetImage('assets/images/${appState.user.sex}-user.png'),
              //NetworkImage(_image),//ExactAssetImage(_image),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
        ),
        Center(
          child: CircleAvatar(
            backgroundImage: (_hasImage)
                ? CachedNetworkImageProvider(_image)
                : AssetImage('assets/images/${appState.user.sex}-user.png'),
            //NetworkImage(_image),//AssetImage(_image),
            radius: 80.0,
          ),
        ),
      ],
    );
  }
}