import 'package:first/ReportRecoders.dart';
import 'package:first/children/addChild.dart';
import 'package:first/children/childrenList.dart';
import 'package:first/doctor/addRecord.dart';
import 'package:first/doctor/addSerivce.dart';
import 'package:first/doctor/adddoctor.dart';
import 'package:first/doctor/doctorPage.dart';
import 'package:first/doctor/editMedicine.dart';
import 'package:first/doctor/markAsDead.dart';
import 'package:first/doctor/patientAdimt.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:first/const.dart';
import 'package:first/getData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';


final _formKey = new GlobalKey<FormState>();
final _des = new GlobalKey<TextBoxState>();


class PatientPage extends StatefulWidget {
  String id;
  PatientPage({this.id});
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("Patient page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => doctorPage(),
                  ));
            },
          )
        ],
      ),
      body: MainConetn(id: widget.id),
    );
  }
}

class MainConetn extends StatefulWidget {
  String id;
  MainConetn({this.id});
  _MainConetnState createState() => _MainConetnState();
}

class _MainConetnState extends State<MainConetn> {
  String name = "null";
  String age = "0";
  String bloodGroup;
  String gender;
  String height;
  String weight;
  String doctorId;

  String admitStateWord = "Admit";
  int admitStaetColor = 0xFFFFAB40;
  bool admitState = false;

  String assignStateWord = "Add patient";
  int asignStaetColor = 0xFF40CFFF;
  bool asignState = false;


  List medicine = [
    ["loading"]
  ];

  var provinceList = ['Select province', 'Western', 'North western','southern','north central','Sabaragamuwa','Uva','Central','Eastern'];
  var districtList = ['Select District'];
  var cityList = ['Select city'];
  var doctorList = ['Select Doctor','VP','VOG','pediatrician','surgeon'];

  var seletedDoctor = 'Select Doctor';
  var selectedProvince = "Select province";
  var selectedDistrict = "Select District";
  var selectedCity = "Select city";

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
    List userDeatils;
    List takeMedicine;

    await getPatientDetails(widget.id).then((s) {
      userDeatils = s;
    });

    setState(() {
      name = userDeatils[0]['name'];
      age = userDeatils[0]['age'];
      bloodGroup = userDeatils[0]['bloodGroup'];
      gender = userDeatils[0]['gender'];
      height = userDeatils[0]['hight'];
      weight = userDeatils[0]['weight'];

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

    await getMedicine(widget.id).then((s) {
      takeMedicine = s;
    });

    setState(() {
      medicine = takeMedicine;
    });

    returnListTile();

    setState(() {
      newWidgetList = widgetList;
    });

    await calcBmi(widget.id).then((s) {
      setState(() {
        bmi = s;
      });
    });

    print(bmi);
    returnBmiWidget();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    doctorId = (prefs.getString("ID") ?? '0');

    await checkAdmit(widget.id).then((s) {
      setState(() {
        admitState = s;
      });
    });

    if(admitState){
      setState(() {
        admitStaetColor = Const.orngeColor;
        admitStateWord ="Discharge";
      });
    }

    await checkAssign(widget.id,doctorId).then((s) {
      setState(() {
        print(s);
        asignState = s;
      });
    });

    print("assign State");
    print(asignState);
    if(asignState){
      setState(() {
        asignStaetColor = Const.orngeColor;
        assignStateWord ="Remove";
        asignState =true;
      });
    }


  }

  void addOrRemovePatient() async{
    String response;
    await addRemovePatient(widget.id,doctorId).then((s) {
      setState(() {
        response = s;
      });
    });

    if(response == 'Add'){
      setState(() {
        asignStaetColor = 0xFFFFAB40;
        assignStateWord ="Remove";
        asignState =true;
      });
    }

    else if(response == 'Remove'){
      setState(() {
        asignStaetColor = 0xFF40CFFF;
        assignStateWord ="add";
        asignState =true;
      });
    }
  }


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

  void addmitePatient(context) {
    Dialog dialog;
    if(!admitState){
      dialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 300.0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(Const.orngeColor),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Admit report",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
            

              SizedBox(
                height: 60.0,
              ),
              
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),

                  child: textBox(
                    textBoxType: 1,
                    key: _des,
                    hintText: "Enter Admit cause here...",
                    labelText: "Admit cause",
                    helpText: "",
                    helperText: "helper text",
                    iconName: Icons.lock,
                    prifix: "",
                    suffix: "",
                    maxLength: 20,
                    maxLines: 3,
                    obscureText: false,
                    enable: true,
                    autoCorrect: false,
                    inputType: TextInputType.numberWithOptions(),
                    validationKey: "emptyCheck"
                  ),
                          
                ),
              ),


