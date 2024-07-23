import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _startingPointController = TextEditingController();
  final TextEditingController _destinationPointController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  void _editUser(String id) async {
    await usersCollection.doc(id).update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'studentName': _studentNameController.text,
      'busNumber': _busNumberController.text,
      'startingPoint': _startingPointController.text,
      'destinationPoint': _destinationPointController.text,
      'class': _classController.text,
      'parentName': _parentNameController.text,
      'contactNumber': _contactNumberController.text,
    });
    _clearControllers();
    Navigator.of(context).pop();
  }

  void _deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  void _showEditUserDialog(DocumentSnapshot user) {
    _firstNameController.text = user['firstName'] ?? '';
    _lastNameController.text = user['lastName'] ?? '';
    _studentNameController.text = user['studentName'] ?? '';
    _busNumberController.text = user['busNumber'] ?? '';
    _startingPointController.text = user['startingPoint'] ?? '';
    _destinationPointController.text = user['destinationPoint'] ?? '';
    _classController.text = user['class'] ?? '';
    _parentNameController.text = user['parentName'] ?? '';
    _contactNumberController.text = user['contactNumber'] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: _buildUserForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editUser(user.id);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(hintText: 'Enter first name'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(hintText: 'Enter last name'),
          ),
          TextField(
            controller: _studentNameController,
            decoration: InputDecoration(hintText: 'Enter student name'),
          ),
          TextField(
            controller: _busNumberController,
            decoration: InputDecoration(hintText: 'Enter bus number'),
          ),
          TextField(
            controller: _startingPointController,
            decoration: InputDecoration(hintText: 'Enter starting point'),
          ),
          TextField(
            controller: _destinationPointController,
            decoration: InputDecoration(hintText: 'Enter destination point'),
          ),
          TextField(
            controller: _classController,
            decoration: InputDecoration(hintText: 'Enter class'),
          ),
          TextField(
            controller: _parentNameController,
            decoration: InputDecoration(hintText: 'Enter parent name'),
          ),
          TextField(
            controller: _contactNumberController,
            decoration: InputDecoration(hintText: 'Enter contact number'),
          ),
        ],
      ),
    );
  }

  void _clearControllers() {
    _firstNameController.clear();
    _lastNameController.clear();
    _studentNameController.clear();
    _busNumberController.clear();
    _startingPointController.clear();
    _destinationPointController.clear();
    _classController.clear();
    _parentNameController.clear();
    _contactNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text('${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${userData['email'] ?? 'N/A'}'),
                      Text('Student Name: ${userData['studentName'] ?? 'N/A'}'),
                      Text('Bus Number: ${userData['busNumber'] ?? 'N/A'}'),
                      Text('Class: ${userData['class'] ?? 'N/A'}'),
                      Text('Parent Name: ${userData['parentName'] ?? 'N/A'}'),
                      Text('Contact Number: ${userData['contactNumber'] ?? 'N/A'}'),
                      Text('Starting Point: ${userData['startingPoint'] ?? 'N/A'}'),
                      Text('Destination Point: ${userData['destinationPoint'] ?? 'N/A'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditUserDialog(user);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteUser(user.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
