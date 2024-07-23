import 'package:final_bus/AdminLoginPage.dart';

import 'package:final_bus/ManageBusesPage.dart';
import 'package:final_bus/ManageUsersPage.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("School Admin"),
              accountEmail: Text("admin@school.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Manage Schools'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_bus),
              title: Text('Manage Buses'),
              onTap: () {
                        print("Manage Buses tapped");
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ManageBusesPage()));
                      },

            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Manage Users'),
              onTap: () {
                Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context) => ManageUsersPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => AdminLoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, School Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromRGBO(221, 38, 38, 0.481),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: School Admin', style: TextStyle(fontSize: 18)),
                    Text('Email: admin@school.com', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDashboardCard(Icons.school, 'Manage Schools'),
                  _buildDashboardCard(Icons.directions_bus, 'Manage Buses'),
                  _buildDashboardCard(Icons.people, 'Manage Users'),
                  _buildDashboardCard(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Handle card tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Color.fromRGBO(221, 38, 38, 0.481)),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}