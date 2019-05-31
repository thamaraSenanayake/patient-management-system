import 'package:first/Const.dart';
import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/database.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/doctor/doctorPage.dart';
import 'package:first/home.dart';
import 'package:first/module/textbox.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/otherService/otherServiceSearch.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:first/settings/changeEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = new GlobalKey<FormState>();
final _currentPassword = new GlobalKey<TextBoxState>();
final _newPassword = new GlobalKey<TextBoxState>();
final _confirmNewPassword = new GlobalKey<TextBoxState>();

class ChangePassword extends StatefulWidget {
  String type;
  ChangePassword({this.type});
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: MainContain(type: widget.type,),
    );
  }
}

class MainContain extends StatefulWidget {
  String type;
  MainContain({this.type});
  _MainContainState createState() => _MainContainState();
}

class _MainContainState extends State<MainContain> {
  String id;
  String responce;
  var errorDisplay ="";
  String name=" ";
  String email=" ";
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = (prefs.getString("ID") ?? '0');

    List userDeatils;
    await getUserDetails(id).then((s) {
      userDeatils = s;
    });

    setState(() {
      name = userDeatils[0]['name'];
      email = userDeatils[0]['email'];
    });
  }

  void changePasswordButtonClick() async {
    final from = _formKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }
    
    

    if (valid == true) {
      if(_confirmNewPassword.currentState.textboxValue ==_newPassword.currentState.textboxValue){
        await updatePassword(
                id,
                _currentPassword.currentState.textboxValue,
                _newPassword.currentState.textboxValue,)
            .then((s) {
              setState(() {
                errorDisplay = s;
              });
        });
      }
      else{
        setState(() {
          errorDisplay = "Password dosent match";
        });
      }

      

    }
  }

  void showTopShortToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Color(0xFFF5F5F5),
      textColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(Const.orngeColor),
          title: Text("Add Password"),
          
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountEmail: new Text(name),
                accountName: new Text(email),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new NetworkImage("http://"+Const.ip+"/eMedicine/uploads/cover.jpg"),
                        fit: BoxFit.fill)),
              ),
              new ListTile(
                  title: new Text("Home"),
                  trailing: new Icon(Icons.home),
                  onTap: () {
                    print(widget.type);
                    if(widget.type =="doctor"){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new DoctorHomePage()));
                    }
                    else if(widget.type =="nurse"){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new NurseHomePage()));
                    }
                    else if(widget.type =="otherServices"){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new OtherServiceHome()));
                    }
                    else if(widget.type =="pharmacist"){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new PharmacistHome()));
                    }
                    else if(widget.type =="ambulance"){
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new AmbulanceHome()));
                    }
                    else{
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new HomePage()));
                    }
                  }),
              new ListTile(
                  title: new Text("Change Email"),
                  trailing: new Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ChangeEmail(type: widget.type,)));
                  }),
              new ListTile(
                  title: new Text("Change Address"),
                  trailing: new Icon(Icons.home),
                  onTap: () {
                    // Navigator.of(context).pop();
                    // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                  }),
              new Divider(),
              new ListTile(
                title: new Text("Log out"),
                trailing: new Icon(Icons.phonelink_off),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Padding(
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: textBox(
                            textBoxType: 2,
                            key: _currentPassword,
                            hintText: "Enter current password here...",
                            labelText: "current Password",
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
                            inputType: TextInputType.text,
                            validationKey: "emptyCheck"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: textBox(
                            textBoxType: 2,
                            key: _newPassword,
                            hintText: "Enter new password here...",
                            labelText: "new password",
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
                            inputType: TextInputType.text,
                            validationKey: "emptyCheck"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: textBox(
                            textBoxType: 2,
                            key: _confirmNewPassword,
                            hintText: "Enter Re-Enter New Password here...",
                            labelText: "Confirm Password",
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
                            inputType: TextInputType.text,
                            validationKey: "emptyCheck"),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          errorDisplay,
                          style:
                              TextStyle(color: Colors.red, fontSize: 18.0),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 220),
                        child: ButtonTheme(
                          minWidth: 150.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: const Text('Update',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            color: Color(Const.greenColor),
                            elevation: 4.0,
                            splashColor: Color(Const.orngeColor),
                            onPressed: () async {
                              changePasswordButtonClick();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        }));
  }

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
}
