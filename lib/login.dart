import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/changePassword.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:first/signin.dart';
import 'package:flutter/material.dart';
import 'package:first/module/textbox.dart';
import 'package:first/home.dart';
import 'package:first/const.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final formKey = new GlobalKey<FormState>();
final userId = new GlobalKey<TextBoxState>();
final password = new GlobalKey<TextBoxState>();

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: LoginContain(),
    );
  }
}

class LoginContain extends StatefulWidget {
  _LoginContainState createState() => _LoginContainState();
}

class _LoginContainState extends State<LoginContain> {
  void _showAlert(String text) {
    AlertDialog dialog = new AlertDialog(
      content: Row(
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );

    showDialog(context: context, child: dialog);
  }

  void _logInOnClick() async {
    final from = formKey.currentState;
    bool valid = false;
    SharedPreferences prefs;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    String response;

    if (valid == true) {
      await dataBaseLogIn(
        userId.currentState.textboxValue,
        password.currentState.textboxValue,
      ).then((s) {
        response = s;
      });

      print("Response" + response);

      if (response == '0') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
      } else if (response == '1') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorHomePage(),
            ));
      } else if (response == '2') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NurseHomePage(),
            ));
      } else if (response == '3') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtherServiceHome(),
            ));
      } else if (response == '4') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PharmacistHome(),
            ));
      } else if (response == '5') {
        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);
        prefs.setString("Type", response);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AmbulanceHome(),
            ));
      } else {
        _showAlert(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFF7D05), width: 8.0),
                borderRadius: BorderRadius.circular(42.0),
                color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: Container(
              height: 101.0,
              width: 315.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/logo.jpeg"),
                ),
                border: Border(
                    bottom: BorderSide(color: Color(0xFFFF7D05), width: 5.0)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 280.0, left: 20.0),
                child: Text("Log in",
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Color(0xFF2A8D00),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 350.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                    child: textBox(
                        textBoxType: 2,
                        key: userId,
                        hintText: "Enter your Nataional ID here...",
                        labelText: "National ID",
                        helpText: "",
                        helperText: "helper text",
                        iconName: Icons.account_circle,
                        prifix: "",
                        suffix: "",
                        maxLength: 10,
                        maxLines: 1,
                        obscureText: false,
                        enable: true,
                        autoCorrect: false,
                        inputType: TextInputType.numberWithOptions(),
                        validationKey: "emptyCheck"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                    child: textBox(
                        textBoxType: 2,
                        key: password,
                        hintText: "Enter your password here...",
                        labelText: "Password",
                        helpText: "",
                        helperText: "helper text",
                        iconName: Icons.lock,
                        prifix: "",
                        suffix: "",
                        maxLength: 20,
                        maxLines: 1,
                        obscureText: true,
                        enable: true,
                        autoCorrect: false,
                        inputType: TextInputType.numberWithOptions(),
                        validationKey: "emptyCheck"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 200, right: 20.0),
                    child: GestureDetector(
                      child: Container(
                        // alignment: Alignment.center,
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        // child: Text("Sign in",
                        //     style:
                        //         TextStyle(fontSize: 20.0, color: Colors.white)),
                        child: ButtonTheme(
                          minWidth: 175.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: const Text('Log in',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            color: Color(Const.greenColor),
                            elevation: 4.0,
                            splashColor: Color(Const.orngeColor),
                            onPressed: () async {
                              _logInOnClick();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        child: Text("forget password",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF2A8D00),
                                decoration: TextDecoration.underline)),
                      ),
                      onTap: () {
                        _showAlert("mail sent");
                        final from = formKey.currentState;
                        bool valid = false;

                        if (from.validate()) {
                          from.save();
                          valid = true;
                        }

                        if (valid == true) {
                          changePassword(userId.currentState.textboxValue);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 2.0),
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        child: Text("Sign In",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color(0xFF2A8D00),
                                decoration: TextDecoration.underline)),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signin(),
                            ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
