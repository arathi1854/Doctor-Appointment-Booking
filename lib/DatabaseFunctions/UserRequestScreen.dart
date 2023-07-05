
import 'package:docoline/screens/UserProfile.dart';
import 'package:flutter/material.dart';
class UserRequestScreen extends StatelessWidget {
  const UserRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()));
            },
            child: Text("You will be notified soon")),
      ),
    );
  }
}
