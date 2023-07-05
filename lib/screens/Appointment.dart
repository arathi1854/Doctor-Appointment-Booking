import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SizeConfig.dart';
import '../constants.dart';

class ViewAppointmentScreen extends StatefulWidget {
  const ViewAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<ViewAppointmentScreen> createState() => _ViewAppointmentScreenState();
}

class _ViewAppointmentScreenState extends State<ViewAppointmentScreen> {
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
                    return  DataTable(
                      columns:  <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Patient Name',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Date',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Time',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                      rows:<DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                                snapshot.data[index]['patient_name'])),
                            DataCell(Text(
                                snapshot.data[index]['date'])),
                            DataCell(Text(
                                snapshot.data[index]['time'])),
                          ],
                        ),

                      ],
                    );;
                  });
            }
          }),
    ));
  }
}