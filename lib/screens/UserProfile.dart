import 'dart:convert';
import 'package:docoline/screens/drlist_feedback.dart';
import 'package:docoline/screens/pwd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docoline/DatabaseFunctions/FirestoreUpdator.dart';
import 'package:docoline/screens/Feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../AppTheme.dart';
import '../SizeConfig.dart';
import '../constants.dart';
import 'ChangeUserPassword.dart';
import 'ChooseLogin.dart';
import 'DoctorsList.dart';
import 'EditUserProfile.dart';
import 'feedbk.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var user_name;
  var height;
  var weight;
  var age;

  Future<bool> UserProfile() async {
    final spref = await SharedPreferences.getInstance();
    var id = await spref.getString(
      "patient_id",
    );
    //print("iddd   $id");
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_user_view.php'),
        body: {"id": id});
    print(res.body);
    Map data = jsonDecode(res.body);
    print("response data $data");
    if (data['message'] == "Sucessful") {
      print("successfull");
      setState(() {
        user_name = data["patient_name"];
        print(user_name);
        height = data["height"];
        weight = data["weight"];
        age = data["age"];
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    UserProfile();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    MySize().init(context);

    return Scaffold(
        body: Container(
      color: themeData.primaryColor,
      child: ListView(
        padding: Spacing.top(68),
        children: [
          Container(
            padding: Spacing.vertical(24),
            margin: Spacing.fromLTRB(24, 16, 24, 0),
            decoration: BoxDecoration(
              color: themeData.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              border: Border.all(color: themeData.backgroundColor, width: 1.5),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.all(Radius.circular(MySize.size120!)),
                  child: Image(
                    image: AssetImage('assets/images/img.png'),
                    height: MySize.size120,
                    width: MySize.size120,
                  ),
                ),
                Container(
                  margin: Spacing.top(16),
                  child: Text(
                    user_name.toString(),
                    style: AppTheme.getTextStyle(themeData.textTheme.headline5,
                        fontWeight: 600, letterSpacing: 0),
                  ),
                ),
                Container(
                  margin: Spacing.top(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Weight",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1,
                                  color: Colors.black,
                                  muted: true),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: weight.toString(),
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.headline6,
                                          color: Colors.black,
                                          fontWeight: 600)),
                                  TextSpan(
                                      text: " kg",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.headline6,
                                          color: Colors.black,
                                          fontWeight: 500)),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Height",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1,
                                  color: Colors.black,
                                  muted: true),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: height.toString(),
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.headline6,
                                          color: Colors.black,
                                          fontWeight: 600)),
                                  TextSpan(
                                      text: " cm",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.headline6,
                                          color: Colors.black,
                                          fontWeight: 500)),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Age",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1,
                                  color: Colors.black,
                                  muted: true),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: age.toString(),
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.headline6,
                                          color: Colors.black,
                                          fontWeight: 600)),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(20, 10, 24, 0),
            child: ElevatedButton(
              child: Text(
                "Edit Profile",
                style: themeData.textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUserProfileScreen()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(20, 10, 24, 0),
            child: ElevatedButton(
              child: Text(
                "Book New Appointement",
                style: themeData.textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorsListScreen()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(20, 10, 24, 0),
            child: ElevatedButton(
              child: Text(
                "Change Password",
                style: themeData.textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
          Container(
            margin: Spacing.fromLTRB(20, 10, 24, 0),
            child: ElevatedButton(
              child: Text(
                "Logout",
                style: themeData.textTheme.bodyText1,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChooseLogin()));
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ),
          ),
        ],
      ),
    ));
  }
}

//   Widget appointmentWidget(
//       {required String image,
//       required String docName,
//       required String type,
//       required String time,
//       Color? clockColor}) {
//     var themeData;
//     return Container(
//       margin: EdgeInsets.all(10),
//       padding: Spacing.fromLTRB(4, 4, 8, 4),
//       decoration: BoxDecoration(
//           color: themeData.backgroundColor,
//           borderRadius: BorderRadius.all(Radius.circular(MySize.size12!)),
//           boxShadow: [
//             BoxShadow(
//                 color: themeData.primaryColor,
//                 blurRadius: MySize.size6!,
//                 offset: Offset(0, MySize.size4!))
//           ]),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(MySize.size12!)),
//             child: Image(
//               image: AssetImage(image),
//               width: MySize.size72,
//               height: MySize.size72,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: MySize.size72,
//               margin: Spacing.left(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     docName,
//                     style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
//                         color: Colors.black, fontWeight: 600),
//                   ),
//                   Text(
//                     type,
//                     style: AppTheme.getTextStyle(themeData.textTheme.caption,
//                         color: Colors.black26, fontWeight: 500, xMuted: true),
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Icon(
//                           MdiIcons.clock,
//                           size: MySize.size16,
//                           color: clockColor,
//                         ),
//                         Container(
//                           margin: Spacing.left(4),
//                           child: Text(
//                             time,
//                             style: AppTheme.getTextStyle(
//                                 themeData.textTheme.caption,
//                                 muted: true,
//                                 fontWeight: 600,
//                                 color: Colors.black),
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
