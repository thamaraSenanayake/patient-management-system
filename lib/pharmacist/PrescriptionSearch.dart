
import 'package:first/database.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:first/nurse/nurseGetPatientMedicine.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/addReport.dart';
import 'package:first/otherService/descripstionDisplay.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:first/pharmacist/getPrescription.dart';
import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/module/textbox.dart';

final _patientSerchFormKey = new GlobalKey<FormState>();


final _serchKey = new GlobalKey<TextBoxState>();

class PrescriptionSearch extends StatefulWidget {
  _PrescriptionSearchSearchState createState() => _PrescriptionSearchSearchState();
}

class _PrescriptionSearchSearchState extends State<PrescriptionSearch> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Serch Prescriptions"),
        backgroundColor: Color(Const.orngeColor),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacistHome(),
                  ));  
                            
            },
          )
        ],
      ),
      body: MainConetn(),
    );
  }
}

class MainConetn extends StatefulWidget {
  _MainConetnState createState() => _MainConetnState();
}

class _MainConetnState extends State<MainConetn> {
  

  String id;
  String name = "null";
  String age = "0";
  List patients = [
    [""]
  ];
  List<Widget> widgetList = [];
  List<Widget> newWidgetList = [];
  Widget bmiWidget;
  double bmi;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = (prefs.getString("ID") ?? '0');
    print(id);

    await giveMedicinePharmasist(id).then((s) {
      setState(() {
        patients = s;
        returnListTile();
      });
    });

    

      
  }

  void search() async{
    print("search");


    final from = _patientSerchFormKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    if (valid == true) {
      setState(() {
        patients = [{id: 0, name: "name"}];
      });
      await searchMedicinePharmasist(id,_serchKey.currentState.textboxValue).then((s) {
        setState(()  {
          patients = s;
          print(patients);
          returnListTile();
        });
      });
      
    }
  }

  List<Widget> returnListTile(){
    widgetList.clear();
    for (var i = 0; i < patients.length; i++) {
      

      widgetList.add(Card(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
							backgroundColor: Colors.white,
							child: Icon(Icons.person)
						),

						title: Text(patients[i]["name"]),

						subtitle: Text(patients[i]["id"]),

						

             onTap: () {
               Navigator.pushReplacement(
                context,
                MaterialPageRoute(          
                   builder: (context) => getPrescription(id:patients[i]["clinicRecordID"] ,),
              ));
             }
						
        ),
        ),
      ); 
    }
    return widgetList;
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
                  Expanded(
                    child: Form(
                      key:_patientSerchFormKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(
                            padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            child: textBox(
                                textBoxType: 2,
                                key: _serchKey,
                                hintText: "Enter your serching id here...",
                                labelText: "Id",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.search,
                                prifix: "",
                                suffix: "",
                                maxLength: 10,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "emptyCheck"
                                ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                                child:RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  child: const Text('Search',style: TextStyle(fontSize: 20.0, color: Colors.white)),
                                  color: Color(Const.greenColor),
                                  elevation: 4.0,
                                  splashColor: Color(Const.orngeColor),
                                  onPressed: () {
                                      search();
                                  },
                                )
                              )
                            ],
                          ),
                           
                        ],
                      ),
                    ),
                  )
                  
                    
                  
                ],
              ),
              
              
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Serch Result",
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
                        height: 700.0,
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            children: returnListTile()),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              

            ],
          )),
        ),
      ],
    );
  }
}
