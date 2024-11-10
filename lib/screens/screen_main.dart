import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ridemate_4/screens/CoPassengerList_screen.dart';

class ScreenMain extends StatefulWidget {
  static const routeName = '/screen-main';
  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  String? startLocation;
  String? endLocation;
  String? selectedMode;
  bool? rideNow;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Same Location, Same Taxi'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            buildLocationInput('Select a Start Location', (value) {
              startLocation = value;
            }),
            SizedBox(height: 10),
            buildLocationInput('Select an End Location', (value) {
              endLocation = value;
            }),
            SizedBox(height: 20),
            buildDropdownMenu(),
            SizedBox(height: 20),
            buildRideNowOptions(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveDetailsToFirestore();
                findCoPassengers(); // Call to find co-passengers
              },
              child: Text('Search for a Co-Passenger'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white,),
              
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveDetailsToFirestore() async {
    if (startLocation == null ||
        endLocation == null ||
        selectedMode == null ||
        rideNow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the details!')),
      );
      return;
    }

    try {
      await _firestore.collection('rides').add({
        'startLocation': startLocation,
        'endLocation': endLocation,
        'mode': selectedMode,
        'rideNow': rideNow,
        'timestamp': FieldValue.serverTimestamp(),
        'userId':
            FirebaseAuth.instance.currentUser?.uid, // Save the userId as well
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details saved successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save details: $error')),
      );
    }
  }

 Future<void> findCoPassengers() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    String username = '';

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        username = userDoc.data()!['name'] ?? '';
      }
    }

    // Fetch rides based on start and end locations and mode
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('rides')
        .where('startLocation', isEqualTo: startLocation)
        .where('endLocation', isEqualTo: endLocation)
        .where('mode', isEqualTo: selectedMode) // Match the ride mode
        .where('rideNow', isEqualTo: rideNow) // Match if the ride is immediate
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No co-passengers found for this route.')),
      );
    } else {
      List<Map<String, dynamic>> coPassengers = [];

      for (var doc in snapshot.docs) {
        final rideData = doc.data() as Map<String, dynamic>;
        final userId = rideData['userId'];

        // Fetch user data from users collection
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            // Add the user data to the coPassengers list
            coPassengers.add({
              'mode': rideData['mode'],
              'startLocation': rideData['startLocation'],
              'endLocation': rideData['endLocation'],
              'userName': userData['name'], 
              'userId': userId // Include the userId 
            });
          }
        }
      }

      // Navigate to the CoPassengerListScreen with the matching coPassengers
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoPassengerListScreen(
            coPassengers: coPassengers,
            // You can also pass additional data if needed, e.g.,
            // rideNow: rideNow, 
            // selectedMode: selectedMode
          ),
        ),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error finding co-passengers: $error')),
    );
  }
}

  Widget buildLocationInput(String hintText, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: hintText,
        fillColor: Colors.purple[50],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildDropdownMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select A Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedMode,
          hint: Text('Select A Category'),
          onChanged: (newValue) {
            setState(() {
              selectedMode = newValue;
            });
          },
          items: ['Car', 'Auto'].map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(mode),
            );
          }).toList(),
          decoration: InputDecoration(
            fillColor: Colors.purple[50],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRideNowOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Do you want to Ride Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text('Yes'),
                value: true,
                groupValue: rideNow,
                onChanged: (newValue) {
                  setState(() {
                    rideNow = newValue;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text('No'),
                value: false,
                groupValue: rideNow,
                onChanged: (newValue) {
                  setState(() {
                    rideNow = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}