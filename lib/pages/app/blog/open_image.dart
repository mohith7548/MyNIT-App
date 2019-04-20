import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nit_andhra/StylesAndColors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class OpenImage extends StatefulWidget {
  final DocumentSnapshot document;

  OpenImage({Key key, @required this.document}) : super(key: key);

  @override
  _OpenImageState createState() => _OpenImageState();
}

class _OpenImageState extends State<OpenImage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.black54,
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Hero(
                  tag: '${widget.document.reference.path}',
                  child: new GestureDetector(
                    onVerticalDragEnd: _popThis,
                    child: CachedNetworkImage(
                      imageUrl: widget.document['postImageUrl'],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        print('Save To Device!');
                        _saveToDevice();
                      },
                      textColor: Colors.white,
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.file_download),
                          const SizedBox(width: 8.0),
                          Text('Save to device', style: primaryText),
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        print('Share button Tapped!');
                        _shareImage();
                      },
                      textColor: Colors.white,
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.share),
                          const SizedBox(width: 8.0),
                          Text('Share', style: primaryText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        (_isLoading)
            ? SimpleDialog(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : Container(),
      ],
    );
  }

  void _popThis(DragEndDetails details) {
    if (details.primaryVelocity != 0.0) {
      Navigator.pop(context);
    }
  }

  void _saveToDevice() async {
    setState(() {
      _isLoading = true;
    });
    http.readBytes(widget.document['postImageUrl']).then((Uint8List buffer) {
      writeData(buffer.toList()).whenComplete(() {
        print('Save Job Done!');
        setState(() {
          _isLoading = false;
        });
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text('Image Saved!'),
        ));
      });
    }).catchError((error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/images';
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/${widget.document.documentID}.jpg');
  }

  Future<String> readData() async {
    // TODO: change to make it read an image file
    try {
      final file = await localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(List<int> bytes) async {
    final file = await localFile;
    file.writeAsBytesSync(bytes);
    return file;
//    return file.writeAsStringSync('$data');
  }

  _shareImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      http
          .readBytes(widget.document['postImageUrl'])
          .then((Uint8List list) async {
        final tempDir = await getTemporaryDirectory();
        final file = await new File('${tempDir.path}/image.jpg').create();
        file.writeAsBytesSync(list);
        final channel = const MethodChannel('channel:me.albie.share/share');
        channel.invokeMethod('shareFile', 'image.jpg');
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }
}
