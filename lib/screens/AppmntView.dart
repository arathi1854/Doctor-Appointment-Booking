import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SizeConfig.dart';
import '../constants.dart';

class ViewApp extends StatefulWidget {
  const ViewApp({Key? key}) : super(key: key);

  @override
  State<ViewApp> createState() => _ViewAppState();
}

class _ViewAppState extends State<ViewApp> {
  @override
  void initState() {
    ViewAppointment();
    super.initState();
  }

  var patient_name;
  dynamic date;
  dynamic time;
  var status;
  dynamic data;
  dynamic booking_id;

  Future<dynamic> ViewAppointment() async {
    final spref = await SharedPreferences.getInstance();
    var id = await spref.getString(
      "doctor_id",
    );
    print("doctor id    $id");
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_appointment_view.php'),
        body: {"id": id});
    print(res.body);
    data = jsonDecode(res.body);
    print("response data is $data");
    if (data[0]['message'] == "Sucessful") {
      print("sucessfull");
      return data;
    } else {
      return false;
    }
  }

  Future<dynamic> StatusApprove(dynamic book_id, String status) async {
    // final spref = await SharedPreferences.getInstance();
    // var id = await spref.getString(
    //   "booking_id",
    // );
    print("booking id    $book_id");
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_status_change_booking.php'),
        body: {"booking_id": book_id, "status": status});
    print(res.body);
    data = jsonDecode(res.body);
    print("response data is $data");
    if (data['message'] == "Sucessful") {
      print("sucessfull");
      return data;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Center(
        child: FutureBuilder(
            future: ViewAppointment(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image(
                  image: AssetImage('assets/images/Loading123.gif'),
                  height: MySize.size180,
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Patient Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data[index]['patient_name']),
                                  Text(snapshot.data[index]['date']),
                                  Text(snapshot.data[index]['time']),
                                  Text(snapshot.data[index]['status'])
                                ],
                              ),
                              SizedBox(height: 8.0),
                              snapshot.data[index]['status'] == "Pending"
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: ElevatedButton(
                                                onPressed: () {

                                                  booking_id = snapshot
                                                      .data[index]['booking_id']
                                                      .toString();
                                                  // print(booking_id);
                                                  StatusApprove(
                                                      booking_id, "Approve");

                                                },
                                                child: Text("Accept")),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                booking_id = snapshot
                                                    .data[index]['booking_id']
                                                    .toString();
                                                StatusApprove(
                                                    booking_id, "Reject");

                                              },
                                              child: Text("Reject"))
                                        ],
                                      ),
                                    )
                                  : SizedBox(),

                              // Add more rows as needed
                            ],
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    ));
  }
}
