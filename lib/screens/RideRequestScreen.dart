import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/CoPassengerDetail_screen.dart';

class RideRequestScreen extends StatefulWidget {
  final String fromUserId; // The passenger's user ID
  final String toUserId; // The co-passenger's user ID

  const RideRequestScreen(
      {Key? key, required this.fromUserId, required this.toUserId})
      : super(key: key);

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late DocumentSnapshot<Map<String, dynamic>> fromUserData;
  late DocumentSnapshot<Map<String, dynamic>> toUserData;

  // Initial state to check for loading
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch user details from Firestore
    _fetchUserDetails();
  }

  // Fetch user details
  Future<void> _fetchUserDetails() async {
    try {
      fromUserData =
          await _firestore.collection('users').doc(widget.fromUserId).get();
      toUserData =
          await _firestore.collection('users').doc(widget.toUserId).get();
      setState(() {
        _isLoading = false; // Set loading to false after fetching
      });
    } catch (error) {
      print('Error fetching user details: $error');
      // Handle error (e.g., show an error message)
      // You might want to:
      //   * Display a user-friendly error message
      //   * Try to fetch the data again after a delay
      //   * Use a default name (like "Unknown")
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Request'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display passenger details
                  Text(
                    'From: ${fromUserData.exists && fromUserData.data()!.containsKey('name') ? fromUserData['name'] : 'Unknown'}', // Access 'name'
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Display co-passenger details
                  Text(
                    'To: ${toUserData.exists && toUserData.data()!.containsKey('name') ? toUserData['name'] : 'Unknown'}', // Access 'name'
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 32),
                  // Accept button
                  ElevatedButton(
                    onPressed: () async {
                      // Update request status in Firestore
                      await _firestore
                          .collection('rideRequests')
                          .where('fromUserId', isEqualTo: widget.fromUserId)
                          .where('toUserId', isEqualTo: widget.toUserId)
                          .get()
                          .then((snapshot) {
                        if (!snapshot.docs.isEmpty) {
                          final docId = snapshot.docs[0].id;
                          _firestore
                              .collection('rideRequests')
                              .doc(docId)
                              .update({
                            'status': 'accepted',
                          });
                        }
                      });
                      // Navigate to the chat screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoPassengerDetailsScreen(
                              userId: widget.fromUserId),
                        ),
                      );
                    },
                    child: Text('Accept'),
                  ),
                  SizedBox(height: 16),

                  // Reject button
                  ElevatedButton(
                    onPressed: () async {
                      // Update request status in Firestore
                      await _firestore
                          .collection('rideRequests')
                          .where('fromUserId', isEqualTo: widget.fromUserId)
                          .where('toUserId', isEqualTo: widget.toUserId)
                          .get()
                          .then((snapshot) {
                        if (!snapshot.docs.isEmpty) {
                          final docId = snapshot.docs[0].id;
                          _firestore
                              .collection('rideRequests')
                              .doc(docId)
                              .update({
                            'status': 'rejected',
                          });
                        }
                      });
                      // You might want to add a navigation to the home screen or another relevant screen
                    },
                    child: Text('Reject'),
                  ),
                ],
              ),
            ),
    );
  }
}