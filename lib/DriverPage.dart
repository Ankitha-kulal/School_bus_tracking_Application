import 'package:final_bus/BusDriverPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusDriverPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Driver Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, ${user?.email}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement functionality for tracking buses or other features
              },
              child: Text('Track Buses'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => (DriverPage())));
                      }, // Navigate back to login page
              
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
