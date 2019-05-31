import 'package:first/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/const.dart';

class Details extends StatefulWidget {
  List list;
  int index;

  Details({this.list,this.index});

  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List medicine = [
    ["loading"]
  ];
  List<Widget> widgetList = [];
  List<Widget> newWidgetList = [];

  void initState() {
    super.initState();
    init();
  }

  void init() async {
  
    await getMedicineToclinicRecord(widget.list[widget.index]['id']).then((s) {
      setState(() {
        medicine = s;
      });
    });


    returnListTile();

    setState(() {
      newWidgetList = widgetList;
    });

  }

  void returnListTile() {
    print(medicine);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Clinic Record"),
        backgroundColor: Color(Const.orngeColor),
      ),
       body: Center(
         
         child: Column(
           children: <Widget>[
             SizedBox(
               height: 50.0,
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 2.0, left: 20.0),
                  child: Text(widget.list[widget.index]['title'],
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Color(Const.blackColor),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(left: 300),
                  child: Container(

                    child: Text(widget.list[widget.index]['date'],
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(Const.blackColor),
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.0, left: 40.0,right: 40.0),
                  
                    child:Container(
                      height: 200.0,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Container(
                              height: 200.0,
                              child: Text(widget.list[widget.index]['description'],
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(Const.blackColor),
                                fontWeight: FontWeight.w600)
                              ),
                            ),  
                          ], 
                      ),
                    ),
                    
                  ),
                ),
              ],
            ),
            
            Row(
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(left: 40),
                  child: Container(

                    child: Text("Dr. "+widget.list[widget.index]['doctor'],
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(Const.blackColor),
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.end,
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
                            children: newWidgetList),
                      ),
                    ),
                  ),
                ],
              ),

          
           ],
         ),
       ),
    );
  }
}