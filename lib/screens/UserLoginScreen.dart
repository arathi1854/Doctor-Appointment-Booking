import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:docoline/SizeConfig.dart';
import 'package:docoline/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../AppTheme.dart';
import '../SizeConfig.dart';
import 'package:docoline/screens/UserProfile.dart';
import 'RegistrationSreenUser.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool? _passwordVisible = false, _check = false;
  late ThemeData themeData;
  late TextEditingController controllerloginId;
  late TextEditingController controlleremail;

  late TextEditingController controllerpassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controlleremail = TextEditingController();
    controllerpassword = TextEditingController();
    super.initState();
  }
  Future<bool> login() async {
    print("api called");
    Response res = await post(Uri.parse(Constants.baseUrl + 'api_login.php'),
        body: {
          'email': controlleremail.text,
          'password': controllerpassword.text
        });
    Map data = jsonDecode(res.body);
    print(data);
    if (data['message'] == "Sucessful") {
      final spref = await SharedPreferences.getInstance();
      await spref.setString("patient_id", data['patient_id'].toString());
      final spref1 = await SharedPreferences.getInstance();
      await spref1.setString("doctor_id", data['doctor_id'].toString());
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);



    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipPath(
            clipper: _MyCustomClipper(context),
            child: Container(
              alignment: Alignment.center,
              color: themeData.colorScheme.background,
            )),
        Positioned(
          left: 30,
          right: 30,
          top: MediaQuery.of(context).size.height * 0.15,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('./assets/images/dr_img.png'),
                        height: MySize.size180,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 24, top: 0),
                        child: Text(
                          "USER LOGIN",
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.headline6,
                              fontWeight: 600),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: controlleremail,
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    letterSpacing: 0.1,
                                    color: themeData.colorScheme.primaryVariant,
                                    fontWeight: 500),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      letterSpacing: 0.1,
                                      color: themeData.colorScheme.primaryVariant,
                                      fontWeight: 500),
                                  prefixIcon: Icon(MdiIcons.email),

                                ),
                                validator: (value){
                                  {
                                    // Check if this field is empty
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }

                                    // using regular expression
                                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }

                                    // the email is valid
                                    return null;
                                  }
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: TextFormField(
                                  controller: controllerpassword,
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText1,
                                      letterSpacing: 0.1,
                                      color: themeData.colorScheme.primaryVariant,
                                      fontWeight: 500),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: AppTheme.getTextStyle(
                                        themeData.textTheme.subtitle2,
                                        letterSpacing: 0.1,
                                        color:
                                            themeData.colorScheme.primaryVariant,
                                        fontWeight: 500),
                                    prefixIcon: Icon(MdiIcons.lockOutline),
                                    suffixIcon: IconButton(
                                      icon: Icon(_passwordVisible!
                                          ? MdiIcons.eyeOutline
                                          : MdiIcons.eyeOffOutline),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible!;
                                        });
                                      },
                                    ),

                                  ),
                                  obscureText: _passwordVisible!,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeData.colorScheme.primary
                                          .withAlpha(18),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            Spacing.xy(16, 0))),
                                    onPressed: () async {
                                      print("button cliked");
                                      bool b = await login();
                                      bool valid=  _formKey.currentState!.validate();

                                      if(valid){
                                        if (b) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfileScreen()));
                                        }
                                      }
                                    },
                                    child: Text("LOGIN",
                                        style: AppTheme.getTextStyle(
                                            themeData.textTheme.button,
                                            fontWeight: 600,
                                            color:
                                                themeData.colorScheme.onPrimary,
                                            letterSpacing: 0.5))),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignUpScreenUser()));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Don't have an Account? ",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 500)),
                        TextSpan(
                            text: " SignUp",
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText2,
                                fontWeight: 600,
                                color: themeData.colorScheme.primary)),
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 24,
          left: 12,
          child: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: themeData.colorScheme.primaryVariant,
          ),
        )
      ],
    ));
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  final BuildContext _context;

  _MyCustomClipper(this._context);

  @override
  Path getClip(Size size) {
    final path = Path();
    Size size = MediaQuery.of(_context).size;
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(0, size.height * 0.6);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
