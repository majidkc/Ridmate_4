// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'package:ridemate_4/screens/ReviewScreen.dart';
// import 'package:ridemate_4/screens/RideRequestDetailsScreen.dart';
// import 'package:ridemate_4/screens/chat_screen.dart';
// import 'package:ridemate_4/screens/profile.dart';
// import 'package:ridemate_4/screens/travelHistory_screen.dart';
// import 'package:ridemate_4/screens/viewReview.dart';

// class CoPassengerDetailsScreen extends StatefulWidget {
//   final String userId; // Receive the userId of the co-passenger

//   const CoPassengerDetailsScreen({Key? key, required this.userId})
//       : super(key: key);

//   @override
//   _CoPassengerDetailsScreenState createState() =>
//       _CoPassengerDetailsScreenState();
// }

// class _CoPassengerDetailsScreenState extends State<CoPassengerDetailsScreen> {
//   late DocumentSnapshot<Map<String, dynamic>> coPassengerData;
//   final _messageController = TextEditingController();
//   final _firestore = FirebaseFirestore.instance;
//   late String chatRoomId;
//   bool _isLoading = false; // Flag to track loading state
//   String? _currentUserId;
//   String? _serverKey; // You need to replace this with your actual server key
//   String? _senderId; // You need to replace this with your actual sender ID

//   @override
//   void initState() {
//     super.initState();
//     // Get the current user ID
//     _currentUserId = FirebaseAuth.instance.currentUser?.uid;

//     // Fetch the co-passenger data from Firestore
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.userId)
//         .get()
//         .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
//       if (documentSnapshot.exists) {
//         setState(() {
//           coPassengerData = documentSnapshot;
//         });
//       }
//     });

