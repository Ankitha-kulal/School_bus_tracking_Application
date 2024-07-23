import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  final String busNumber;
  final String userId;

  MapPage({required this.busNumber, required this.userId});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleMapController? _mapController;

  LatLng? _busLocation;
  LatLng? _startingPoint;
  LatLng? _destinationPoint;
  final Set<Marker> _markers = {};

  StreamSubscription? _busLocationSubscription;
  StreamSubscription? _userLocationSubscription;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _busLocationSubscription?.cancel();
    _userLocationSubscription?.cancel();
    super.dispose();
  }

  void _fetchData() {
    // Fetch bus location
    _busLocationSubscription = _firestore
        .collection('drivers')
        .where('busNumber', isEqualTo: widget.busNumber)
        .snapshots()
        .listen((snapshot) {
      if (!mounted) return; // Check if the widget is still mounted

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('location')) {
          var location = data['location'] as GeoPoint?;
          if (location != null) {
            setState(() {
              _busLocation = LatLng(location.latitude, location.longitude);
              print('Bus Location: $_busLocation'); // Print bus location

              _markers.removeWhere((marker) => marker.markerId.value == 'busLocation');
              _markers.add(
                Marker(
                  markerId: MarkerId('busLocation'),
                  position: _busLocation!,
                  infoWindow: InfoWindow(title: 'Bus Location'),
                ),
              );
              if (_mapController != null && _busLocation != null) {
                _moveToLocation(_busLocation!);
              }
            });
          } else {
            print('Location field is null in driver document');
          }
        } else {
          print('No location field in driver document');
        }
      } else {
        print('No driver document found for busNumber ${widget.busNumber}');
      }
    }, onError: (error) {
      print('Error fetching bus location: $error');
    });

    // Fetch user-specific starting and destination points
    _userLocationSubscription = _firestore.collection('users').doc(widget.userId).snapshots().listen((snapshot) {
      if (!mounted) return; // Check if the widget is still mounted

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          var start = data['startingPoint'] as GeoPoint?;
          var end = data['destinationPoint'] as GeoPoint?;

          if (start != null) {
            _startingPoint = LatLng(start.latitude, start.longitude);
          } else {
            print('Starting Point is null');
          }

          if (end != null) {
            _destinationPoint = LatLng(end.latitude, end.longitude);
          } else {
            print('Destination Point is null');
          }

          setState(() {
            print('Starting Point: $_startingPoint'); // Print starting point
            print('Destination Point: $_destinationPoint'); // Print destination point

            _markers.removeWhere((marker) => marker.markerId.value == 'startingPoint' || marker.markerId.value == 'destinationPoint');
            if (_startingPoint != null) {
              _markers.add(
                Marker(
                  markerId: MarkerId('startingPoint'),
                  position: _startingPoint!,
                  infoWindow: InfoWindow(title: 'Starting Point'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              );
            }
            if (_destinationPoint != null) {
              _markers.add(
                Marker(
                  markerId: MarkerId('destinationPoint'),
                  position: _destinationPoint!,
                  infoWindow: InfoWindow(title: 'Destination Point'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              );
            }

            if (_mapController != null) {
              LatLng targetPosition = _busLocation ?? _startingPoint ?? _destinationPoint ?? LatLng(0, 0);
              _moveToLocation(targetPosition);
            }
          });
        } else {
          print('No data found in user document');
        }
      } else {
        print('User document does not exist for userId ${widget.userId}');
      }
    }, onError: (error) {
      print('Error fetching user data: $error');
    });
  }

  void _moveToLocation(LatLng location) {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(location, 15));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_busLocation != null) {
      _moveToLocation(_busLocation!);
    } else if (_startingPoint != null) {
      _moveToLocation(_startingPoint!);
    } else if (_destinationPoint != null) {
      _moveToLocation(_destinationPoint!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Bus ${widget.busNumber}'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Default position if location is null
          zoom: 15,
        ),
        markers: _markers,
      ),
    );
  }
}
