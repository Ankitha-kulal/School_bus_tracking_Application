import 'package:flutter/material.dart';

import 'adminhomedraweritems/Item1Page.dart';
import 'adminhomedraweritems/Item2Page.dart';
import 'adminhomedraweritems/Item3Page.dart';
import 'adminhomedraweritems/Item4Page.dart';

class Adminhomepage extends StatefulWidget {
  @override
  _AdminhomepageState createState() => _AdminhomepageState();
}

class _AdminhomepageState extends State<Adminhomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(245, 241, 201, 177),
      appBar: AppBar(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _showProfile(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                  
                  
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50, // Set the height to the AppBar's height
                  child: Row(
                   
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 28, 
                        // Adjust the size of the icon
                      ),
                      SizedBox(width: 10),Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),

            ListTile(
              title: const Text('Bus Management'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Item1Page()));
              },
            ),
            ListTile(
              title: const Text('Student Management'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Item2Page()));
              },
            ),
            ListTile(
              title: const Text('Driver Management'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Item3Page()));
              },
            ),
            ListTile(
              title: const Text('Route Management'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Item4Page()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10), // Add margin for spacing
              decoration: BoxDecoration(
                color: Color.fromRGBO(221, 38, 38, 0.263),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(221, 38, 38, 0.263),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Number of Buses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
           
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(221, 38, 38, 0.263),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Number of Students',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(221, 38, 38, 0.263),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Number of Routes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(221, 38, 38, 0.263),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  'Number of Staffs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile'),
          content: Text('This is where you can view your profile details.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
