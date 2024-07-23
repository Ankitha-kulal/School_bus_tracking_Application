import 'package:final_bus/AdminLoginPage.dart';
import 'package:final_bus/BusDriverPage.dart';
import 'package:final_bus/DriverLoginPage.dart';
import 'package:final_bus/login.dart';
import 'package:final_bus/onboarding_screen.dart';
import 'package:flutter/material.dart';

class Loginmenupage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
                 
                },
                child: Text('Back', style: TextStyle(fontSize: 16, color: Colors.blue)),
              ),
              SizedBox(height: 20),
              Text(
                "Let's Go",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'School Transport Management dashboard empower school admins and parents to keep children safe on the roads by constantly monitoring school vehicle’s moments in real-time.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Image.asset('assets/images/school_bus.png', height: 150, width: 150,
              alignment: Alignment.center,),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildGridItem(context, 'I am a Bus Driver', Colors.orange, DriverLoginPage()),
                   
                    _buildGridItem(context, 'I am a Parent-Student', Colors.red, LoginPage()),
                    _buildGridItem(context, 'I am a Bus Company', Colors.teal, AdminLoginPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}





class BusCompanyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus Company')),
      body: Center(child: Text('Bus Company Page')),
    );
  }
}
