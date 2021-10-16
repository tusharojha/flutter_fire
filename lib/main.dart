import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Storage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imageURL = '';

  Future<void> uploadImage(XFile file) async {
    var ref = FirebaseStorage.instance.ref('files/${file.name}');

    var task = await ref.putFile(File(file.path));
    var fileURL = (await task.ref.getDownloadURL());
    setState(() {
      imageURL = fileURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: imageURL.isEmpty ? null : () async {
              var id = await ImageDownloader.downloadImage(imageURL);
              if(id != null) {
                print("Image is saved! $id");
              }
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var file = await ImagePicker().pickImage(source: ImageSource.gallery);
          uploadImage(file);
        },
        child: Icon(Icons.upload),
      ),
      body: Center(
        child: imageURL.isEmpty
            ? Text('No image is uploaded.')
            : Image.network(imageURL),
      ),
    );
  }
}
