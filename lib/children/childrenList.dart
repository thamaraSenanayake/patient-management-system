import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/children/childHome.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/Details.dart';
import 'package:first/const.dart';
import 'package:first/home.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class childrenList extends StatefulWidget {
  String id;
  childrenList({this.id});

  _childrenListState createState() => _childrenListState();
}

class _childrenListState extends State<childrenList> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: getDataContain(id: widget.id,),
    );
  }
}

class getDataContain extends StatefulWidget {
  String id;
  getDataContain({this.id});
  _getDataContainState createState() => _getDataContainState();
}

class _getDataContainState extends State<getDataContain> {
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
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("My Children"),
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
      backgroundColor: Colors.white,
      body: FutureBuilder<List>(
          future: getChildren(widget.id),
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
            title: Text(list[i]['name']),
            subtitle: Text(list[i]['age']),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      childHomePage(childId:list[i]['id'], childName:list[i]['name'], childAge:list[i]['age']),
                )));
      },
    );
  }
}
