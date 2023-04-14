import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  File? _cvFile;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _cvFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _uploadFile() async {
    if (_cvFile != null) {
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      final uploadTask = reference.putFile(_cvFile!);
      final snapshot = await uploadTask.whenComplete(() => print('File uploaded successfully.'));
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('File download URL: $downloadUrl');
    } else {
      print('Please select a file to upload.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
