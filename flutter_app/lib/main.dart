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
      title: 'Sign in page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Sign in page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();
  File? _cvFile;
  final _dobController = TextEditingController();
  final picker = ImagePicker();

  Future<void> _pickCVFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _cvFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }
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
  void dispose() {
    _firstController.dispose();
    _lastController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'first name'),
                controller: _firstController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter first name.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'last name'),
                controller: _lastController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter last name.';
                  }
                  return null;
                },
              ),
               TextFormField(
               decoration: InputDecoration(labelText: 'email'),
               controller: _emailController,
               validator: (value) {
                  if (value?.isEmpty ?? true) {
                     return 'Please enter email.';
                  }
                  // Regex for email validation
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value!)) {
                     return 'Please enter a valid email.';
                  }
                  return null;
               },
               ),
               TextFormField(
               decoration: InputDecoration(labelText: 'Phone Number'),
               controller: _phoneController,
               keyboardType: TextInputType.phone,
               validator: (value) {
                  if (value?.isEmpty ?? true) {
                     return 'Please enter phone number.';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                     return 'Please enter a valid 10-digit phone number.';
                  }
                  return null;
               },
               ),
              SizedBox(height: 16),
               TextFormField(
               decoration: InputDecoration(labelText: 'Date of Birth'),
               controller: _dobController,
               validator: (value) {
                  if (value?.isEmpty ?? true) {
                     return 'Please enter your date of birth.';
                  }
                  return null;
               },
               onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                     context: context,
                     initialDate: DateTime.now(),
                     firstDate: DateTime(1900),
                     lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                     final formattedDate =
                        '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                     setState(() {
                     _dobController.text = formattedDate;
                     });
                  }
               },
               ),

            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select CV'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload CV'),
            ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Success!'),
                        content: Text('Form submitted successfully, let me verify your details'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill out all fields.'),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

