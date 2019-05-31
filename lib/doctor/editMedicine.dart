import 'package:first/database.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/const.dart';
import 'package:first/alertBox.dart';

final _medicineController = TextEditingController();
final _qtyController = TextEditingController();
final _dayCountController = TextEditingController();

class editMedicine extends StatefulWidget {
  List list;
  int index;
  String patientID;

  editMedicine({this.list,this.index,this.patientID});

  _editMedicineState createState() => _editMedicineState();
}

class _editMedicineState extends State<editMedicine> {
  

  
  List clinicReocrd = [
    ["loading"]
  ];
  
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _timeList = ["Morning", "Noon", "Night"];

  
  int selectedRadio;
  
  var afterBeforeValue;
  
  DateTime dateTime = new DateTime.now();
  DateTime endTime = new DateTime.now();
  String entertedMedicine;
  String amount;
  String currentTime = 'Morning';  
  String dayCount = "0";
  String clinicReocrdTitle = "loading",clinicReocrdDate = "loading",clinicReocrdDoctor = "loading",clinicReocrdDescription = "loading";

  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    selectedRadio = 0;
    
    // print(widget.list);
    
    super.initState();
    init();
  }

  void init() async {
    _medicineController.text= widget.list[widget.index]["medicine"];
    entertedMedicine= widget.list[widget.index]["medicine"];

    _qtyController.text= widget.list[widget.index]["count"].toString();
    amount= widget.list[widget.index]["count"].toString();

    dateTime =DateTime.parse(widget.list[widget.index]["startDate"]);
    
    dayCount =(((DateTime.parse(widget.list[widget.index]["endDate"])).difference(dateTime).inDays)).toString();
    _dayCountController.text =dayCount;
    
    //seting current time
    if(widget.list[widget.index]["time"]=='1'){currentTime = "Morning"; }
    else if(widget.list[widget.index]["time"]=='2'){currentTime = "Noon";}
    else if(widget.list[widget.index]["time"]=='3'){currentTime = "Night";}

    if(widget.list[widget.index]["after_before"]=='1')
    { 
      setState(() {
        selectedRadio = 2;
        afterBeforeValue =2;
      });
    }
    else{
      setState(() {
        selectedRadio =1;
        afterBeforeValue =1;
      });
    }

    await getClinicRecodersToPrecription(widget.list[widget.index]['id']).then((s) {
      setState(() {
        clinicReocrd = s;
        clinicReocrdDescription = clinicReocrd[0]['description'];
        clinicReocrdDoctor = clinicReocrd[0]['doctor'];
        clinicReocrdDate = clinicReocrd[0]['date'];
        clinicReocrdTitle = clinicReocrd[0]['title'];
        
        // print(clinicReocrd);
      });
    });
  }

  


  // display calender
  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      lastDate: DateTime(2021),
      firstDate: DateTime(2019),
    );

    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
      });
    }
  }

  //handel form
  void medicineOnChanged(String value) {
    setState(() {
      entertedMedicine =value;
    });
  }

  void qtyOnChanged(String value) {
    setState(() {
      amount =value;
    });
  }
  
  void dayCountOnChanged(String value) {
    setState(() {
      dayCount =value;
    });
  }

  void changedDropDownItem(String selectedTime) {
    setState(() {
      currentTime = selectedTime;
    });
  }

  SetSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _timeList) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }


  //update Prescription
  void savePrescription() async{
    bool validate =true;
    String getCuurentTime;
    if(entertedMedicine.isEmpty){showAlert("Enter medicine",context);validate=false;}
    else if(amount.isEmpty){showAlert("Enter medicine Dose",context);validate=false;}
    else if(dayCount.isEmpty){showAlert("Enter how many days",context);validate=false;}

    if(validate== true){
      endTime = dateTime.add(Duration(days: int.parse(dayCount)));

      if(currentTime == 'Morning'){
        getCuurentTime = '1';
      }
      else if(currentTime == "Noon"){
        getCuurentTime = '2';
      }
      else if(currentTime == 'Night'){
        getCuurentTime = '3';
      }
      String response;
      await updateMedicine(
            widget.list[widget.index]["id"],
            dateTime.toString(),
            endTime.toString(),
            entertedMedicine,
            amount,
            getCuurentTime,
            afterBeforeValue.toString(),)
          .then((s) {
            setState(() {
              response = s;
            });
      });

      if(response == "DONE!"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientPage(id: widget.patientID,),
          ));
      }
      else{
        showAlert("error",context);
      }

    }
  }


  void deletePrescription() async{
    String respnse;

    await removeMedicine(widget.list[widget.index]["id"]).then((s) {
      setState(() {
         respnse = s;
      });
    });

    if (respnse == 'DONE!') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientPage(id: widget.patientID,),
         ));          
     } else {
       showAlert("cant delete the medicine",context);
     }
  }


  //show Alert
  // void _showAlert(String text){
  //   AlertDialog dialog = new AlertDialog(
  //   content: Row(
  //     children: <Widget>[
  //       Icon(
  //         Icons.error,
  //         color: Colors.red,),
  //       SizedBox(
  //         width: 10.0,
  //       ),
  //       Text(text,style:TextStyle(color: Colors.red),),
  //     ],
  //   ),
      
  //   );

  //   showDialog(context: context,child: dialog);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Medicine"),
        backgroundColor: Color(Const.orngeColor),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientPage(id:widget.patientID),
                    ));
              },
            )
          ],
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
                  child: Text(clinicReocrdTitle,
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

                    child: Text(clinicReocrdDate,
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
                              child: Text(clinicReocrdDescription,
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

                    child: Text("Dr. "+clinicReocrdDoctor,
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

                    Container(
                      height: 400.0,
                      
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Card(
                            
                              // width: 180.0,
                              // height: 250.0,
                              // padding: EdgeInsets.all(5.0),
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 70.0,
                                      width: 250.0,
                                      child: Theme(
                                        data: ThemeData(
                                            primaryColor: Color(Const.blackColor),
                                            hintColor: Color(Const.blackColor)),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Medicine',
                                            border: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Color(Const.blackColor)),
                                            ),
                                          ),
                                          onChanged: (text) {
                                            medicineOnChanged(text);
                                          },
                                          controller: _medicineController,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      height: 70.0,
                                      width: 100.0,
                                      child: Theme(
                                        data: ThemeData(
                                            primaryColor: Color(Const.blackColor),
                                            hintColor: Color(Const.blackColor)),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'qty',
                                            border: UnderlineInputBorder(
                                              borderSide:BorderSide(color: Color(Const.blackColor)),
                                            ),
                                          ),
                                          onChanged: (text) {
                                            qtyOnChanged(text);
                                          },
                                          controller: _qtyController,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[

                                    Container(
                                      width: 100.0,
                                      child: Text(
                                        "Start date",
                                        style: TextStyle(
                                            color: Color(Const.blackColor), fontSize: 20.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    SizedBox(
                                      width: 3.0,
                                    ),

                                    Container(
                                      width: 50.0,
                                      child: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        color: Color(Const.greenColor),
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                      ),
                                    ),

                                    SizedBox(
                                      width: 3.0,
                                    ),

                                    Container(
                                      width: 100.0,
                                      child: Text(
                                        dateTime.year.toString() +
                                            "-" +
                                            dateTime.month.toString() +
                                            "-" +
                                            dateTime.day.toString(),
                                        style: TextStyle(
                                            color: Color(Const.blackColor), fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    SizedBox(
                                      width: 24,
                                    ),

                                    Container(
                                      width: 100.0,
                                      child: Theme(
                                        data: ThemeData(
                                            primaryColor: Color(Const.blackColor),
                                            hintColor: Color(Const.blackColor)),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Day Count',
                                            border: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Color(Const.blackColor)),
                                            ),
                                          ),
                                          onChanged: (text) {
                                            dayCountOnChanged(text);
                                          },
                                          controller: _dayCountController,
                                          keyboardType:TextInputType.number,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                                SizedBox(
                                  height: 10.0,
                                ),

                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 50.0,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            child: Text(
                                              "When",
                                              style: TextStyle(
                                                  fontSize: 20.0, color: Color(Const.blackColor)),
                                            ),
                                          ),
                                          Container(
                                            width: 205.0,
                                            height: 50.0,
                                            child: DropdownButton(
                                              value: currentTime,
                                              items: _dropDownMenuItems,
                                              onChanged: changedDropDownItem,
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                  ],

                                ),
                                Row(
                                  children: <Widget>[
                                    
                                    Container(
                                      width: 130.0,
                                      child: RadioListTile(
                                        value: 1,
                                        groupValue: selectedRadio,
                                        title: Text("After"),
                                        onChanged: (val) {
                                          SetSelectedRadio(val);
                                          afterBeforeValue = '2';
                                        },
                                        activeColor: Color(Const.greenColor),
                                      ),
                                    ),

                                    Container(
                                      width: 140.0,
                                      child: RadioListTile(
                                        value: 2,
                                        groupValue: selectedRadio,
                                        title: Text("Before"),
                                        onChanged: (val) {
                                          SetSelectedRadio(val);
                                          afterBeforeValue = '1';
                                        },
                                        activeColor: Color(Const.greenColor),
                                      ),
                                    ),

                                    Container(
                                      
                                      width: 100.0,
                                      
                                      child: Text("meal",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(Const.blackColor),
                                            
                                          ),
                                          textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                children: <Widget>[
                                  Container(
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(Const.greenColor),

                                      onPressed: (){
                                        deletePrescription();
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      icon: Icon(Icons.save),
                                      color: Color(Const.greenColor),

                                      onPressed: (){
                                        savePrescription();
                                      },
                                    ),
                                  ),
                                ],
                               ),
                    
                              ]
                              )
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