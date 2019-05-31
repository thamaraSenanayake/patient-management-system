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
import 'package:first/settings/changeAddress.dart';
import 'package:first/settings/changePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = new GlobalKey<FormState>();
final _email = new GlobalKey<TextBoxState>();

class ChangeEmail extends StatefulWidget {
  String type;
  ChangeEmail({this.type});
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
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
  String addedPatientRecordId;
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

  void changeEmailBUttonClick() async {
    final from = _formKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    if (valid == true) {
      await updateEmail(
              id,
              _email.currentState.textboxValue,)
          .then((s) {
            setState(() {
              errorDisplay = s;
            });
      });

      if(addedPatientRecordId == 'DONE!'){
        print("done");
        Navigator.push(
        context,
        MaterialPageRoute(
           //builder: (context) => DoctorHomePage(),
           builder: (context) => OtherServiceSearch(),
          // builder: (context) => NurseHomePage(),
        ));
      }
      else{
        showTopShortToast("Error");
      }

      print(addedPatientRecordId);

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
          title: Text("Add Email"),
          
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
                  title: new Text("Change Password"),
                  trailing: new Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ChangePassword(type: widget.type,)));
                    
                  }),
              new ListTile(
                  title: new Text("Change Address"),
                  trailing: new Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangeAddress(type: widget.type)));
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
                            key: _email,
                            hintText: "Enter new email address here...",
                            labelText: "Email",
                            helpText: "",
                            helperText: "helper text",
                            iconName: Icons.email,
                            prifix: "",
                            suffix: "",
                            maxLength: 20,
                            maxLines: 1,
                            obscureText: false,
                            enable: true,
                            autoCorrect: false,
                            inputType: TextInputType.text,
                            validationKey: "emailCheck"),
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
                            child: const Text('Add',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white)),
                            color: Color(Const.greenColor),
                            elevation: 4.0,
                            splashColor: Color(Const.orngeColor),
                            onPressed: () async {
                              changeEmailBUttonClick();
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
