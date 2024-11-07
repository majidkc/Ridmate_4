// In CoPassengerListScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridemate_4/screens/CoPassengerDetail_screen.dart';


class CoPassengerListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> coPassengers; 

  const CoPassengerListScreen({Key? key, required this.coPassengers}) : super(key: key);

  @override
  _CoPassengerListScreenState createState() => _CoPassengerListScreenState();
}

class _CoPassengerListScreenState extends State<CoPassengerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Co-Passengers'), 
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: widget.coPassengers.length, 
        itemBuilder: (context, index) {
          final coPassenger = widget.coPassengers[index];
          return ListTile(
            leading: Icon(
              getModeIcon(coPassenger['mode']),
              color: Colors.purple, // Or a color that matches your app theme
            ),
            title: Text("Name: ${coPassenger['userName']}"),
            subtitle: Text(
                'Mode: ${coPassenger['mode']}, ${coPassenger['startLocation']} to ${coPassenger['endLocation']}'
            ),
            // Consider adding a button to "Connect" with the co-passenger
            // Add an onTap listener to handle connecting with the co-passenger
            onTap: () {
              // Get the userId of the co-passenger
              final userId = coPassenger['userId'];
              // Pass the userId to CoPassengerDetailsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoPassengerDetailsScreen(userId: userId), 
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to get the icon based on the mode
  IconData getModeIcon(String mode) {
    switch (mode) {
      case 'Car':
        return Icons.directions_car;
      case 'Bike':
        return Icons.directions_bike;
      case 'Auto':
        return Icons.directions_transit;
      default:
        return Icons.question_mark; // Default icon if mode is unknown
    }
  }
}