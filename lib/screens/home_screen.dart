import 'package:flutter/material.dart';
import 'package:ridemate_4/screens/screen_main.dart';
import 'package:ridemate_4/screens/bill_splitter.dart';
import 'package:ridemate_4/screens/screen_account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentSelectedIndex = 0;
  bool _isCollapsed = true; // State for sidebar collapse/expand
  final _pages = [ScreenMain(), ScreenSplit(), ScreenAccount()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('RideMate'),
      //   backgroundColor: Colors.teal,
      // ),
      body: Stack(
        children: [
          _pages[_currentSelectedIndex], // Main content area
          // _buildCollapsibleSidebar(), // Sidebar overlay
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.green,
        currentIndex: _currentSelectedIndex,
        onTap: (newIndex) {
          setState(() {
            _currentSelectedIndex = newIndex;
            if (newIndex == 2) {
              // Toggle sidebar for "Account"
              _isCollapsed = !_isCollapsed;
            } else {
              _isCollapsed = true;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Split'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
//   Widget _buildCollapsibleSidebar() {
//     return AnimatedPositioned(
//       duration: Duration(milliseconds: 300),
//       left: _isCollapsed ? -250 : 0,
//       top: 0,
//       bottom: 0,
//       child: Container(
//         width: 250,
//         color: Colors.blueGrey[900],
//         padding: EdgeInsets.symmetric(vertical: 20),
//         child: Column(
//           children: [
//             IconButton(
//               icon: Icon(
//                 _isCollapsed ? Icons.arrow_right : Icons.arrow_left,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _isCollapsed = !_isCollapsed;
//                 });
//               },
//             ),
//             if (!_isCollapsed) ...[
//               _buildMenuItem(Icons.person, "Account", () {
//                 setState(() {
//                   _isCollapsed = true;
//                   _currentSelectedIndex = 2; // Directly open the "Account" page
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ScreenAccount()),
//                   );
//                 });
//               }),
//               _buildMenuItem(Icons.settings, "Settings", () {}),
//               _buildMenuItem(Icons.info, "About", () {}),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(label, style: TextStyle(color: Colors.white)),
//       onTap: onTap,
//     );
//   }
// }


// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           'Your pick of rides at low prices',
//           style: TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Top Image with Cars on a Bridge
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/p2.jpeg'), // Add your asset image here
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Ride Search Card
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Leaving from / Going to options
//                       RadioListTile(
//                         title: Text('Leaving from'),
//                         value: 1,
//                         groupValue: 1,
//                         onChanged: (value) {},
//                       ),
//                       RadioListTile(
//                         title: Text('Going to'),
//                         value: 2,
//                         groupValue: 1,
//                         onChanged: (value) {},
//                       ),
//                       SizedBox(height: 10),

//                       // Date Picker Row
//                       Row(
//                         children: [
//                           Icon(Icons.calendar_today, color: Colors.grey),
//                           SizedBox(width: 10),
//                           Text('Today'),
//                         ],
//                       ),
//                       SizedBox(height: 20),

//                       // Number of Passengers
//                       Row(
//                         children: [
//                           Icon(Icons.person, color: Colors.grey),
//                           SizedBox(width: 10),
//                           Text('1'),
//                         ],
//                       ),
//                       SizedBox(height: 20),

//                       // Search Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: Text(
//                             'Search',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Ride Listing
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 elevation: 2,
//                 child: ListTile(
//                   leading: Icon(Icons.access_time),
//                   title: Text(
//                     'Hrishikesh, Ambadi nagar 4 Near CET, p.o, Ambady Nagar, Bapuji Nagar, Sreekariyam, Thiruvananthapuram, Kerala → Kochi',
//                   ),
//                   subtitle: Text('1 passenger'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//           BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Publish'),
//           BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Your rides'),
//           BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
