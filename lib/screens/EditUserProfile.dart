import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../AppTheme.dart';
import '../SizeConfig.dart';
import '../constants.dart';

class EditUserProfileScreen extends StatefulWidget {
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  bool _passwordVisible = false;
  late ThemeData themeData;
  TextEditingController controllerpatient_id = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllermobile = TextEditingController();
  TextEditingController controlleremail = TextEditingController();
  TextEditingController controlleraddress = TextEditingController();
  TextEditingController controllerheight = TextEditingController();
  TextEditingController controllerweight = TextEditingController();
  TextEditingController controllerage = TextEditingController();

  @override
  void initState() {
    UserProfile();

    super.initState();
  }

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
      print("suceesfull");
      setState(() {
        controllername.text = data["patient_name"];
        // print(user_name);
        controlleremail.text = data["email"];
        controllermobile.text = data["mobile_no"];
        controlleraddress.text = data["address"];
        controllerheight.text = data["height"];
        controllerweight.text = data["weight"];
        controllerage.text = data["age"];
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> EditUser() async {
    final spref = await SharedPreferences.getInstance();
    var id1 = await spref.getString(
      "patient_id",
    );

    print(id1);
    Response res =
        await post(Uri.parse(Constants.baseUrl + 'api_user_edit.php'), body: {
      'patient_id': id1,
      'patient_name': controllername.text,
      'address': controlleraddress.text,
      'mobile_no': controllermobile.text,
      'email': controlleremail.text,
      'height': controllerheight.text,
      'weight': controllerweight.text,
      'age': controllerage.text
    });
    print(res.body);

    var data1 = jsonDecode(res.body);
    if (data1['message'] == "Sucessful") {
      print("updated");
      print(controllername.text);
      // final spref = await SharedPreferences.getInstance();
      // await spref.setString("patient_id", data1['patient_id'].toString());
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              MdiIcons.chevronLeft,
              color: themeData.colorScheme.primary,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: MySize.size24!),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: MySize.size16!),
                    width: MySize.getScaledSizeHeight(140),
                    height: MySize.getScaledSizeHeight(140),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("./assets/images/img.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    bottom: MySize.size12,
                    right: MySize.size8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: themeData.scaffoldBackgroundColor,
                            width: 2,
                            style: BorderStyle.solid),
                        color: themeData.colorScheme.primary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(MySize.size6!),
                        child: Icon(
                          MdiIcons.pencil,
                          size: MySize.size20,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Text(controllername.text,
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      fontWeight: 600, letterSpacing: 0)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: MySize.size36!, left: MySize.size24!, right: MySize.size24!),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.accountOutline,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  controller: controllername,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Address",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.email,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  controller: controlleraddress,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Mobile",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.phoneOutline,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllermobile,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.emailAlert,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  controller: controlleremail,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Height",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.humanMaleHeight,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerheight,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Weight",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.humanMale,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerweight,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size16!),
                child: TextFormField(
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      letterSpacing: 0.1,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 400),
                  decoration: InputDecoration(
                    hintText: "Age",
                    hintStyle: AppTheme.getTextStyle(
                        themeData.textTheme.headline6,
                        letterSpacing: 0.1,
                        color: themeData.colorScheme.onBackground,
                        fontWeight: 400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: themeData.colorScheme.background,
                    prefixIcon: Icon(
                      MdiIcons.humanMaleBoy,
                    ),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controllerage,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MySize.size24!),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(MySize.size8!)),
                  boxShadow: [
                    BoxShadow(
                      color: themeData.colorScheme.primary.withAlpha(20),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(Spacing.xy(16, 0))),
                  onPressed: () async {
                    await EditUser();
                    Navigator.pop(context);
                  },
                  child: Text("UPDATE",
                      style: AppTheme.getTextStyle(themeData.textTheme.button,
                          fontWeight: 600,
                          color: themeData.colorScheme.onPrimary,
                          letterSpacing: 0.3)),

                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