              Padding(
                padding: EdgeInsets.only(left: 144),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: const Text('Admit',
                      style: TextStyle(fontSize: 20.0, color: Colors.white)),
                  color: Color(Const.greenColor),
                  elevation: 4.0,
                  splashColor: Color(Const.orngeColor),
                  onPressed: () {
                    admitButtonClick();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      );
    }

    else{
      dialog = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          height: 250.0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color(Const.orngeColor),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Discharge From Hospital",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left:20.0,top: 10.0),
                child: Text(
                  "Are You sure you want to discharge this Patient",
                  style:
                      TextStyle(color: Color(Const.blackColor), fontSize: 18.0),
                  textAlign: TextAlign.start,
                ),
              ),
            

              SizedBox(
                height: 60.0,
              ),
              
              
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 120),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: const Text('Yes',
                          style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      color: Color(Const.greenColor),
                      elevation: 4.0,
                      splashColor: Color(Const.orngeColor),
                      onPressed: () {
                        dischargeButtonClick();
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      child: const Text('No',
                          style: TextStyle(fontSize: 20.0, color: Colors.white)),
                      color: Colors.orangeAccent,
                      elevation: 4.0,
                      splashColor: Color(Const.orngeColor),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');

                        //  Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),

              
            ],
          ),
        ),
      );
    }

    showDialog(context: context,child: dialog);
  }

  void dischargeButtonClick() async {
    String response;
    await dischargePatient(
                widget.id,
                )
            .then((s) {
          response = s;
    });

    if(response == 'DONE!'){
      setState(() {
        admitStateWord = "Admit";
        admitStaetColor = 0xFFFFAB40;
        admitState = false;    
      });
      
    }

  }
  void admitButtonClick() async {

    if(!admitState){
      final from = _formKey.currentState;
      bool valid = false;

      if (from.validate()) {
        from.save();
        valid = true;
      }

      String response;

      if (valid == true) {
        await admitPatient(
                widget.id,
                doctorId,
                _des.currentState.textboxValue,)
            .then((s) {
          response = s;
        });
      }

      if(response == "DONE!"){
        setState(() {
          admitStaetColor = Const.orngeColor;
          admitStateWord ="Discharge";
          admitState =true;
        });
      }
    }
    
  }


  void returnListTile() {
    print(medicine);
    for (int i = 0; i < medicine.length; i++) {
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

      widgetList.add(Card(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          title: Text('take ' +
              medicine[i]['count'] +
              ' ' +
              medicine[i]['medicine'] +
              '   take it at ' +
              time.toString()),
          subtitle: Text(afterBefore.toString() + ' having your meal'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => editMedicine(
                          list: medicine,
                          index: i,
                          patientID: widget.id,
                        ),
                  ));
            },
          ),
        ),
      )
    );
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
        ],
      ),
    );
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
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Blood group " + bloodGroup + "    Gender:" + gender,
                    style: TextStyle(
                        color: Color(Const.blackColor), fontSize: 20.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "height " + height + "cm    Weight:" + weight+"kg",
                    style: TextStyle(
                        color: Color(Const.blackColor), fontSize: 20.0),
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
                                color: Colors.redAccent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.note_add,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Add Record",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecord(
                                    patientID: widget.id,
                                  ),
                            ))),
                  ),
                  Expanded(
                    child: Container(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 2.5, right: 2.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.book,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("Clinic Book",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          getData(id: widget.id,status: 'Doctor',),
                                    ))),
                          ),
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 2.5, right: 2.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(Const.orngeColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportRecoders(id:widget.id,status: "Doctor",),
                                    ))),
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
                            child: GestureDetector(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 2.5, left: 2.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(asignStaetColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.person_add,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(assignStateWord,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  addOrRemovePatient();
                                }
                              ),
                          ),
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5, left: 2.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("Mark as dead",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                 showDialog(context: context, child:  MarkAsDead(patientId: widget.id,));
                                }
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
                    child: Container(
                      height: 50.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5, left: 2.5),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Color(Const.greenColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("Add doctor",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(context: context, child:  addDoctor(patientId: widget.id,));
                                 
                                }),
                          ),
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5, left: 2.5),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Color(Const.orngeColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text("Investigation",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  showDialog(context: context, child:  addSerivce(patientId: widget.id,));
                                }
                              ),
                          ),
                          Expanded(
                            child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 2.5, left: 2.5),
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                        color: Color(admitStaetColor),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.local_hospital,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(admitStateWord,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0)),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  // showDialog(context: context, child:  addmitePatient());
                                  addmitePatient(context);
                                }),
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Medicines patient want to take today",
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
                          EdgeInsets.only(top: 2.0, left: 20.0, right: 20.0),
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
