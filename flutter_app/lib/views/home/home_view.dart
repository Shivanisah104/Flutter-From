
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  DateTime _dob;
  String _email;
  String _phone;
  String _cvFilePath;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }
  Widget _buildLastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your last name';
        }
        return null;
      },
      onSaved: (value) {
        _lastName = value;
      },
    );
  }

  Widget _buildDOBField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: IgnorePointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (_dob == null) {
              return 'Please select your date of birth';
            }
            return null;
          },
          controller: TextEditingController(
            text: _dob == null ? '' : _dateFormat.format(_dob),
          ),
          onSaved: (value) {
            _dob = _dateFormat.parse(value);
          },
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (value) {
        _email = value;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
      onSaved: (value) {
        _phone = value;
      },
    );
  }



  Widget _buildFirstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your first name';
        }
        return null;
      },
      onSaved: (value) {
        _firstName = value;
      },
    );
  }

  Widget _buildCVField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Upload CV'),
      readOnly: true,
      onTap: () async {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc'],
        );
        if (result != null) {
          setState(() {
            _cvFilePath = result.files.single.path;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please upload your CV';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // TODO: Submit the form data to the server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFirstNameField(),
              SizedBox(height: 16.0),
              _buildCVField(),
              SizedBox(height: 16.0),
              RaisedButton(
                child: Text('Submit'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}