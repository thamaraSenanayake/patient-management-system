import 'package:first/ReportRecoders.dart';
import 'package:first/addAmbulance.dart';
import 'package:first/children/addChild.dart';
import 'package:first/children/childrenList.dart';
import 'package:first/otherService/otherServiceSearch.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:first/const.dart';
import 'package:first/getData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';
import 'package:first/main.dart';
import 'package:first/settings/changeAddress.dart';
import 'package:first/settings/changeDp.dart';
import 'package:first/settings/changeEmail.dart';
import 'package:first/settings/changePassword.dart';

final formKey = new GlobalKey<FormState>();

final weight = new GlobalKey<TextBoxState>();
final height = new GlobalKey<TextBoxState>();

class OtherServiceHome extends StatefulWidget {
  _OtherServiceHomeState createState() => _OtherServiceHomeState();
}

class _OtherServiceHomeState extends State<OtherServiceHome> {
  String name=" ";
  String email=" ";

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString("ID") ?? '0');
    List userDeatils;
    await getUserDetails(id).then((s) {
      userDeatils = s;
    });

    setState(() {
      name = userDeatils[0]['name'];
      email = userDeatils[0]['email'];
    });
  }


  void logOut() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("ID", '0');
   prefs.setString("Type", '0');
   Navigator.of(context).pop();
   Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new home()));
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
                  fit: BoxFit.fill
                )
              ),
            ),
            new ListTile(
              title: new Text("Change Password"),
              trailing: new Icon(Icons.lock_open),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ChangePassword(type: "otherServices",)));
              }
            ),
            new ListTile(
              title: new Text("Change Email"),
              trailing: new Icon(Icons.email),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ChangeEmail(type: "otherServices",)));
              }
            ),
            new ListTile(
              title: new Text("Change Address"),
              trailing: new Icon(Icons.home),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangeAddress(type: "otherServices",)));
              }
            ),
            new ListTile(
              title: new Text("Change Profile Pic"),
              trailing: new Icon(Icons.image),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ChangeDp(type: "otherServices",)));
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Log out"),
              trailing: new Icon(Icons.phonelink_off),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      ),
      body: MainConetn(),
    );
  }
}

class MainConetn extends StatefulWidget {
  _MainConetnState createState() => _MainConetnState();
}

class _MainConetnState extends State<MainConetn> {
  static const myData = [
    ["Jan", "10"],
    ["Feb", "20"],
    ["Mar", "30"],
    ["Apr", "10"],
    ["May", "50"],
    ["Jun", "20"],
    ["Jul", "70"],
  ];
  static const myData1 = [
    ["Jan", "20"],
    ["Feb", "30"],
    ["Mar", "20"],
    ["Apr", "40"],
    ["May", "70"],
    ["Jun", "10"],
    ["Jul", "30"],
  ];

  String id;
  String name = "null";
  String age = "0";
  List medicine = [
    ["loading"]
  ];
  List<Widget> widgetList = [];
  List<Widget> newWidgetList = [];
  Widget bmiWidget;
  double bmi;
  var profilePIcLocation = "http://"+Const.ip+"/eMedicine/uploads/man.png";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = (prefs.getString("ID") ?? '0');
    List userDeatils;
    List takeMedicine;

    await getUserDetails(id).then((s) {
      userDeatils = s;
    });

    setState(() {
      name = userDeatils[0]['name'];
      age = userDeatils[0]['age'];

      if(userDeatils[0]['profilePic'] == '0'){
        if(userDeatils[0]['gender'] == 'f'){
          setState(() {
            profilePIcLocation = "http://"+Const.ip+"/eMedicine/uploads/girl.png";
          });
        }  
      }
      else{
        profilePIcLocation = "http://"+Const.ip+"/eMedicine/uploads/"+userDeatils[0]['profilePic']+"";
      }
    });

    await getMedicine(id).then((s) {
      takeMedicine = s;
    });

    setState(() {
      medicine = takeMedicine;
    });

    returnListTile();

    setState(() {
      newWidgetList = widgetList;
    });

    await calcBmi(id).then((s) {
      setState(() {
        bmi = s;
      });
    });

