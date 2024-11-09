


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ridemate_4/screens/CoPassengerDetail_screen.dart';

class CoPassengerListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> coPassengers;

  const CoPassengerListScreen({Key? key, required this.coPassengers}) : super(key: key);

  @override
  _CoPassengerListScreenState createState() => _CoPassengerListScreenState();
}

class _CoPassengerListScreenState extends State<CoPassengerListScreen> {
  late String currentUserId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the currently logged-in user's details
    final filteredCoPassengers = widget.coPassengers
        .where((coPassenger) => coPassenger['userId'] != currentUserId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Co-Passengers'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: filteredCoPassengers.length,
        itemBuilder: (context, index) {
          final coPassenger = filteredCoPassengers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: Icon(
                getModeIcon(coPassenger['mode']),
                color: Colors.purple,
                size: 40,
              ),
              title: Text(
                "Name: ${coPassenger['userName']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'Mode: ${coPassenger['mode']}, ${coPassenger['startLocation']} to ${coPassenger['endLocation']}',
                  style: TextStyle(color: Colors.grey[700])),
              trailing: ElevatedButton(
                onPressed: () async {
                  try {
                    // Send a ride request and save it to Firestore
                    await _firestore.collection('rideRequests').add({
                      'fromUserId': currentUserId,
                      'toUserId': coPassenger['userId'],
                      'status': 'pending', // Initially pending
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request sent to ${coPassenger['userName']}!')),
                    );
                  } catch (e) {
                    // Handle any errors that occur during the request
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send request: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Send Request',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {
                // Navigate to the CoPassengerDetailsScreen with userId
                final userId = coPassenger['userId'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoPassengerDetailsScreen(userId: userId),
                  ),
                );
              },
            ),
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
        return Icons.question_mark;
    }
  }
}