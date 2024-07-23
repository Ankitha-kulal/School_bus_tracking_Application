import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageBusesPage extends StatefulWidget {
  @override
  _ManageBusesPageState createState() => _ManageBusesPageState();
}

class _ManageBusesPageState extends State<ManageBusesPage> {
  final CollectionReference busesCollection =
      FirebaseFirestore.instance.collection('buses');

  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _busRouteController = TextEditingController();

  void _addBus() async {
    if (_busNameController.text.isNotEmpty &&
        _busNumberController.text.isNotEmpty &&
        _busRouteController.text.isNotEmpty) {
      await busesCollection.add({
        'name': _busNameController.text,
        'number': _busNumberController.text,
        'route': _busRouteController.text,
      });
      _busNameController.clear();
      _busNumberController.clear();
      _busRouteController.clear();
      Navigator.of(context).pop();
    }
  }

  void _editBus(String id) async {
    await busesCollection.doc(id).update({
      'name': _busNameController.text,
      'number': _busNumberController.text,
      'route': _busRouteController.text,
    });
    _busNameController.clear();
    _busNumberController.clear();
    _busRouteController.clear();
    Navigator.of(context).pop();
  }

  void _deleteBus(String id) async {
    await busesCollection.doc(id).delete();
  }

  void _showAddBusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _busNameController,
                decoration: InputDecoration(hintText: 'Enter bus name'),
              ),
              TextField(
                controller: _busNumberController,
                decoration: InputDecoration(hintText: 'Enter bus number'),
              ),
              TextField(
                controller: _busRouteController,
                decoration: InputDecoration(hintText: 'Enter bus route'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _addBus,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBusDialog(DocumentSnapshot bus) {
    _busNameController.text = bus['name'];
    _busNumberController.text = bus['number'];
    _busRouteController.text = bus['route'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _busNameController,
                decoration: InputDecoration(hintText: 'Enter bus name'),
              ),
              TextField(
                controller: _busNumberController,
                decoration: InputDecoration(hintText: 'Enter bus number'),
              ),
              TextField(
                controller: _busRouteController,
                decoration: InputDecoration(hintText: 'Enter bus route'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editBus(bus.id);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Buses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: busesCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final buses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(bus['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Number: ${bus['number']}'),
                      Text('Route: ${bus['route']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditBusDialog(bus);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteBus(bus.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBusDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
