import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0;
  TextEditingController feedbackController = TextEditingController();

  void submitFeedback() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userEmail = user.email; // Get the user's email address
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'user_email': userEmail, // Store the user's email
          'rating': rating,
          'feedback_text': feedbackController.text,
        });
        // You can add additional fields as needed.
        // Reset the form
        setState(() {
          rating = 0;
          feedbackController.clear();
        });

        // Show a success alert
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Feedback Sent'),
              content: Text('Thank you for your feedback!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error submitting feedback: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.red,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Star Rating
            RatingBar(
              rating: rating,
              onRatingChanged: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
            ),

            // Feedback Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ),

            ElevatedButton(
              onPressed: () => submitFeedback(),
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBar extends StatefulWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  RatingBar({required this.rating, required this.onRatingChanged});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.star, color: widget.rating >= 1 ? Colors.yellow : Colors.grey),
          onPressed: () => widget.onRatingChanged(1),
        ),
        IconButton(
          icon: Icon(Icons.star, color: widget.rating >= 2 ? Colors.yellow : Colors.grey),
          onPressed: () => widget.onRatingChanged(2),
        ),
        IconButton(
          icon: Icon(Icons.star, color: widget.rating >= 3 ? Colors.yellow : Colors.grey),
          onPressed: () => widget.onRatingChanged(3),
        ),
        IconButton(
          icon: Icon(Icons.star, color: widget.rating >= 4 ? Colors.yellow : Colors.grey),
          onPressed: () => widget.onRatingChanged(4),
        ),
        IconButton(
          icon: Icon(Icons.star, color: widget.rating == 5 ? Colors.yellow : Colors.grey),
          onPressed: () => widget.onRatingChanged(5),
        ),
      ],
    );
  }
}
