import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/RideRequestDetailsScreen.dart';
import 'package:ridemate_4/screens/bill_splitter.dart';
import 'package:ridemate_4/screens/chat_screen.dart';
import 'package:ridemate_4/screens/home_screen.dart';
import 'package:ridemate_4/screens/profile.dart';
import 'package:ridemate_4/screens/screen_main.dart';
import 'package:ridemate_4/screens/travelHistory_screen.dart';
import 'package:ridemate_4/screens/signin_screen.dart'; // Import SignInScreen for logout redirection

class ScreenAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen1(),
    );
  }
}

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  bool _isCollapsed = true;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser?.uid;
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
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
                _buildMenuItem(Icons.home, "Home", context, HomeScreen()),
                _buildMenuItem(
                  Icons.money,
                  "split",
                  context,
                  ScreenSplit(),
                ),
                _buildMenuItem(
                  Icons.history,
                  "History",
                  context,
                  TravelHistoryScreen(),
                ),
                _buildMenuItem(
                  Icons.info,
                  "Profile",
                  context,
                  ProfileScreen(),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RideMate",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "RideMate connects you with co-passengers traveling on similar routes, making your commute more affordable and efficient. Find people going your way, share the ride, and split the fare.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
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
