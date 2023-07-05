import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

 late String _currentPassword;
  late String _newPassword;
   late String _confirmPassword;

  Future _changePassword() async {
    final spref = await SharedPreferences.getInstance();
    var id1 = await spref.getString(
      "patient_id",
    );
    print(id1);
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_user_change_pwd.php'),
        body: {
          'patient_id': id1,
          'password': _confirmPassword,
        });
    print(res.body);

    if (_formKey.currentState!.validate()) {
      // Perform authentication and password change logic here
      // You can make API calls to your backend or interact with your database

      // Example: Simulating a password change
      if (_currentPassword == 'currentPass123') {
        // Password change logic
        // Replace the following with your actual password change implementation

        print('Password changed successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
      } else {
        // Invalid current password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect current password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Current Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                onSaved: (value) => _currentPassword = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password';
                  }
                  // Add any additional password validation logic here
                  return null;
                },
                onSaved: (value) => _newPassword = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) => _confirmPassword = value!,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }}
