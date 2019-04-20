import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/saved_images/open_image_page.dart';
import 'package:path_provider/path_provider.dart';

class SavedImagesPage extends StatefulWidget {
  @override
  _SavedImagesPageState createState() => _SavedImagesPageState();
}

class _SavedImagesPageState extends State<SavedImagesPage> {
  var _isLoaded = 'NOT-OKAY';
  List<File> imageFiles = new List<File>();

  @override
  void initState() {
    super.initState();
    _getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Saved Images')),
      body: (_isLoaded == 'OKAY')
          ? Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: _buildImageTiles(),
              ),
            )
          : ((_isLoaded == 'NOT-OKAY')
              ? Center(child: CircularProgressIndicator())
              : Center(child: Text('No Images Found!'))),
    );
  }

  void _getAllImages() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/images';
      final fileList = Directory(path).listSync().toList();
      fileList.forEach((e) => imageFiles.add(new File(e.path)));
      setState(() {
        _isLoaded = 'OKAY';
      });
    } catch (error) {
      print(error.toString());
      setState(() {
        _isLoaded = 'FAIL';
      });
    }
  }

  List<Widget> _buildImageTiles() {
    List<Container> imageTiles = new List<Container>.generate(
      imageFiles.length,
      (int index) => Container(
            child: Hero(
              tag: '${imageFiles[index].path}',
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImagePreview(file: imageFiles[index]),
                    ),
                  );
                },
                child: Image.file(imageFiles[index]),
              ),
            ),
          ),
    );
    return imageTiles;
  }
}
