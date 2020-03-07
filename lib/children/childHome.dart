import 'package:first/ReportRecoders.dart';
import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/children/addChild.dart';
import 'package:first/children/createAccount.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/home.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:first/const.dart';
import 'package:first/getData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';

final _childHomeFormKey = new GlobalKey<FormState>();

final _childHomeWeight = new GlobalKey<TextBoxState>();
final _childHomeHeight = new GlobalKey<TextBoxState>();

class childHomePage extends StatefulWidget {
  String childId,childName,childAge;

  childHomePage({this.childId,this.childName,this.childAge});

  _childHomeHomePageState createState() => _childHomeHomePageState();
}

class _childHomeHomePageState extends State<childHomePage> {
  String type;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    type = (prefs.getString("Type") ?? '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("My Child"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              if(type=='1'){
                Navigator.push(
                  context,
                  MaterialPageRoute(      
                    builder: (context) => DoctorHomePage(),
                ));
              }
              else if(type=='2'){
                Navigator.push(
                  context,
                  MaterialPageRoute(      
                    builder: (context) => NurseHomePage(),
                ));
              }
              else if(type=='3'){
                Navigator.push(
                  context,
                  MaterialPageRoute(      
                    builder: (context) => OtherServiceHome(),
                ));
              }
              else if(type=='4'){
                Navigator.push(
                  context,
                  MaterialPageRoute(                
                    builder: (context) => PharmacistHome(),
                ));
              }
              else if(type=='5'){
                Navigator.push(
                  context,
                  MaterialPageRoute(      
                    builder: (context) => AmbulanceHome(),
                ));
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(      
                    builder: (context) => HomePage(),
                ));
              }  
            },
          )
        ],
      ),
      
      body: MainConetn(childId: widget.childId, childName: widget.childName,childAge:widget.childAge),
    );
  }
}

class MainConetn extends StatefulWidget {
    String childId,childName,childAge;
    MainConetn({this.childId,this.childName,this.childAge});

  _MainConetnState createState() => _MainConetnState();
}

class _MainConetnState extends State<MainConetn> {
  
  List medicine = [
    ["loading"]
  ];
  List<Widget> widgetList = [];
  List<Widget> newWidgetList = [];
  SharedPreferences prefs;
  Widget bmiWidget;
  double bmi;

  @override
  void initState() {
    super.initState();
    if(widget.childId == null){
       getChildDeatils();
    }
    else{
       initChildDeatils();
    }
    init();
  }

  void initChildDeatils() async{
    print("initChild");
    prefs = await SharedPreferences.getInstance();
    prefs.setString("ChildId", widget.childId);
    prefs.setString("ChildAge", widget.childAge);
    prefs.setString("ChildName", widget.childName);
  }

  void getChildDeatils() async{
    print("getChild");
    widget.childAge ="loading";
    widget.childId ="loading";
    widget.childName = "loading";

    prefs = await SharedPreferences.getInstance();
    setState(() {
     widget.childId = (prefs.getString("ChildId") ?? '0');
     widget.childAge = (prefs.getString("ChildAge") ?? '0');
     widget.childName = (prefs.getString("ChildName") ?? '0'); 
     print(widget.childName);
    });
    
  }

  void init() async {
    
    List takeMedicine;

    print(widget.childId);

    await getMedicine(widget.childId).then((s) {
      takeMedicine = s;
    });

    setState(() {
      medicine = takeMedicine;
    });
    print(medicine);

    returnListTile();

    setState(() {
      newWidgetList = widgetList;
    });

    await calcBmi(widget.childId).then((s) {
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
      content: Container(
          height: 350.0,
          child: Column(
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            Text(
              "Update height and weight",
              style: TextStyle(color: Color(Const.greenColor)),
            ),
            Form(
              key: _childHomeFormKey,
              child: Column(
                children: <Widget>[
                  textBox(
                      textBoxType: 1,
                      key: _childHomeHeight,
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
                      key: _childHomeWeight,
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
      ),
    );

    showDialog(context: context, child: dialog);
  }

  void HieghtWeight() async{

    final from = _childHomeFormKey.currentState;
    bool valid = false;
    
    if (from.validate()) {
      from.save();
      valid = true;
    }

    String response;  
    if (valid == true) {
      
    await updateHieghtWeight(
      widget.childId,
      _childHomeWeight.currentState.textboxValue,
      _childHomeWeight.currentState.textboxValue).then((s) {
      response = s;
      });

    await calcBmi(widget.childId).then((s) {
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
                    
                  ),
                  SizedBox(
                    width: 70.0,
                  ),
                  Container(
                    height: 80.0,
                    width: 180.0,
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
                    widget.childName + "    Age:" + widget.childAge,
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
                              builder: (context) => getData(id: widget.childId,status: "child"),
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
                                  builder: (context) => ReportRecoders(id: widget.childId,status: "child",),
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
                                      color: Color(Const.orngeColor),
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
                                      Text("Create Account",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0)),
                                    ],
                                  ),
                                ),
                              ),

                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => createAccount(),
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
              SizedBox(
                height: 30.0,
              ),
              
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
                        height: 170.0,
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
