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
import 'package:first/settings/changePassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeAddress extends StatefulWidget {
  String type;
  ChangeAddress({this.type});
  _ChangeAddressState createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: MainContain(
        type: widget.type,
      ),
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

  var provinceList = ['Select province', 'Western', 'North western','southern','north central','Sabaragamuwa','Uva','Central','Eastern'];
  var districtList = ['Select District'];
  var cityList = ['Select city'];
  var doctorList = ['Select Doctor', 'VP', 'VOG', 'pediatrician', 'surgeon'];

  var seletedDoctor = 'Select Doctor';
  var selectedProvince = "Select province";
  var selectedDistrict = "Select District";
  var selectedCity = "Select city";
  String name =" ";
  String email =" ";

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

  var errorDisplay = "";

  void _getDistrict() {
    setState(() {
      selectedDistrict = "Select District";
      selectedCity = "Select city";
    });
    if (selectedProvince == "Western") {
      setState(() {
        districtList = Const.wpDistrictList;
      });
    } else if (selectedProvince == "North western") {
      setState(() {
        districtList = Const.nwDistrictList;
      });
    }

    ///TODO add all province
  }

  void _getCity() {
    setState(() {
      selectedDistrict = "Select District";
    });
    if (selectedDistrict == "Puthlam") {
      setState(() {
        cityList = Const.PuththalamaCityList;
      });
    } else if (selectedDistrict == "Kurunegala") {
      setState(() {
        cityList = Const.KurunegalaCityList;
      });
    }

    ///TODO add all district
  }

  void changeAddressBUttonClick() async {
    bool valid = true;

    if( selectedCity == 'Select city'){
      setState(() {
        errorDisplay ="Enter Address";
      });
      valid = false;
    }

    if (valid == true) {
      await updateAddress(
              id,
              selectedProvince,
              selectedDistrict,
              selectedCity)
          .then((s) {
            setState(() {
              errorDisplay = s;
            });
      });


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
          title: Text("Change Address"),
          
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
                  trailing: new Icon(Icons.email),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => new ChangePassword(
                              type: widget.type,
                            )));
                  }),
              new ListTile(
                  title: new Text("Change Email"),
                  trailing: new Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => new ChangeEmail(
                              type: widget.type,
                            )));
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 20.0,
                      ),
                      Container(
                        height: 40.0,
                        child: DropdownButton<String>(
                          items: provinceList.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String selectedItem) {
                            setState(() {
                              selectedProvince = selectedItem;
                              _getDistrict();
                            });
                          },
                          value: selectedProvince,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 20.0,
                      ),
                      Container(
                        height: 40.0,
                        child: DropdownButton<String>(
                          items: districtList.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String selectedItem) {
                            setState(() {
                              selectedDistrict = selectedItem;
                              _getCity();
                            });
                          },
                          value: selectedDistrict,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 20.0,
                      ),
                      Container(
                        height: 40.0,
                        child: DropdownButton<String>(
                          items: cityList.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String selectedItem) {
                            setState(() {
                              selectedCity = selectedItem;
                            });
                          },
                          value: selectedCity,
                        ),
                      ),
                    ],
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
                    child: const Text('Update',
                        style: TextStyle(fontSize: 20.0, color: Colors.white)),
                    color: Color(Const.greenColor),
                    elevation: 4.0,
                    splashColor: Color(Const.orngeColor),
                    onPressed: () {
                       changeAddressBUttonClick();
                    },
                  ),
                )
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
