import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/CoPassengerDetail_screen.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({Key? key}) : super(key: key);

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  List<Map<String, dynamic>> requestData = [];
  List<String> userData = [];

  @override
  void initState() {
    super.initState();
    _updateRideRequestStatus();
  }

  // Update ride request status and show an alert message
  Future<void> _updateRideRequestStatus() async {
    try {
      await _firestore
          .collection('rideRequests')
          .where('toUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'pending')
          .get()
          .then((value) {
            value.docs.forEach((element) {
              requestData.add(element.data());
            });
          });

      requestData.forEach((element) {
        _firestore.collection("users").doc(element['fromUserId']).get().then(
          (value) {
            setState(() {
              userData.add(value.data()!['name'] ?? 'Unknown');
            });
          },
        );
      });

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error updating ride request status: $error');
    }
  }

  // Show an alert dialog with a custom message
  void _showStatusAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: (_isLoading || requestData.isEmpty || userData.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passenger Requests',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(
                            'From: ${userData[index]}',
                            style: TextStyle(color: Colors.amber),
                          ),
                          subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                                  (requestData[index]['timestamp'] as Timestamp)
                                      .millisecondsSinceEpoch)
                              .toString()),
                          children: [
                            _buildActionButtons(index),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemCount: requestData.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to CoPassengerDetailsScreen with the userId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoPassengerDetailsScreen(
                  userId: requestData[index]['fromUserId'],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('Accept'),
        ),
        ElevatedButton(
          onPressed: () => _updateRideRequestStatus(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('Reject'),
        ),
      ],
    );
  }
}
