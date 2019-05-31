import 'package:first/Const.dart';
import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/database.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/home.dart';
import 'package:first/module/ImageUploader.dart';
import 'package:first/module/textbox.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:first/settings/changeAddress.dart';
import 'package:first/settings/changeEmail.dart';
import 'package:first/settings/changePassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final key = new GlobalKey<ImageUploaderState>();

class ChangeDp extends StatefulWidget {
  String type;
  ChangeDp({this.type});
  _ChangeDpState createState() => _ChangeDpState();
}

class _ChangeDpState extends State<ChangeDp> {
  String errorDisplay = "";
  String name;
  String email;
  String id;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init()async{
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(title: new Text("eMedicine"), backgroundColor: Color(Const.orngeColor),),
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
                    if (widget.type == "doctor") {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new DoctorHomePage()));
                    } else if (widget.type == "nurse") {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new NurseHomePage()));
                    } else if (widget.type == "otherServices") {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new OtherServiceHome()));
                    } else if (widget.type == "pharmacist") {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PharmacistHome()));
                    } else if (widget.type == "ambulance") {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new AmbulanceHome()));
                    } else {
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new HomePage()));
                    }
                  }),
            new ListTile(
                title: new Text("Change Password"),
                trailing: new Icon(Icons.lock_open),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new ChangePassword(
                            type: widget.type,
                          )));
                }),
            new ListTile(
                title: new Text("Change Email"),
                trailing: new Icon(Icons.email),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => new ChangeEmail(
                            type: widget.type,
                          )));
                }),
            new ListTile(
                title: new Text("Change Address"),
                trailing: new Icon(Icons.home),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new ChangeAddress(
                            type: widget.type,
                          )));
                }),
           
            new Divider(),
            new ListTile(
              title: new Text("Log out"),
              trailing: new Icon(Icons.phonelink_off),
              onTap: () {
               // logOut();
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: 250.0,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Row(
              children: <Widget>[
                
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: ImageUploader(
                key: key,
                text: "select pic",
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                errorDisplay,
                style: TextStyle(color: Colors.red, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 144),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: const Text('Add',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Color(Const.greenColor),
                elevation: 4.0,
                splashColor: Color(Const.orngeColor),
                onPressed: () {
                  bool post = true;
                  print("key " + key.currentState.image.toString());
                  if (key.currentState.image.toString() ==
                      "no image selected") {
                    key.currentState.errorDisplay();
                    post = false;
                    setState(() {
                      errorDisplay="Select a image";
                    });
                  }

                  if (post == true) {
                    setState(() {
                      errorDisplay="Done!";
                      
                    });
                    key.currentState.postData();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
