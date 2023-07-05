
import 'dart:convert';

import 'package:docoline/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeDoctorPasswordScreen extends StatefulWidget {
  const ChangeDoctorPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangeDoctorPasswordScreen> createState() => _ChangeDoctorPasswordScreenState();
}

class _ChangeDoctorPasswordScreenState extends State<ChangeDoctorPasswordScreen> {
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
      "doctor_id",
    );

    print(id1);
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_doctor_change_pwd.php'),
        body: {
          'doctor_id': id1,
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
