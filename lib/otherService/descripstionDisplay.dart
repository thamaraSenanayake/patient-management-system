import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';
import 'package:first/otherService/addReport.dart';
import 'package:flutter/material.dart';

final _formKey = new GlobalKey<FormState>();
final _des = new GlobalKey<TextBoxState>();
final _title = new GlobalKey<TextBoxState>();

class DescripstionDisplay extends StatefulWidget {
  String patientId;
  String description;
  String serviceId;
  DescripstionDisplay({this.patientId,this.description,this.serviceId});
  _DescripstionDisplayState createState() => _DescripstionDisplayState();
}

class _DescripstionDisplayState extends State<DescripstionDisplay> {
  String errorDisplay="";

  

  @override
  Widget build(BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 500.0,
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
                            "Descrption",
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
               
    
                SizedBox(
                  height: 10.0,
                ),

                Container(
                  height: 100.0,
                  child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.description,
                        style:
                            TextStyle(color: Color(Const.blackColor), fontSize: 18.0),
                        textAlign: TextAlign.start,
                      ),
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    
                        child: textBox(
                          textBoxType: 1,
                          key: _title,
                          hintText: "Enter title here...",
                          labelText: "title",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.lock,
                          prifix: "",
                          suffix: "",
                          maxLength: 20,
                          maxLines: 1,
                          obscureText: false,
                          enable: true,
                          autoCorrect: false,
                          inputType: TextInputType.text,
                          validationKey: "emptyCheck"
                        ),
                                
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    
                        child: textBox(
                          textBoxType: 1,
                          key: _des,
                          hintText: "Enter description here...",
                          labelText: "Description",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.lock,
                          prifix: "",
                          suffix: "",
                          maxLength: 50,
                          maxLines: 3,
                          obscureText: false,
                          enable: true,
                          autoCorrect: false,
                          inputType: TextInputType.text,
                          validationKey: "emptyCheck"
                        ),
                                
                      ),
                    ],
                  ),
                ),
                    

                Row(
                  children: <Widget>[
                    
                    Padding(
                      padding: EdgeInsets.only(left: 80),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: const Text('Investigate',
                            style: TextStyle(fontSize: 20.0, color: Colors.white)),
                        color: Color(Const.greenColor),
                        elevation: 4.0,
                        splashColor: Color(Const.orngeColor),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(          
                              builder: (context) => AddReport(patientID: widget.patientId,serviceId: widget.serviceId,),
                          ));
                          
                          Navigator.pop(context, null);
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: const Text('Cancel',
                            style: TextStyle(fontSize: 20.0, color: Colors.white)),
                        color: Color(Const.orngeColor),
                        elevation: 4.0,
                        splashColor: Color(Const.orngeColor),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                      ),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
