import 'package:first/ReportRecodersDetails.dart';
import 'package:first/children/childHome.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:first/home.dart';
import 'package:first/database.dart';
import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';

class ReportRecoders extends StatefulWidget {
  String id;
  String status;
  ReportRecoders({this.id,this.status});

  _ReportRecodersState createState() => _ReportRecodersState();
}

class _ReportRecodersState extends State<ReportRecoders> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: getDataContain(id: widget.id,status: widget.status,),
    );
  }
}

class getDataContain extends StatefulWidget {
  String id;
  String status;
  getDataContain({this.id,this.status});
  _getDataContainState createState() => _getDataContainState();
}

class _getDataContainState extends State<getDataContain> {
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("Medical Report Book"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              print(widget.status);
              if(widget.status == 'child'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => childHomePage(),
                  )
                );
              }
              else if(widget.status == 'Doctor'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientPage(id:widget.id),
                  )
                );
              }
              else if (widget.status == "doctor"){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorHomePage(),
                  ));  
              }
              else if (widget.status == "nurse"){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NurseHomePage(),
                  ));  
              }
              else if (widget.status == "otherServices"){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtherServiceHome(),
                  ));  
              }
              else if (widget.status == "pharmacist"){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacistHome(),
                  ));  
              }
              else if (widget.status == "ambulance"){
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
                  )
                );
              }
              
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List>(
          future: getReportRecoders(widget.id),
          builder: (ctx, ss) {
            if (ss.hasError) {
              print("error");
            }
            if (ss.hasData) {
              return item(list: ss.data);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class item extends StatelessWidget {
  @override
  List list;

  item({this.list});

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (ctx, i) {
        return ListTile(
            leading: Icon(Icons.note_add),
            title: Text(list[i]['title']+"         Mr. "+list[i]['doctor']),
            subtitle: Text(list[i]['date']),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ReportRecodersDetails(list: list, index: i),
                )));
      },
    );
  }
}
