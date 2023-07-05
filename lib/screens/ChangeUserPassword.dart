import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> ChangePassword() async {
    final spref = await SharedPreferences.getInstance();
    var id1 = await spref.getString(
      "patient_id",
    );

    print(id1);
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_patient_change_pwd.php'),
        body: {
          'patient_id': id1,
          'password': _confirmPasswordController.text,
        });
    print(res.body);

    var data1 = jsonDecode(res.body);
    if (data1['message'] == "Sucessful") {
      print("updated");
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: ()async {
               await ChangePassword();
                // Validate and perform password change action
                // String currentPassword = _currentPasswordController.text;
                //  String newPassword = _newPasswordController.text;
                //  String confirmPassword = _confirmPasswordController.text;
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                // Navigate back or perform cancel operation
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
