import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/doctor/doctorPage.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:first/module/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _formKey = new GlobalKey<FormState>();
final _title = new GlobalKey<TextBoxState>();
final _description = new GlobalKey<TextBoxState>();
final _medicineController = TextEditingController();
final _qtyController = TextEditingController();
final _dayCountController = TextEditingController();

class AddRecord extends StatefulWidget {
  String patientID;
  AddRecord({this.patientID});
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: MainContain(patientID: widget.patientID,),
    );
  }
}

class MainContain extends StatefulWidget {
  String patientID;
  MainContain({this.patientID});
  _MainContainState createState() => _MainContainState();
}

class _MainContainState extends State<MainContain> {

  int selectedRadio;

  int _count = 0;
  String medicine;
  String amount;
  String dayCount;
  DateTime startDate;
  DateTime dateTime = new DateTime.now();
  var afterBeforeValue;
  int currentColor=Const.blackColor;
  String selectedTest = "press + to add prescrption";
  bool pressed = true;
  String DoctorID;
  String addedPatientRecordId;
  String currentTime = 'Morning';
  


  List _timeList = ["Morning", "Noon", "Night"];
  
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DoctorID = (prefs.getString("ID") ?? '0');
  }

  SetSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

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

  void addPatientRecordBUttonClick() async{

    
    final from = _formKey.currentState;
    bool valid = false;

    if (from.validate()) {
      from.save();
      valid = true;
    }


    if (valid == true) {
      await addPatientRecord(
              widget.patientID,
              DoctorID,
              _title.currentState.textboxValue,
              _description.currentState.textboxValue,)
          .then((s) {
            setState(() {
              addedPatientRecordId = s;
            });
      });

      if(addedPatientRecordId != 'Error'){
        print("done");
        showTopShortToast("added");
      }
      else{
        // show alert        
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
    List<Widget> _contatos = List.generate(_count, (int i) => returnWidget());

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(Const.orngeColor),
          title: Text("Add record"),
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
        body: LayoutBuilder(builder: (context, constraint) {
          return Padding(
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            child: Column(
              children: <Widget>[
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
                                  addPatientRecordBUttonClick();
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

                Row(
                  children: <Widget>[
                    Text(selectedTest,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: Color(currentColor)
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 200.0,
                    child: ListView(
                      children: _contatos,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          if(_count == 0){
                            if(addedPatientRecordId != null){
                              setState(() {
                                currentColor = Const.blackColor;
                                selectedTest ="Prescrption";
                                pressed = !pressed;
                              });
                            
                            _addNewContactRow();
                            }
                            else{
                              showTopShortToast("Add medicale recode to add a prescrption");
                            }
                            
                          }
                          else{
                            addPresciptionButtonClick();
                            
                          }
                          
                        },
                        foregroundColor: Colors.white,
                        backgroundColor: Color(Const.orngeColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }

  void _addNewContactRow() {
    setState(() {
      _count = _count + 1;
    });
  }

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  Widget returnWidget() {
    _dropDownMenuItems = getDropDownMenuItems();
    return Card(
      child: Container(
        
          width: 180.0,
          padding: EdgeInsets.all(5.0),
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
                  width: 100,
                  child: Text(
                    "When",
                    style: TextStyle(
                        fontSize: 20.0, color: Color(Const.blackColor)),
                  ),
                ),

                // SizedBox(
                //   width: 50.0,
                // ),

                Container(
                  width: 200,
                  child: DropdownButton(
                    value: currentTime,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                ),
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
                  
                  child: Text("Having meal",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(Const.blackColor),
                        
                      ),
                      textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ])),
    );
  }

  void medicineOnChanged(String value) {
    setState(() {
      medicine =value;
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

  void addPresciptionButtonClick() async{
    print("addPrescription");
    bool valid =true;

    if( medicine == null){
      _showAlert("enter medicine");
      valid = false;
    }

    else if(amount == null){
      _showAlert("enter amout");
      valid = false;
    }
    else if(dayCount == null){

      _showAlert("enter day count");
      valid = false;
    }
    else if(afterBeforeValue == null){
      _showAlert("enter after before");
      valid = false;
    }
    print(valid);
    
    if(valid){
      String time;
      startDate =dateTime;
      dateTime=dateTime.add(Duration(days:int.parse(dayCount) ));
      if(currentTime == 'Morning'){
        time = '1';
      }
      else if(currentTime == "Noon"){
        time = '2';
      }
      else if(currentTime == 'Night'){
        time = '3';
      }
      String response;
      await addPrescription(
            addedPatientRecordId,
            startDate.toString(),
            dateTime.toString(),
            medicine,
            amount,
            time,
            afterBeforeValue,)
          .then((s) {
            setState(() {
              response = s;
            });
      });

      if(response == 'Done'){
        showTopShortToast("added");
        _medicineController.clear();
        _qtyController.clear();

      }
      else{
        //shoe alert
      }

    }

  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _timeList) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  void changedDropDownItem(String selectedTime) {
    setState(() {
      currentTime = selectedTime;
    });
  }
}
