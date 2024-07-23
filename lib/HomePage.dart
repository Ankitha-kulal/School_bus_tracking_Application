import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_bus/StudentListPage.dart';
import 'package:flutter/material.dart';
import 'MapPage.dart'; // Ensure this import is correct

class HomePage extends StatefulWidget {
  final String busNumber;

  HomePage({required this.busNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus ${widget.busNumber}'),
      ),
      body: BusPage(busNumber: widget.busNumber),
    );
  }
}

class BusPage extends StatefulWidget {
  final String busNumber;

  BusPage({required this.busNumber});

  @override
  _BusPageState createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  void _fetchUserId() async {
    // Fetch userId for the busNumber
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('busNumber', isEqualTo: widget.busNumber)
        .limit(1) // Assuming each busNumber corresponds to one user
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      setState(() {
        userId = userSnapshot.docs.first.id; // Assuming userId is the document ID
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('buses').doc(widget.busNumber).snapshots(),
      builder: (context, busSnapshot) {
        if (!busSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var busData = busSnapshot.data;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('busNumber', isEqualTo: widget.busNumber)
              .snapshots(),
          builder: (context, studentSnapshot) {
            if (!studentSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var studentDocs = studentSnapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Text('Welcome to', style: TextStyle(fontSize: 24)),
                  Text('Bus ${widget.busNumber}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text('Manage bus routes', style: TextStyle(fontSize: 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.directions_bus, size: 40),
                      Icon(Icons.map, size: 40),
                      Icon(Icons.school, size: 40),
                      Icon(Icons.calendar_today, size: 40),
                    ],
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.directions_bus),
                      title: Text('Track Bus Location'),
                      subtitle: Text('Monitor bus progress'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (userId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapPage(
                                  busNumber: widget.busNumber,
                                  userId: userId!,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where userId is not yet available
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User ID is not available')),
                            );
                          }
                        },
                        child: Text('Track now'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text('Bus Schedule Today'),
                      subtitle: Text('Bus ${widget.busNumber} Morning route'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Implement your schedule viewing logic here
                        },
                        child: Text('View'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Student List'),
                      subtitle: Text('View list of students'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentListPage(busNumber: widget.busNumber),
                            ),
                          );
                        },
                        child: Text('View'),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.directions),
                      title: Text('Manage Routes'),
                      subtitle: Text('Add or modify bus routes'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageRoutesPage(busNumber: widget.busNumber),
                            ),
                          );
                        },
                        child: Text('Manage'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}



class ManageRoutesPage extends StatelessWidget {
  final String busNumber;

  ManageRoutesPage({required this.busNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Routes for Bus $busNumber'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('buses').doc(busNumber).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var busData = snapshot.data!.data() as Map<String, dynamic>?;

          if (busData == null) {
            return Center(child: Text('No route data available'));
          }

          var routeData = busData['routes'] as List<dynamic>? ?? [];

          return ListView.builder(
            itemCount: routeData.length,
            itemBuilder: (context, index) {
              var route = routeData[index];
              return ListTile(
                title: Text('Route ${index + 1}'),
                subtitle: Text(route.toString()),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement your route editing logic here
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
