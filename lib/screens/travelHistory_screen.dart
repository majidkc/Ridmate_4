import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelHistoryScreen extends StatefulWidget {
  @override
  _TravelHistoryScreenState createState() => _TravelHistoryScreenState();
}

class _TravelHistoryScreenState extends State<TravelHistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> travelHistory = [];

  @override
  void initState() {
    super.initState();
    fetchTravelHistory();
  }

  Future<void> fetchTravelHistory() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('rides')
            .where('userId', isEqualTo: user.uid) // Assuming rides are linked to users by userId
            .orderBy('timestamp', descending: true) // Get the latest rides first
            .get();

        setState(() {
          travelHistory = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      } else {
        // Handle case where user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching travel history: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel History'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: travelHistory.isEmpty
            ? Center(child: Text('No travel history found.'))
            : ListView.builder(
                itemCount: travelHistory.length,
                itemBuilder: (context, index) {
                  final ride = travelHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text("Mode: ${ride['mode']}"),
                      subtitle: Text(
                        "Start: ${ride['startLocation']} ➔ End: ${ride['endLocation']}\nDate: ${ride['timestamp']?.toDate().toLocal()}",
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
