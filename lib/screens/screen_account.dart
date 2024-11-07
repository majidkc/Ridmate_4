import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/RideRequestScreen.dart';
import 'package:ridemate_4/screens/chat_screen.dart';
import 'package:ridemate_4/screens/profile.dart';
// import 'package:ridemate_4/screens/profile.dart';
// import 'package:ridemate_4/screens/profile.dart';
import 'package:ridemate_4/screens/travelHistory_screen.dart';
// import 'chat_screen.dart'; // Import your ChatScreen

class ScreenAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isCollapsed = true;
  final _firestore = FirebaseFirestore.instance;
  String? _currentUserId; // Store the current user ID

  @override
  void initState() {
    super.initState();
    // Get the current user ID when the HomeScreen initializes
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isCollapsed ? 70 : 250,
            color: Colors.blueGrey[900],
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    _isCollapsed ? Icons.menu : Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildMenuItem(Icons.home, "Home", context, null),
                _buildMenuItem(Icons.request_page, "Request", context,
                    RideRequestScreen(fromUserId: _currentUserId!, toUserId: 'otherUserId')), // Pass the currentUserId
                _buildMenuItem(Icons.history, "History", context, TravelHistoryScreen()),
                _buildMenuItem(Icons.info, "Profile", context, ProfileScreen()),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Center(
              child: Text(
                "Main Content Area",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String label, BuildContext context, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: _isCollapsed
          ? null
          : Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }
} 