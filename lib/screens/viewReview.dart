// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ViewReviewScreen extends StatefulWidget {
//   final String userId; // The userId of the co-passenger whose reviews are being displayed

//   const ViewReviewScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   _ViewReviewScreenState createState() => _ViewReviewScreenState();
// }

// class _ViewReviewScreenState extends State<ViewReviewScreen> {
//   final _firestore = FirebaseFirestore.instance;
//   String? _currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     _currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reviews'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('reviews')
//             .where('revieweeId', isEqualTo: widget.userId) // Filter by revieweeId
//             .orderBy('timestamp', descending: true) // Order by timestamp
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final reviews = snapshot.data!.docs
//                 .map((doc) => doc.data() as Map<String, dynamic>)
//                 .toList();

//             return ListView.builder(
//               itemCount: reviews.length,
//               itemBuilder: (context, index) {
//                 final review = reviews[index];
//                 final reviewerId = review['reviewerId'];

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: _firestore
//                       .collection('users')
//                       .doc(reviewerId)
//                       .get(),
//                   builder: (context, userSnapshot) {
//                     if (userSnapshot.hasData) {
//                       final reviewerName =
//                           userSnapshot.data!['name'] as String;

//                       return ListTile(
//                         title: Text(review['review']),
//                         subtitle: Text('By: $reviewerName'),
//                       );
//                     } else if (userSnapshot.hasError) {
//                       return Text('Error: ${userSnapshot.error}');
//                     } else {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                   },
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ViewReviewScreen extends StatefulWidget {
//   final String userId; // The userId of the co-passenger whose reviews are being displayed

//   const ViewReviewScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   _ViewReviewScreenState createState() => _ViewReviewScreenState();
// }

// class _ViewReviewScreenState extends State<ViewReviewScreen> {
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reviews'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('reviews')
//             .where('revieweeId', isEqualTo: widget.userId) // Filter by revieweeId
//             .orderBy('timestamp', descending: true) // Order by timestamp
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final reviews = snapshot.data!.docs;

//             if (reviews.isEmpty) {
//               return Center(child: Text('No reviews available.'));
//             }

//             return ListView.builder(
//               itemCount: reviews.length,
//               itemBuilder: (context, index) {
//                 final reviewData = reviews[index].data() as Map<String, dynamic>;
//                 final reviewerId = reviewData['reviewerId'] as String?;
//                 final reviewText = reviewData['review'] as String;

//                 return FutureBuilder<DocumentSnapshot>(
//                   future: _firestore.collection('users').doc(reviewerId).get(),
//                   builder: (context, userSnapshot) {
//                     if (userSnapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }

//                     if (userSnapshot.hasError) {
//                       return ListTile(
//                         title: Text(reviewText),
//                         subtitle: Text('Error loading reviewer data'),
//                       );
//                     }

//                     if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
//                       return ListTile(
//                         title: Text(reviewText),
//                         subtitle: Text('Reviewer information not available'),
//                       );
//                     }

//                     final reviewerName = userSnapshot.data!['name'] as String;

//                     return ListTile(
//                       title: Text(reviewText),
//                       subtitle: Text('By: $reviewerName'),
//                     );
//                   },
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewReviewScreen extends StatefulWidget {
  final String userId; // The userId of the co-passenger whose reviews are being displayed

  const ViewReviewScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewReviewScreenState createState() => _ViewReviewScreenState();
}

class _ViewReviewScreenState extends State<ViewReviewScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('reviews')
            .where('revieweeId', isEqualTo: widget.userId) // Filter by revieweeId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final reviews = snapshot.data!.docs;

            if (reviews.isEmpty) {
              return Center(child: Text('No reviews available.'));
            }

            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final reviewData = reviews[index].data() as Map<String, dynamic>;
                final reviewerId = reviewData['reviewerId'] as String?;
                final reviewText = reviewData['review'] as String;

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(reviewerId).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (userSnapshot.hasError) {
                      return ListTile(
                        title: Text(reviewText),
                        subtitle: Text('Error loading reviewer data'),
                      );
                    }

                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return ListTile(
                        title: Text(reviewText),
                        subtitle: Text('Reviewer information not available'),
                      );
                    }

                    final reviewerName = userSnapshot.data!['name'] as String;

                    return ListTile(
                      title: Text(reviewText),
                      subtitle: Text('By: $reviewerName'),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
