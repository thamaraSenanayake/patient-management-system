
import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/database.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:first/module/browser.dart';
import 'package:first/nurse/nurseGetPatientMedicine.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/module/textbox.dart';

final _patientSerchFormKey = new GlobalKey<FormState>();


final _serchKey = new GlobalKey<TextBoxState>();

class AmbulanceTrip extends StatefulWidget {
  _AmbulanceTripState createState() => _AmbulanceTripState();
}

class _AmbulanceTripState extends State<AmbulanceTrip> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Serch patient"),
        backgroundColor: Color(Const.orngeColor),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AmbulanceHome(),
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
    await getAmbulanceTrip(id).then((s) {
      setState(() {
        patients = s;
        returnListTile();
      });
    });    
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

            trailing: IconButton(
              icon: Icon(Icons.phone),
              onPressed: (){
                getAmbulanceRide(patients[i]["rideId"]);
                launchURL("tel:"+patients[i]["conNum"]); 
              },
            ),
						
        ),
        ),
      ); 
    }

    return widgetList;
  }

  void getAmbulanceRide(String rideID) async{
    String response;
     await updateGetAmbulance(rideID).then((s) async{
      response = s;
      if(response == "DONE!"){
        showTopShortToast("added");
      }
      else{
        showTopShortToast("error");
      }
    });
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
                          
                          SizedBox(
                            height: 2.0,
                          ),
                          
                           
                        ],
                      ),
                    ),
                  )
                  
                    
                  
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
