import 'dart:convert';

import 'package:docoline/DatabaseFunctions/FirestoreUpdator.dart';
import 'package:docoline/Model/DoctorRequest.dart';
import 'package:docoline/Model/UserRequest.dart';
import 'package:docoline/screens/AppmntView.dart';
import 'package:docoline/screens/Appointment.dart';
import 'package:docoline/screens/Change_dr_pwd_Screen.dart';
import 'package:docoline/screens/ChooseLogin.dart';
import 'package:docoline/screens/EditDoctorProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppTheme.dart';
import '../SizeConfig.dart';
import '../constants.dart';
import 'EditUserProfile.dart';
import 'apmnt.dart';
import 'feedbackView.dart';

class DoctorProfileScreen extends StatefulWidget {
  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late ThemeData themeData;
  TextEditingController controllerdoctor_id = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllermobile = TextEditingController();
  TextEditingController controlleremail = TextEditingController();
  TextEditingController controllerspecialisation = TextEditingController();
  var doctor_name;
  var address;
  var mobile_no;
  var specialisation;
  var email;

  @override
  void initState() {
    DoctorProfile();
    super.initState();
  }

  Future<bool> DoctorProfile() async {
    final spref = await SharedPreferences.getInstance();
    var id = await spref.getString(
      "doctor_id",
    );
    print("iddd   $id");
    Response res = await post(
        Uri.parse(Constants.baseUrl + 'api_doctor_view.php'),
        body: {"id": id});
    print(res.body);
    Map data = jsonDecode(res.body);
    print("response data is $data");
    if (data['message'] == "Sucessful") {
      print("successfull");
      setState(() {
        doctor_name = data["doctor_name"];
        print(doctor_name);
        address = data["address"];
        specialisation = data["specialisation"];
        mobile_no = data["mobile_no"];
        email = data["email"];
      });
      return true;
    } else {
      return false;
    }
  }

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);

    return Scaffold(
        body: Container(
      color: themeData.bottomAppBarColor,
      child: ListView(
        padding: Spacing.top(20),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text('Back'),
                onPressed: () => Navigator.of(context).pop(),
                // icon: Icon(
                //   MdiIcons.chevronLeft,
                //   color: themeData.colorScheme.primary,
                // ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            margin: Spacing.fromLTRB(24, 16, 24, 0),
            decoration: BoxDecoration(
              color: themeData.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              border: Border.all(color: themeData.backgroundColor, width: 1.5),
            ),
            child: Column(
              children: [
                // Image(
                //   image: AssetImage('assets/images/dr1.jpg'),
                //   height: MySize.size120,
                //   width: MySize.size120,
                // ),
                Container(
                  margin: Spacing.top(16),
                  child: Text(
                    doctor_name.toString(),
                    style: AppTheme.getTextStyle(themeData.textTheme.headline5,
                        fontWeight: 600, letterSpacing: 0),
                  ),
                ),
                Container(
                  margin: Spacing.top(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Specialisation :",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                fontWeight: 600,
                                letterSpacing: 2),
                          ),
                          Text(
                            specialisation.toString(),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                fontWeight: 300,
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.size10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Adress :",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                fontWeight: 600,
                                letterSpacing: 2),
                          ),
                          Text(
                            address.toString(),
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.subtitle2,
                                fontWeight: 300,
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Mobile No :",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: 600,
                                  letterSpacing: 2),
                            ),
                            Text(
                              mobile_no.toString(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: 300,
                                  letterSpacing: 0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Email:",
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: 600,
                                  letterSpacing: 2),
                            ),
                            Text(
                              email.toString(),
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2,
                                  fontWeight: 300,
                                  letterSpacing: 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                //margin: Spacing.fromLTRB(20, 10, 24, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Edit Profile",
                      style: themeData.textTheme.bodyText1,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditDoctorProfileScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.lightBlue,
                        elevation: 10),
                  ),
                ),
              ),
              Container(
                //margin: Spacing.fromLTRB(20, 10, 24, 0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Change Password",
                      style: themeData.textTheme.bodyText1,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeDoctorPasswordScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shadowColor: Colors.lightBlue,
                        elevation: 10),
                  ),
                ),
              ),
              Container(
                //margin: Spacing.fromLTRB(20, 10, 24, 0),
                child: ElevatedButton(
                  child: Text(
                    "Logout",
                    style: themeData.textTheme.bodyText1,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChooseLogin()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: Colors.lightBlue,
                      elevation: 10),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
               // margin: Spacing.fromLTRB(24, 36, 24, 0),
                child: InkWell(
                  child: ElevatedButton(
                    child: Text("APPOINTMENT VIEW",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewApp()));
                    },
                  ),
                ),
              ),
              Container(
                //margin: Spacing.fromLTRB(24, 36, 24, 0),
                child: InkWell(
                  child: ElevatedButton(
                    child: Text("FEEDBACK VIEW",
                        style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedBackView()));
                    },
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    ));
  }
}
