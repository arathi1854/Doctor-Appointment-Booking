import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SizeConfig.dart';
import '../constants.dart';

class ViewAppointment extends StatefulWidget {
  const ViewAppointment({Key? key}) : super(key: key);

  @override
  State<ViewAppointment> createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
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
  var c1 = Colors.yellow;
  var c2 = Colors.redAccent;
  var c3 = Colors.cyanAccent;

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
      // setState(() {
      //   patient_name = data['patient_name'].toString();
      //   date = data['date'].toString();
      //   time = data['time'].toString();
      //   status = data['status'].toString();
      // });
      return data;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder(
              future: ViewAppointment(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Image(
                    image: AssetImage('assets/images/Loading123.gif'),
                    height: MySize.size180,
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: c3,
                                    height: 100,
                                    width: 100,
                                    margin: EdgeInsets.all(5),
                                  ),
                                  Container(color: c2, height: 100, width: 200),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: c1,
                                    height: 100,
                                    width: 300,
                                    margin: EdgeInsets.all(5),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    color: c3,
                                    height: 100,
                                    width: 100,
                                    margin: EdgeInsets.all(5),
                                  ),
                                  Container(
                                      color: c2,
                                      height: 100,
                                      width: 100,
                                      margin: EdgeInsets.all(5)),
                                  Container(
                                      color: c3,
                                      height: 100,
                                      width: 100,
                                      margin: EdgeInsets.all(2))
                                ],
                              ),
                            ],
                          ),
                        );

                      });
                }
              }),
        ));
  }
}