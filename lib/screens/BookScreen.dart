import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class BookScreen extends StatefulWidget {
  String name;
  String specialisation;
  String doctor_id;

  BookScreen({Key? key, required this.name, required this.specialisation,required this.doctor_id})
      : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  dynamic time;

  dynamic selectedDate;

  var patient_id;
  late String convertedDateTime;
  late  String convertedTime;

  Future<bool> Booking() async {
    final spref = await SharedPreferences.getInstance();
     patient_id= await spref.getString(
      "patient_id",
    );
     print("id= $patient_id");
    Response res =
    await post(Uri.parse(Constants.baseUrl + 'api_booking.php'), body: {
      'date':convertedDateTime,
      'time':convertedTime,
      'doctor_id':widget.doctor_id,
      'patient_id':patient_id,
      'status':'pending',

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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Column(children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.specialisation,
                  style: TextStyle(fontSize: 15),
                ),
              ]),
            ),
            Text(
              'Appointment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
                onPressed: () async {
                   selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035));
                    convertedDateTime = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')} ";
                  print(convertedDateTime);
                },
                child: Text("Select Date")),

            ElevatedButton(
                onPressed: () async {
                   time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                    convertedTime = "${time.hour.toString().padLeft(2,'0')}-${time.minute.toString().padLeft(2,'0')}";
                  print(convertedTime);
                },
                child: Text("Select Time")),
            ElevatedButton(
              onPressed: () {
                Booking();
                Navigator.pop(context);
                showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Booking Alert'),
                  content: const Text('Booking Successfully completed'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );},
              child: const Text(
                'Book Appointment',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,backgroundColor: Colors.white,color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
