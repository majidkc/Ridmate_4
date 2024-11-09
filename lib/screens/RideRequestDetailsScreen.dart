import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/CoPassengerDetail_screen.dart';

class RideRequestScreen extends StatefulWidget {
  // The co-passenger who received the ride request

  const RideRequestScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  List<Map<String, dynamic>>requestData = [];

  @override
  void initState() {
    print(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
    // _fetchUserNames();
    _updateRideRequestStatus();
  }



  // Update ride request status and show an alert message
  Future<void> _updateRideRequestStatus() async {
    try {
      await _firestore
          .collection('rideRequests')
          .where('toUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get().then((value) => value.docs.forEach((element) {
            setState(() {
              requestData.add(element.data());
            });
          },),);

      // Debug: Log the number of matching ride requests
      // print('Matching ride requests: ${rideRequestSnapshot.docs.length}');

      // if (rideRequestSnapshot.docs.isNotEmpty) {
      //   final rideRequestDoc = rideRequestSnapshot.docs.first;

        // Update the ride request status in Firestore
        // await _firestore
        //     .collection('rideRequests')
        //     .doc(rideRequestDoc.id)
        //     .update({'status': status});

        // Show alert if status is accepted
        // if (status == 'accepted') {
        //   _showStatusAlert('Ride Request Accepted',
        //       'You have successfully accepted the ride request.');
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         CoPassengerDetailsScreen(userId: widget.fromUserId),
          //   ),
          // );
      //   }
      // } else {
      //   _showStatusAlert(
      //       'No Ride Request Found', 'No matching ride request was found.');
      // }
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
    print(requestData);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Request'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Passenger Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // _buildUserInfoRow('From:', fromUserName),
                  const SizedBox(height: 10),
                  // _buildUserInfoRow('To:', toUserName),
                  const Spacer(),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildUserInfoRow(String label, String name) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          name,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => _updateRideRequestStatus(),
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
        ),],);}
}