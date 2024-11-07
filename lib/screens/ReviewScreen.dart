import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewScreen extends StatefulWidget {
  final String userId; // Receive the userId of the co-passenger

  const ReviewScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _saveReview() async {
    setState(() => _isLoading = true);

    try {
      // Get the current user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Add the review to Firestore (adjust the collection and data structure as needed)
      await _firestore.collection('reviews').add({
        'reviewerId': currentUserId,
        'revieweeId': widget.userId,
        'review': _reviewController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Handle success after saving the review
      setState(() {
        _isLoading = false;
        // Show a success message or navigate back to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );
      });
    } catch (e) {
      // Handle error if saving the review fails
      print('Error saving review: $e');
      setState(() {
        _isLoading = false;
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Input
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Write your review',
              ),
            ),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveReview,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}