    print(bmi);
    returnBmiWidget();
  }

  void returnListTile() {
    for (var i = 0; i < medicine.length; i++) {
      String time;
      String afterBefore;

      if (medicine[i]['time'] == '1') {
        time = "Morning";
      } else if (medicine[i]['time'] == '2') {
        time = "noon";
      } else if (medicine[i]['time'] == '3') {
        time = "Night";
      }

      if (medicine[i]['after_before'] == '1') {
        afterBefore = "after";
      }

      if (medicine[i]['after_before'] == '2') {
        afterBefore = "before";
      }

      widgetList.add(ListTile(
        title: Text('take ' +
            medicine[i]['count'] +
            ' ' +
            medicine[i]['medicine'] +
            '   take it at ' +
            time.toString()),
        subtitle: Text(afterBefore.toString() + ' having your meal'),
      ));
    }
  }

  void returnBmiWidget() {
    String text;
    Color colorBorder;
    IconData containerIcon;
    if (bmi < 18.5) {
      text = "you need to eat healthy food more to incress your health";
      colorBorder = Colors.blueAccent;
      containerIcon = Icons.fastfood;
    } else if (bmi < 24.9) {
      text = "you have good healthy weight for your height keep main tain it";
      colorBorder = Colors.greenAccent;
      containerIcon = Icons.favorite;
    } else if (bmi < 29.9) {
      text = "Try to do excrise daily and reduce your weight";
      colorBorder = Colors.orangeAccent;
      containerIcon = Icons.directions_run;
    } else if (bmi > 30.0) {
      text =
          "You should controll your foods and do excerice daily to reduce your weight";
      colorBorder = Colors.redAccent;
      containerIcon = Icons.warning;
    }

    bmiWidget = Container(
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: colorBorder, width: 4.0),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            containerIcon,
            color: Colors.black,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: const Text('Update',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: colorBorder,
                elevation: 4.0,
                splashColor: Color(Const.orngeColor),
                onPressed: () {
                  _showAlert();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showAlert() {
    AlertDialog dialog = new AlertDialog(
      content: Column(
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Update height and weight",
            style: TextStyle(color: Color(Const.greenColor)),
          ),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                textBox(
                    textBoxType: 1,
                    key: height,
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
                SizedBox(
                  height: 10.0,
                ),
                textBox(
                    textBoxType: 1,
                    key: weight,
                    hintText: "Enter your weight here",
                    labelText: "Weight",
                    helpText: "",
                    helperText: "helper text",
                    iconName: Icons.arrow_upward,
                    prifix: "",
                    suffix: "kg",
                    maxLength: 4,
                    maxLines: 1,
                    obscureText: false,
                    enable: true,
                    autoCorrect: false,
                    inputType: TextInputType.numberWithOptions(),
                    validationKey: "numberCheck"),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: const Text('Update',
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                  color: Color(Const.greenColor),
                  elevation: 4.0,
                  splashColor: Color(Const.orngeColor),
                  onPressed: () async {
                    HieghtWeight();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    showDialog(context: context, child: dialog);
  }

  void HieghtWeight() async{

    final from = formKey.currentState;
    bool valid = false;
    
    if (from.validate()) {
      from.save();
      valid = true;
    }

    String response;  
    if (valid == true) {
      
    await updateHieghtWeight(
      id,
      height.currentState.textboxValue,
      weight.currentState.textboxValue).then((s) {
      response = s;
      });

    await calcBmi(id).then((s) {
      setState(() {
        bmi = s;
      });
    });

    print(bmi);
    returnBmiWidget();
    

    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
              child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                          image: NetworkImage(profilePIcLocation),
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 70.0,
                  ),
                  Container(
                    height: 80.0,
                    width: 210.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/logo.jpeg"),
                      ),
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFFF7D05), width: 5.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                        color: Color(Const.blackColor), fontSize: 30.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Age:" + age,
                    style: TextStyle(
                        color: Color(Const.blackColor), fontSize: 30.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Container(
                            height: 100.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.red),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.book,
                                  color: Colors.white,
                                ),
                                Text(
                                  "My Clinic Book",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => getData(id: id,status: 'otherServices',),
                            ))),
                  ),
                  Expanded(
                    child: Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2.5, right: 2.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.table_chart,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Report",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0)),
                                    ],
                                  ),
                                ),
                              ),
                              
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportRecoders(id: id,status: 'otherServices',),
                                )
                              )

                            ),
                          ),
                          Expanded(
                            child:GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.5, right: 2.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.notifications_active,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Ambulance",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () {
                                showDialog(context: context, child:  AddAmbulance(id: id,));
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child:GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 2.5, left: 2.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.child_friendly,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Add Child",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0)),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => addChild(type: 'otherServices',),
                                )
                              )

                            ),
                          ),
                          Expanded(
                            child:GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.5, left: 2.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.child_care,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("View Child",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0)),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => childrenList(id: id),
                                )
                              )

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Expanded(
                            child:GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.5, left: 2.5),
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      color: Color(Const.orngeColor),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.child_care,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Health Service(Carrer)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtherServiceSearch(),
                                )
                              )

                            ),
                          ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Container(
              //         height: 300,
              //         child: LineChart(
              //           lines: [
              //             Line<List<String>, String, String>(
              //               data: myData,
              //               xFn: (datum) => datum[0],
              //               yFn: (datum) => datum[1],
              //               marker: const MarkerOptions(
              //                 paint:
              //                     const PaintOptions.fill(color: Colors.green),
              //               ),
              //               stroke:
              //                   const PaintOptions.stroke(color: Colors.green),
              //               legend: new LegendItem(
              //                 paint:
              //                     const PaintOptions.fill(color: Colors.green),
              //                 text: 'My BMI',
              //               ),
              //             ),
              //             Line<List<String>, String, String>(
              //               data: myData1,
              //               xFn: (datum) => datum[0],
              //               yFn: (datum) => datum[1],
              //               marker: const MarkerOptions(
              //                 paint:
              //                     const PaintOptions.fill(color: Colors.orange),
              //               ),
              //               stroke:
              //                   const PaintOptions.stroke(color: Colors.orange),
              //               legend: new LegendItem(
              //                 paint:
              //                     const PaintOptions.fill(color: Colors.orange),
              //                 text: 'Right BMI',
              //               ),
              //             ),
              //           ],

              //           // chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Medicines you want to take today",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 2.0, left: 40.0, right: 40.0),
                      child: Container(
                        height: 200.0,
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            children: newWidgetList),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 1.0, right: 1.0),
                      child: Container(
                        height: 150.0,
                        child: bmiWidget,
                      ),
                    ),
                  ),
                ],
              ),

              
            ],
          )),
        ),
      ],
    );
  }
}
