import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _feedbackController = TextEditingController();
  String _selectedFeedbackType = 'General';

  List<String> _feedbackTypes = [
    'General',
    // 'About Consultaion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedFeedbackType,
              onChanged: (newValue) {
                setState(() {
                  _selectedFeedbackType = newValue!;
                });
              },
              items: _feedbackTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Feedback Type',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Feedback',
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Submit feedback logic here
                String feedbackType = _selectedFeedbackType;
                String feedback = _feedbackController.text;

                // Implement your feedback submission logic here

                // Clear the form fields
                _feedbackController.clear();
                setState(() {
                  _selectedFeedbackType = 'General';
                });
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
