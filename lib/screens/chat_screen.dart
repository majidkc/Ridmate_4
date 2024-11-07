// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:ridemate_4/screens/RideRequestScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'package:http/http.dart' as http; // Import http package

// class NotificationHandler extends StatefulWidget {
//   const NotificationHandler({Key? key}) : super(key: key);

//   @override
//   State<NotificationHandler> createState() => _NotificationHandlerState();
// }

// class _NotificationHandlerState extends State<NotificationHandler> {
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final _firestore = FirebaseFirestore.instance; // Add FirebaseFirestore instance
//   final _notifications = <RemoteMessage>[];
//   bool _showRideRequest = false;
//   String? _fromUserId;
//   String? _toUserId;
//   String? _requestStatus;

//   @override
//   void initState() {
//     super.initState();

//     // Request notification permissions
//     messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     // Handle notification taps when the app is in the foreground
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print('Message data: ${message.data}');

//       // Extract data from notification
//       _fromUserId = message.data['fromUserId'];
//       _toUserId = message.data['toUserId'];

//       // Check if it's a ride request notification
//       if (_fromUserId != null && _toUserId != null) {
//         // Check if the notification is for the current user
//         if (_toUserId == FirebaseAuth.instance.currentUser!.uid) {
//           setState(() {
//             _showRideRequest = true;
//             _fetchRequestStatus();
//           });
//         }
//       }
//     });

//     // Handle background messages (if needed)
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle foreground messages (if needed)
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }

//   // Handle background messages
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     // This is only called when the app is in the background. 
//     print('Handling a background message: ${message.messageId}');
//   }

//   Future<void> _fetchRequestStatus() async {
//     try {
//       // Get the ride request document (assuming you have a 'rideRequests' collection)
//       DocumentSnapshot<Map<String, dynamic>> requestDoc = await _firestore
//           .collection('rideRequests')
//           .where('fromUserId', isEqualTo: _fromUserId)
//           .where('toUserId', isEqualTo: _toUserId)
//           .get()
//           .then((snapshot) => snapshot.docs.first);

//       if (requestDoc.exists) {
//         setState(() {
//           _requestStatus = requestDoc.data()?['status'] as String?;
//         });
//       }
//     } catch (e) {
//       print('Error fetching ride request status: $e');
//     }
//   }

//   void _acceptRequest() async {
//     try {
//       // Update the ride request status in Firestore
//       await _firestore
//           .collection('rideRequests')
//           .where('fromUserId', isEqualTo: _fromUserId)
//           .where('toUserId', isEqualTo: _toUserId)
//           .get()
//           .then((snapshot) => snapshot.docs.first.reference.update({'status': 'accepted'}));

//       // ... (Handle any additional logic after accepting the request)
//     } catch (e) {
//       print('Error accepting ride request: $e');
//     }
//   }

//   void _rejectRequest() async {
//     try {
//       // Update the ride request status in Firestore
//       await _firestore
//           .collection('rideRequests')
//           .where('fromUserId', isEqualTo: _fromUserId)
//           .where('toUserId', isEqualTo: _toUserId)
//           .get()
//           .then((snapshot) => snapshot.docs.first.reference.update({'status': 'rejected'}));

//       // ... (Handle any additional logic after rejecting the request)
//     } catch (e) {
//       print('Error rejecting ride request: $e');
//     }
//   }

//   // Function to send FCM notification
//   Future<void> _sendNotification(String toUserId, String message) async {
//     try {
//       // Replace with your actual FCM server key
//       final serverKey = 'YOUR_FCM_SERVER_KEY';
//       final senderId = 'YOUR_FCM_SENDER_ID';

//       // Get the co-passenger's token from Firestore (you'll need to store it)
//       final coPassengerToken =
//           await _getCoPassengerToken(toUserId); // Implement this method

//       if (coPassengerToken != null) {
//         final response = await http.post(
//           Uri.parse('https://fcm.googleapis.com/fcm/send'),
//           headers: <String, String>{
//             'Content-Type': 'application/json',
//             'Authorization': 'key=$serverKey',
//           },
//           body: jsonEncode(<String, dynamic>{
//             'to': coPassengerToken,
//             'notification': <String, dynamic>{
//               'title': 'Ride Request from RideMate',
//               'body': message,
//             },
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1', // You can use this for custom data
//               'fromUserId': FirebaseAuth
//                   .instance.currentUser!.uid, // Include the sender's userId
//               'toUserId': toUserId // Include the recipient's userId
//             },
//           }),
//         );

//         if (response.statusCode == 200) {
//           print('Notification sent successfully!');
//         } else {
//           print('Notification sending failed: ${response.statusCode}');
//         }
//       } else {
//         print('Co-passenger token not found!');
//       }
//     } catch (e) {
//       print('Error sending notification: $e');
//     }
//   }

//   // Function to fetch the co-passenger's FCM token from Firestore
//   Future<String?> _getCoPassengerToken(String toUserId) async {
//     try {
//       final DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(toUserId)
//           .get();
//       if (userDoc.exists) {
//         final userData = userDoc.data() as Map<String, dynamic>; // Cast to Map
//         return userData['fcmToken']
//             as String?; // Assuming you store FCM token as 'fcmToken'
//       } else {
//         print('Co-passenger document not found!');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching token: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: _showRideRequest
//           ? RideRequestsScreen(
//               fromUserId: _fromUserId!, // Pass the received fromUserId
//               toUserId: _toUserId!, // Pass the received toUserId
//             )
//           : _notifications.isEmpty
//               ? Center(child: const Text('No notifications yet'))
//               : ListView.builder(
//                   itemCount: _notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = _notifications[index];
//                     return ListTile(
//                       title: Text(notification.notification?.title ??
//                           'No Title'),
//                       subtitle: Text(notification.notification?.body ??
//                           'No Body'),
//                       onTap: () {
//                         // Handle notification tap (e.g., navigate to relevant screen)
//                         // You can access the 'data' field of the notification for custom data
//                         print('Notification data: ${notification.data}');
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }