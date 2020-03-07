import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/children/childHome.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:flutter/material.dart';
import 'package:first/module/textbox.dart';
import 'package:first/module/checkBox.dart';
import 'package:first/home.dart';
import 'package:first/const.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _addChildFormKey = new GlobalKey<FormState>();

final _addChildName = new GlobalKey<TextBoxState>();
final _addChildYear = new GlobalKey<TextBoxState>();
final _addChildMonth = new GlobalKey<TextBoxState>();
final _addChildDate = new GlobalKey<TextBoxState>();
final _addChildHeight = new GlobalKey<TextBoxState>();
final _addChildWeight = new GlobalKey<TextBoxState>();

var selectedBloodGroup = "Select Blood group";

var gender;

var bloodGroups = [
  'Select Blood group',
  'O+',
  'O-',
  'B+',
  'B-',
  'A+',
  'A-',
  'AB+',
  'AB-'
];

class addChild extends StatefulWidget {
  String type;
  addChild({this.type});
  _addChildState createState() => _addChildState();
}

class _addChildState extends State<addChild> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: MainConatain(
        type: widget.type,
      ),
    );
  }
}

class MainConatain extends StatefulWidget {
  String type;
  MainConatain({this.type});
  _MainConatainState createState() => _MainConatainState();
}

class _MainConatainState extends State<MainConatain> {
  int selectedRadio;
  String id;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = (prefs.getString("ID") ?? '0');
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

  SetSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void _signInOnClick() async {
    final from = _addChildFormKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    if (valid == true) {
      if (selectedBloodGroup == "Select Blood group") {
        _showAlert("select a blood group");
        valid = false;
      }
    }

    print(valid);
    String response;
    String birthday = _addChildYear.currentState.textboxValue +
        "-" +
        _addChildMonth.currentState.textboxValue +
        "-" +
        _addChildDate.currentState.textboxValue;

    if (valid == true) {
      await addChildDatabase(
        _addChildName.currentState.textboxValue,
        birthday,
        _addChildWeight.currentState.textboxValue,
        _addChildHeight.currentState.textboxValue,
        gender,
        selectedBloodGroup,
        id,
      ).then((s) {
        response = s;
      });

      print("Response" + response);

      if (response != "Error") {
        var now = new DateTime.now();
        List<String> currentyear = now.toString().split("-");
        int age = int.parse(currentyear[0]) -
            int.parse(_addChildYear.currentState.textboxValue);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => childHomePage(
                  childId: response,
                  childName: _addChildName.currentState.textboxValue,
                  childAge: age.toString()),
            ));
      } else {
        _showAlert(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("Add Child"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              //
              if (widget.type == "doctor") {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new DoctorHomePage()));
              } else if (widget.type == "nurse") {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new NurseHomePage()));
              } else if (widget.type == "otherServices") {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new OtherServiceHome()));
              } else if (widget.type == "pharmacist") {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new PharmacistHome()));
              } else if (widget.type == "ambulance") {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new AmbulanceHome()));
              } else {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new HomePage()));
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 20.0),
                  child: Text("Enter details",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Color(Const.blackColor),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 120.0),
              child: Form(
                key: _addChildFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: _addChildName,
                          hintText: "Enter your name here...",
                          labelText: "Name",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.account_circle,
                          prifix: "",
                          suffix: "",
                          maxLength: 100,
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
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: Text("Date of birth",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: textBox(
                                textBoxType: 1,
                                key: _addChildYear,
                                hintText: "year",
                                labelText: "Year",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "year"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            height: 50.0,
                            width: 55.0,
                            child: textBox(
                                textBoxType: 1,
                                key: _addChildMonth,
                                hintText: "month",
                                labelText: "Month",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 2,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "month"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            height: 50.0,
                            width: 55.0,
                            child: textBox(
                                textBoxType: 1,
                                key: _addChildDate,
                                hintText: "Date",
                                labelText: "Date",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 2,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "day"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 80.0,
                            child: Text("Gender",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 130.0,
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 1,
                                  groupValue: selectedRadio,
                                  // title: Text("Male"),
                                  onChanged: (val) {
                                    SetSelectedRadio(val);
                                    gender = 'm';
                                  },
                                  activeColor: Color(Const.orngeColor),
                                ),
                                Text("Male")
                              ],
                            ),
                          ),
                          Container(
                            height: 50.0,
                            width: 124.0,
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  // title: "Female",
                                  onChanged: (val) {
                                    SetSelectedRadio(val);
                                    gender = 'f';
                                  },
                                  activeColor: Color(Const.orngeColor),
                                ),
                                Text("Female")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: Text("Blood Group",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 230.0,
                            child: DropdownButton<String>(
                              items:
                                  bloodGroups.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String selectedItem) {
                                setState(() {
                                  selectedBloodGroup = selectedItem;
                                });
                              },
                              value: selectedBloodGroup,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                            child: Text("Height",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: textBox(
                                textBoxType: 1,
                                key: _addChildHeight,
                                hintText: "Enter your height here",
                                labelText: "Height",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.arrow_upward,
                                prifix: "",
                                suffix: "cm",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "numberCheck"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                            child: Text("Wieght",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: textBox(
                                textBoxType: 1,
                                key: _addChildWeight,
                                hintText: "Enter your weight here",
                                labelText: "Weight",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.av_timer,
                                prifix: "",
                                suffix: "kg",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "numberCheck"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 200, right: 20.0),
                      child: GestureDetector(
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: ButtonTheme(
                            minWidth: 175.0,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              child: const Text('Done',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              color: Color(Const.greenColor),
                              elevation: 4.0,
                              splashColor: Color(Const.orngeColor),
                              onPressed: () async {
                                _signInOnClick();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
