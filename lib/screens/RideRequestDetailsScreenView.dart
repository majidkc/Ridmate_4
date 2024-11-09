// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RideRequestDetailsScreen extends StatefulWidget {
//   final String requestId;
//   final String fromUserId;

//   const RideRequestDetailsScreen({
//     Key? key,
//     required this.requestId,
//     required this.fromUserId,
//   }) : super(key: key);

//   @override
//   _RideRequestDetailsScreenState createState() =>
//       _RideRequestDetailsScreenState();
// }

// class _RideRequestDetailsScreenState extends State<RideRequestDetailsScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, dynamic>? requestData;
//   Map<String, dynamic>? senderData;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRequestData();
//   }

//   Future<void> _fetchRequestData() async {
//     try {
//       // Fetch the ride request details
//       final DocumentSnapshot requestSnapshot = await _firestore
//           .collection('rideRequests')
//           .doc(widget.requestId)
//           .get();
//       if (requestSnapshot.exists) {
//         setState(() {
//           requestData = requestSnapshot.data() as Map<String, dynamic>;
//         });
//       } else {
//         print('Ride request not found.');
//       }

//       // Fetch the sender's details
//       final DocumentSnapshot senderSnapshot = await _firestore
//           .collection('users')
//           .doc(widget.fromUserId)
//           .get();
//       if (senderSnapshot.exists) {
//         setState(() {
//           senderData = senderSnapshot.data() as Map<String, dynamic>;
//         });
//       } else {
//         print('Sender not found.');
//       }
//     } catch (e) {
//       print('Error fetching request details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ride Request Details'),
//         backgroundColor: Colors.purple,
//       ),
//       body: requestData == null || senderData == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Sender: ${senderData!['name']}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   // Display other ride request details (start location, end location, mode, etc.)
//                   Text(
//                     'Start Location: ${requestData!['startLocation']}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'End Location: ${requestData!['endLocation']}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Mode: ${requestData!['mode']}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   // ... Add more details from requestData
//                 ],
//               ),
//             ),
//     );
//   }
// }