//     // Get the current user ID
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//     // Create the chat room ID (you can choose a different format if needed)
//     chatRoomId = currentUserId.compareTo(widget.userId) < 0
//         ? '${currentUserId}_${widget.userId}'
//         : '${widget.userId}_${currentUserId}';
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() {
//     final message = _messageController.text.trim();
//     if (message.isNotEmpty) {
//       // Get the current user ID
//       final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//       // Add the message to Firestore
//       _firestore
//           .collection('chats')
//           .doc(chatRoomId)
//           .collection('messages') // Access the 'messages' subcollection
//           .add({
//         'senderId': currentUserId,
//         'message': message,
//         'timestamp':
//             FieldValue.serverTimestamp(), // Use Firestore's server timestamp
//       });

//       _messageController.clear(); // Clear the input field
//     }
//   }

//   // Send ride request to co-passenger
//   Future<void> _sendRideRequest() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       // Get the current user ID
//       final currentUserId = FirebaseAuth.instance.currentUser!.uid;

//       // Store ride request in Firestore (adjust the collection and document structure as needed)
//       await _firestore.collection('rideRequests').add({
//         'fromUserId': currentUserId,
//         'toUserId': widget.userId,
//         'status': 'pending', // Initially pending
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Send FCM notification to the co-passenger
//       await _sendNotification(
//           widget.userId, 'Ride request received. Please accept or reject.');

//       // Show a success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ride request sent successfully!')),
//       );
//     } catch (e) {
//       // Handle error if sending ride request fails
//       print('Error sending ride request: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send ride request.')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Function to send FCM notification
//   Future<void> _sendNotification(String toUserId, String message) async {
//     try {
//       // Replace with your actual FCM server key
//       final serverKey = 'YOUR_FCM_SERVER_KEY'; // Replace with your server key
//       final senderId = 'YOUR_FCM_SENDER_ID'; // Replace with your sender ID

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
//         title: Text('Co-Passenger Details'),
//       ),
//       body: coPassengerData == null
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Display co-passenger details
//                   Text(
//                     'Name: ${coPassengerData['name']}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   // ... (Add more fields as needed)

//                   // Send Ride Request Button
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _sendRideRequest,
//                     child: _isLoading
//                         ? CircularProgressIndicator()
//                         : Text('Send Ride Request'),
//                   ),

//                   // Review Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to the review screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ReviewScreen(userId: widget.userId),
//                         ),
//                       );
//                     },
//                     child: Text('Give Review'),
//                   ),

//                   // View Reviews Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to the reviews screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ViewReviewScreen(userId: widget.userId),
//                         ),
//                       );
//                     },
//                     child: Text('View Reviews'),
//                   ),

//                   // Chat Box
//                   Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: _firestore
//                           .collection('chats')
//                           .doc(chatRoomId)
//                           .collection(
//                               'messages') // Access the 'messages' subcollection
//                           .orderBy('timestamp',
//                               descending: true) // Order messages by timestamp
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final messages = snapshot.data!.docs
//                               .map((doc) => doc.data() as Map<String, dynamic>)
//                               .toList(); // Retrieve messages from QuerySnapshot
//                           final currentUserId =
//                               FirebaseAuth.instance.currentUser!.uid;

//                           // Check if the messages list is empty
//                           if (messages.isEmpty) {
//                             return Center(child: Text('No messages yet'));
//                           } else {
//                             return ListView.builder(
//                               reverse: true,
//                               itemCount: messages.length,
//                               itemBuilder: (context, index) {
//                                 final message = messages[index];
//                                 final senderId = message['senderId'];

//                                 return Align(
//                                   alignment: senderId == currentUserId
//                                       ? Alignment.bottomRight
//                                       : Alignment.bottomLeft,
//                                   child: Container(
//                                     padding: EdgeInsets.all(12),
//                                     margin: EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: senderId == currentUserId
//                                           ? Colors.purple
//                                           : Colors.grey[300],
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Text(message['message']),
//                                   ),
//                                 );
//                               },
//                             );
//                           }
//                         } else if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       },
//                     ),
//                   ),

//                   // Chat Input Row
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: InputDecoration(
//                               hintText: 'Type your message',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: _sendMessage,
//                           icon: Icon(Icons.send),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // Helper function to get the icon based on the mode
//   IconData getModeIcon(String mode) {
//     switch (mode) {
//       case 'Car':
//         return Icons.directions_car;
//       case 'Bike':
//         return Icons.directions_bike;
//       case 'Auto':
//         return Icons.directions_transit;
//       default:
//         return Icons.question_mark; // Default icon if mode is unknown
//     }
//   }
// }








import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:ridemate_4/screens/ReviewScreen.dart';
import 'package:ridemate_4/screens/RideRequestDetailsScreen.dart';
import 'package:ridemate_4/screens/chat_screen.dart';
import 'package:ridemate_4/screens/profile.dart';
import 'package:ridemate_4/screens/travelHistory_screen.dart';
import 'package:ridemate_4/screens/viewReview.dart';

class CoPassengerDetailsScreen extends StatefulWidget {
  final String userId; // Receive the userId of the co-passenger

  const CoPassengerDetailsScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _CoPassengerDetailsScreenState createState() =>
      _CoPassengerDetailsScreenState();
}

class _CoPassengerDetailsScreenState extends State<CoPassengerDetailsScreen> {
  late DocumentSnapshot<Map<String, dynamic>> coPassengerData;
  final _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late String chatRoomId;
  bool _isLoading = false; // Flag to track loading state
  String? _currentUserId;
  String? _serverKey; // You need to replace this with your actual server key
  String? _senderId; // You need to replace this with your actual sender ID

  @override
  void initState() {
    super.initState();
    // Get the current user ID
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Fetch the co-passenger data from Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          coPassengerData = documentSnapshot;
        });
      }
    });

    // Get the current user ID
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Create the chat room ID (you can choose a different format if needed)
    chatRoomId = currentUserId.compareTo(widget.userId) < 0
        ? '${currentUserId}_${widget.userId}'
        : '${widget.userId}_${currentUserId}';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Get the current user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Add the message to Firestore
      _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages') // Access the 'messages' subcollection
          .add({
        'senderId': currentUserId,
        'message': message,
        'timestamp':
            FieldValue.serverTimestamp(), // Use Firestore's server timestamp
      });

      _messageController.clear(); // Clear the input field
    }
  }

  // Send ride request to co-passenger
  Future<void> _sendRideRequest() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Get the current user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Store ride request in Firestore (adjust the collection and document structure as needed)
      await _firestore.collection('rideRequests').add({
        'fromUserId': currentUserId,
        'toUserId': widget.userId,
        'status': 'pending', // Initially pending
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Send FCM notification to the co-passenger
      await _sendNotification(
          widget.userId, 'Ride request received. Please accept or reject.');

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ride request sent successfully!')),
      );
    } catch (e) {
      // Handle error if sending ride request fails
      print('Error sending ride request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send ride request.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to send FCM notification
  Future<void> _sendNotification(String toUserId, String message) async {
    try {
      // Replace with your actual FCM server key
      final serverKey = 'YOUR_FCM_SERVER_KEY'; // Replace with your server key
      final senderId = 'YOUR_FCM_SENDER_ID'; // Replace with your sender ID

      // Get the co-passenger's token from Firestore (you'll need to store it)
      final coPassengerToken =
          await _getCoPassengerToken(toUserId); // Implement this method

      if (coPassengerToken != null) {
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(<String, dynamic>{
            'to': coPassengerToken,
            'notification': <String, dynamic>{
              'title': 'Ride Request from RideMate',
              'body': message,
            },
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1', // You can use this for custom data
              'fromUserId': FirebaseAuth
                  .instance.currentUser!.uid, // Include the sender's userId
              'toUserId': toUserId // Include the recipient's userId
            },
          }),
        );

        if (response.statusCode == 200) {
          print('Notification sent successfully!');
        } else {
          print('Notification sending failed: ${response.statusCode}');
        }
      } else {
        print('Co-passenger token not found!');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Function to fetch the co-passenger's FCM token from Firestore
  Future<String?> _getCoPassengerToken(String toUserId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(toUserId)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>; // Cast to Map
        return userData['fcmToken']
            as String?; // Assuming you store FCM token as 'fcmToken'
      } else {
        print('Co-passenger document not found!');
        return null;
      }
    } catch (e) {
      print('Error fetching token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Co-Passenger Details'),
      ),
      body: coPassengerData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display co-passenger details
                  Text(
                    'Name: ${coPassengerData['name']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Check if the toUserId is the same as the current userId
                  // Text(
                  //   'User ID: ${widget.userId == _currentUserId ? "Unknown" : widget.userId}',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(height: 16),

                  // Send Ride Request Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendRideRequest,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Send Ride Request'),
                  ),

                  // Review Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the review screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewScreen(userId: widget.userId),
                        ),
                      );
                    },
                    child: Text('Give Review'),
                  ),

                  // View Reviews Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the reviews screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewReviewScreen(userId: widget.userId),
                        ),
                      );
                    },
                    child: Text('View Reviews'),
                  ),

                  // Chat Box
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chats')
                          .doc(chatRoomId)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messages = snapshot.data!.docs
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();
                          final currentUserId =
                              FirebaseAuth.instance.currentUser!.uid;

                          if (messages.isEmpty) {
                            return Center(child: Text('No messages yet'));
                          } else {
                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                final senderId = message['senderId'];

                                return Align(
                                  alignment: senderId == currentUserId
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: senderId == currentUserId
                                          ? Colors.purple
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(message['message']),
                                  ),
                                );
                              },
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),

                  // Chat Input Row
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
