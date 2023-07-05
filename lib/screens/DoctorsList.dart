import 'dart:convert';
import 'package:docoline/screens/Feedback.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../AppTheme.dart';
import '../SizeConfig.dart';
import '../constants.dart';
import 'BookScreen.dart';
import 'SpecificDoctor.dart';

class DoctorsListScreen extends StatefulWidget {
  @override
  _DoctorsListScreenState createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  late ThemeData themeData;
  dynamic data1;

  Future<dynamic> ViewDoctorList() async {
    var responce = await get(
        Uri.parse(Constants.baseUrl + 'api_doctors_details_view.php'));
    data1 = jsonDecode(responce.body);
    print(data1);
    return data1;
  }

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: Column(
        // padding: EdgeInsets.all(24),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  MdiIcons.chevronLeft,
                  color: themeData.colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:1),
            child: Container(
              child: Text(
                "Top Doctors",
                style: AppTheme.getTextStyle(themeData.textTheme.headline4,
                    color: themeData.colorScheme.primaryVariant,
                    fontWeight: 600),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: ViewDoctorList(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Image(
                      image: AssetImage('assets/images/Loading123.gif'),
                      height: MySize.size180,
                    );
                  } else {
                    return ListView.builder(
                        itemCount: data1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: [
                                Card(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                          snapshot.data[index]['doctor_name']),
                                      subtitle: Text(snapshot.data[index]
                                          ['specialisation']),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                                child: const Text('Book now'),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookScreen(
                                                                name: snapshot
                                                                        .data[index]
                                                                    ['doctor_name'],
                                                                specialisation: snapshot
                                                                        .data[index]
                                                                    [
                                                                    'specialisation'],
                                                                doctor_id: snapshot
                                                                        .data[index]
                                                                    ['doctor_id'],
                                                              )));
                                                }),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 175),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              TextButton(
                                                  child: const Text('Feedback Now'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FeedbackDialog(
                                                                  name: snapshot
                                                                      .data[index]
                                                                  ['doctor_name'],
                                                                  specialisation: snapshot
                                                                      .data[index]
                                                                  [
                                                                  'specialisation'],
                                                                  doctor_id: snapshot
                                                                      .data[index]
                                                                  ['doctor_id'],
                                                                )));
                                                  }),
                                              const SizedBox(width: 8),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
