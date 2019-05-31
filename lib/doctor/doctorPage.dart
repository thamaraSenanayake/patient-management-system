
import 'package:first/doctor/addRecordsToAssignPatientSearchPage.dart';
import 'package:first/doctor/assignPatientSearchPage.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/doctor/patientSearch.dart';
import 'package:first/home.dart';
import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/database.dart';



class doctorPage extends StatefulWidget {
  String childId,childName,childAge;

  doctorPage({this.childId,this.childName,this.childAge});

  _doctorPageState createState() => _doctorPageState();
}

class _doctorPageState extends State<doctorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("Doctor"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorHomePage(),
                )
              );  
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
  

  String id;
  String name = "null";
  String age = "0";
  List patient = [
    ["loading"]
  ];
  List notification = [
    ["loading"]
  ];
  List<Widget> widgetList = [];
  List<Widget> newWidgetList = [];
  List<Widget> notificationList = [];
  List<Widget> newNotificationList = [];

  SharedPreferences prefs;
  Widget bmiWidget;
  double bmi;

  @override
  void initState() {
    super.initState();
    
    init();
  }

    var profilePIcLocation = "http://"+Const.ip+"/eMedicine/uploads/man.png";
  

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = (prefs.getString("ID") ?? '0');

    List userDeatils;

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

    await getAssignRequest(id).then((s) {
      patient = s;
      returnListTile();

    });

    setState(() {
      newWidgetList = widgetList;
    });

    await getAnalizeData(id).then((s) {
      notification = s;
      returnNotification();
    });

    setState(() {
      newNotificationList = notificationList;
    });

  }

  void returnListTile() {
    for (var i = 0; i < patient.length; i++) {
      
      widgetList.add(Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
          title: Text('Name ' +patient[i]['name']),
          subtitle: Text(patient[i]['description']),
          trailing: IconButton(
            icon: Icon(Icons.person_add),
            onPressed: (){
              addPatientButtonClick(patient[i]['userId']);
            },
          ),
        ),
      ));
    }
  }

  void returnNotification() {
    for (var i = 0; i < notification.length; i++) {
      
      notificationList.add(Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
          title: Text(notification[i]['description']+" incressing in your area"),
          
          trailing: Icon(
            Icons.warning  ,
            color:Colors.red ,         
          ),
        ),
      ));
    }
  }

  void addPatientButtonClick(String patientId) async{
    String response;
    await addRemovePatient(patientId,id).then((s) async{
      response = s;
      if(response == "Add"){
        showTopShortToast("added");
      }
      else{
        showTopShortToast("error");
      }
      widgetList.clear();
      await getAssignRequest(id).then((s) {
        patient = s;
        returnListTile();
        setState(() {
          print(widgetList);
          newWidgetList = widgetList;
        });

      });

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
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Search patient",
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
                              builder: (context) => patientSearch(),
                            )
                          )
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
                                          Icons.person_pin,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Assigend Patients",
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
                                  builder: (context) => assignPatientSearchPage(doctorId:id),
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
                                          Icons.playlist_add,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text("Add patient record",
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
                                  builder: (context) => addRecordsToAssignPatientSearchPage(),
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

              Row(
                children: <Widget>[
                  Text(
                    "Notification",
                    style: TextStyle(
                        color: Color(Const.blackColor), fontSize: 30.0),
                    textAlign: TextAlign.left,
                  ),
                ],
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
                            children: newNotificationList),
                      ),
                    ),
                  ),
                ],
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
                            children: newWidgetList
                          ),
                      ),
                    ),
                  ),
                ],
              )

            ],
          )),
        ),
      ],
    );
  }
}

class _assignPatientSearchPageState {
}
