import 'dart:convert';

import 'package:docoline/SizeConfig.dart';
import 'package:docoline/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppTheme.dart';

class FeedBackView extends StatefulWidget {
  const FeedBackView({Key? key}) : super(key: key);

  @override
  State<FeedBackView> createState() => _FeedBackViewState();
}

class _FeedBackViewState extends State<FeedBackView> {
  late ThemeData themeData;
  void initState() {
    ViewFeedback();
    super.initState();
  }

  var patient_name;
  dynamic content;
  dynamic data;

  Future<dynamic> ViewFeedback() async {
    final spref = await SharedPreferences.getInstance();
    var id = await spref.getString(
      "doctor_id",
    );
    print("doctor id    $id");
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_feedbackView.php'),
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

  @override
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
            padding: const EdgeInsets.only(top: 1),
            child: Container(
              child: Text(
                "Feedback",
                style: AppTheme.getTextStyle(themeData.textTheme.headline5,
                    color: themeData.colorScheme.primaryVariant,
                    fontWeight: 600),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: ViewFeedback(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Image(
                      image: AssetImage('assets/images/Loading123.gif'),
                      height: MySize.size180,
                    );
                  } else {
                    return ListView.builder(
                        itemCount: data.length,
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
                                      title: Text(snapshot.data[index]
                                              ['patient_name']
                                          .toString(),style: TextStyle(fontSize: 20,color: Colors.blue),),
                                      subtitle: Text(snapshot.data[index]
                                              ['content']
                                          .toString(),style: TextStyle(fontSize: 15),),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: <Widget>[
                                    //     const SizedBox(width: 5),
                                    //   ],
                                    // ),
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
