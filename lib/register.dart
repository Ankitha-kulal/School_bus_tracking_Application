import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'HomePage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _busNumberController = TextEditingController();
  final _startingPointController = TextEditingController();
  final _destinationPointController = TextEditingController();
  final _classController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _contactNumberController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final studentName = _studentNameController.text;
      final busNumber = _busNumberController.text;

      // Parse latitude and longitude from the text fields
      GeoPoint? startingPoint = _parseGeoPoint(_startingPointController.text);
      GeoPoint? destinationPoint = _parseGeoPoint(_destinationPointController.text);

      final studentClass = _classController.text;
      final parentName = _parentNameController.text;
      final contactNumber = _contactNumberController.text;

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'studentName': studentName,
          'busNumber': busNumber,
          'startingPoint': startingPoint,
          'destinationPoint': destinationPoint,
          'class': studentClass,
          'parentName': parentName,
          'contactNumber': contactNumber,
          'fcmToken': fcmToken,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(busNumber: busNumber)),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            _passwordError = 'The password provided is too weak.';
            _emailError = null;
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            _emailError = 'The account already exists for that email.';
            _passwordError = null;
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  GeoPoint? _parseGeoPoint(String text) {
    if (text.isEmpty) return null;

    try {
      final parts = text.split(',');
      if (parts.length != 2) throw FormatException('Invalid format');
      
      final latitude = double.parse(parts[0].trim());
      final longitude = double.parse(parts[1].trim());
      
      return GeoPoint(latitude, longitude);
    } catch (e) {
      // Handle parsing errors
      print('Error parsing GeoPoint: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/image1.png",
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    "Student Registration",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _passwordError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                  TextFormField(
                    controller: _studentNameController,
                    decoration: InputDecoration(
                      labelText: 'Student Name',
                    ),
                  ),
                  TextFormField(
                    controller: _busNumberController,
                    decoration: InputDecoration(
                      labelText: 'Bus Number',
                    ),
                  ),
                  TextFormField(
                    controller: _startingPointController,
                    decoration: InputDecoration(
                      labelText: 'Starting Point (lat,lng)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter starting point';
                      }
                      if (!_isValidGeoPoint(value)) {
                        return 'Invalid format, should be "lat,lng"';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _destinationPointController,
                    decoration: InputDecoration(
                      labelText: 'Destination Point (lat,lng)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter destination point';
                      }
                      if (!_isValidGeoPoint(value)) {
                        return 'Invalid format, should be "lat,lng"';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _classController,
                    decoration: InputDecoration(
                      labelText: 'Class',
                    ),
                  ),
                  TextFormField(
                    controller: _parentNameController,
                    decoration: InputDecoration(
                      labelText: 'Parent Name',
                    ),
                  ),
                  TextFormField(
                    controller: _contactNumberController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidGeoPoint(String text) {
    final parts = text.split(',');
    if (parts.length != 2) return false;
    
    try {
      double.parse(parts[0].trim());
      double.parse(parts[1].trim());
      return true;
    } catch (e) {
      return false;
    }
  }
}
