import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/doctor/doctorPage.dart';
import 'package:first/module/textbox.dart';
import 'package:first/otherService/otherServiceSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = new GlobalKey<FormState>();
final _title = new GlobalKey<TextBoxState>();
final _description = new GlobalKey<TextBoxState>();


class AddReport extends StatefulWidget {
  String patientID;
  String serviceId;
  String description;
  AddReport({this.patientID,this.serviceId,this.description});
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: MainContain(patientID: widget.patientID,serviceId: widget.serviceId,description: widget.description,),
    );
  }
}

class MainContain extends StatefulWidget {
  String patientID;
  String serviceId;
  String description;
  MainContain({this.patientID,this.serviceId,this.description});
  _MainContainState createState() => _MainContainState();
}

class _MainContainState extends State<MainContain> {

  
  String serviceProviderId;
  String addedPatientRecordId;
  


  
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    serviceProviderId = (prefs.getString("ID") ?? '0');
  }

  

  

  void addMedicaleRecordBUttonClick() async{

    
    final from = _formKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }


    if (valid == true) {
      await addMedicaleReport(
              serviceProviderId,
              widget.patientID,
              widget.serviceId,
              _title.currentState.textboxValue,
              _description.currentState.textboxValue,)
          .then((s) {
            setState(() {
              addedPatientRecordId = s;
            });
      });

      if(addedPatientRecordId == 'DONE!'){
        print("done");
        Navigator.push(
        context,
        MaterialPageRoute(          
           //builder: (context) => DoctorHomePage(),
           builder: (context) => OtherServiceSearch(),
          // builder: (context) => NurseHomePage(),
        ));
      }
      else{
        showTopShortToast("Error");
      }

      print(addedPatientRecordId);

    }
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

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(Const.orngeColor),
          title: Text("Add Report"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherServiceSearch(),
                    ));
              },
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Padding(
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            child: Column(
              children: <Widget>[
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
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0.0),
                        child: textBox(
                            textBoxType: 2,
                            key: _title,
                            hintText: "Enter record title here...",
                            labelText: "record Title",
                            helpText: "",
                            helperText: "helper text",
                            iconName: Icons.text_fields,
                            prifix: "",
                            suffix: "",
                            maxLength: 50,
                            maxLines: 1,
                            obscureText: false,
                            enable: true,
                            autoCorrect: false,
                            inputType: TextInputType.text,
                            validationKey: "emptyCheck"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: textBox(
                            textBoxType: 1,
                            key: _description,
                            hintText: "Enter record description here...",
                            labelText: "Description",
                            helpText: "",
                            helperText: "helper text",
                            iconName: Icons.text_fields,
                            prifix: "",
                            suffix: "",
                            maxLength: 500,
                            maxLines: 8,
                            obscureText: false,
                            enable: true,
                            autoCorrect: false,
                            inputType: TextInputType.text,
                            validationKey: "emptyCheck"),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 220),
                        child: ButtonTheme(
                              minWidth: 150.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                child: const Text('Add',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white)),
                                color: Color(Const.greenColor),
                                elevation: 4.0,
                                splashColor: Color(Const.orngeColor),
                                onPressed: () async {
                                  addMedicaleRecordBUttonClick();
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20.0,
                ),

              ],
            ),
          );
        }));
  }

  


  

  
  void _showAlert(String text){
    AlertDialog dialog = new AlertDialog(
    content: Row(
      children: <Widget>[
        Icon(
          Icons.error,
          color: Colors.red,),
        SizedBox(
          width: 10.0,
        ),
        Text(text,style:TextStyle(color: Colors.red),),
      ],
    ),
      
    );

    showDialog(context: context,child: dialog);
  }

}
