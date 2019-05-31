import 'package:first/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/const.dart';

class ReportRecodersDetails extends StatefulWidget {
  List list;
  int index;

  ReportRecodersDetails({this.list,this.index});

  _ReportRecodersDetailsState createState() => _ReportRecodersDetailsState();
}

class _ReportRecodersDetailsState extends State<ReportRecodersDetails> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Report Recoders Details"),
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

                    child: Text("Mr/Mrs. "+widget.list[widget.index]['doctor'],
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
           ],
         ),
       ),
    );
  }
}