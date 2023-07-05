import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class FeedbackDialog extends StatefulWidget {
  String name;
  String specialisation;
  String doctor_id;

  FeedbackDialog(
      {Key? key,
      required this.name,
      required this.specialisation,
      required this.doctor_id})
      : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController content_controller = TextEditingController();
  late ThemeData themeData;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var patient_id;

  @override
  void dispose() {
    content_controller.dispose();
    super.dispose();
  }

  Future<bool> Feedback() async {
    final spref = await SharedPreferences.getInstance();
    patient_id = await spref.getString(
      "patient_id",
    );
    print("id= $patient_id");
    Response res =
        await post(Uri.parse(Constants.baseUrl + 'api_feedback.php'), body: {
      'doctor_id': widget.doctor_id,
      'patient_id': patient_id,
      'content': content_controller.text.toString(),
    });
    print(res.body);

    Map data = jsonDecode(res.body);
    if (data['message'] == "Sucessful") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TextButton(child: Text('Back'),
              onPressed: () => Navigator.of(context).pop(),
              // icon: Icon(
              //   MdiIcons.chevronLeft,
              //   color: themeData.colorScheme.primary,
              // ),
            ),
          ),
        ),
        AlertDialog(
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: content_controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Enter your feedback here',
                filled: true,
              ),
              maxLines: 5,
              maxLength: 3000,
              textInputAction: TextInputAction.done,
              validator: (String? text) {
                if (text == null || text.isEmpty) {
                  return 'Please enter a value';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () async {
                Feedback();
                Navigator.pop(context);
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Feedback alert'),
                          content: const Text('Feedback sucessfully entered'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ));
                /**
                     * Here we will add the necessary code to
                     * send the entered data to the Firebase Cloud Firestore.
                     */
              },
            ),
          ],
        ),
      ],
    ));
  }
}
