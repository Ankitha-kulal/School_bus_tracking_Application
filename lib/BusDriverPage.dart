import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'consts.dart';  // Import your consts.dart file

class DriverPage extends StatefulWidget {
  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Location _location = Location();

  LocationData? _currentLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
      _updateDriverLocation();
    });
  }

  void _updateDriverLocation() async {
    User? user = _auth.currentUser;
    if (user != null && _currentLocation != null) {
      await _firestore.collection('drivers').doc(user.uid).update({
        'location': GeoPoint(_currentLocation!.latitude!, _currentLocation!.longitude!),
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _moveToLocation(LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!));
    }
  }

  void _moveToLocation(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
  }

  Widget _buildDriverInfo(Map<String, dynamic> driverData) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: ${driverData['firstName'] ?? 'Unknown'}'),
            Text('Bus Number: ${driverData['busNumber'] ?? 'Unknown'}'),
            Text('Current Latitude: ${driverData['location'].latitude}'),
            Text('Current Longitude: ${driverData['location'].longitude}'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap(LatLng driverLocation) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: driverLocation,
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: MarkerId('driverLocation'),
          position: driverLocation,
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Driver Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('drivers').doc(_auth.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          var driverData = snapshot.data!.data() as Map<String, dynamic>;
          LatLng driverLocation = LatLng(
            driverData['location'].latitude,
            driverData['location'].longitude,
          );

          return Column(
            children: [
              _buildDriverInfo(driverData),
              Expanded(child: _buildGoogleMap(driverLocation)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Share location functionality (e.g., sending updates to parents)
        },
        child: Icon(Icons.share_location),
      ),
    );
  }
}
