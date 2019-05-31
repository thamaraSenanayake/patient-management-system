import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:flutter/material.dart';
import 'package:first/module/textbox.dart';
import 'package:first/home.dart';
import 'package:first/const.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/children/childHome.dart';

final _childCreateAccountFormKey = new GlobalKey<FormState>();

final _childUserId = new GlobalKey<TextBoxState>();
final _childEmail = new GlobalKey<TextBoxState>();
final _childPassword = new GlobalKey<TextBoxState>();
final _childConfirmPassword = new GlobalKey<TextBoxState>();

var selectedProvince = "Select province";
var selectedDistrict = "Select District";
var selectedCity = "Select city";
var gender;


var provinceList = ['Select province', 'Western', 'North western'];
var districtList = ['Select District'];
var cityList = ['Select city'];

class createAccount extends StatefulWidget {
  _createAccountState createState() => _createAccountState();
}

class _createAccountState extends State<createAccount> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: signinContain(),
    );
  }
}

class signinContain extends StatefulWidget {
  _signinContainState createState() => _signinContainState();
}

class _signinContainState extends State<signinContain> {

  String childId;
  String childName;
  String childAge;
  String type;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initChildDeatils();

  }

  void initChildDeatils() async{
    print("initChild");
    prefs = await SharedPreferences.getInstance();  
    type = (prefs.getString("Type") ?? '0');
  

    String ID = (prefs.getString("ChildId") ?? '0');
    String AGE = (prefs.getString("ChildAge") ?? '0');
    String NAME = (prefs.getString("ChildName") ?? '0'); 
    setState(() {
      childId = ID;
      childAge = AGE;
      childName = NAME;
    });
  }

  void _getDistrict(){
    initDistrictCity();
    if(selectedProvince == "Western"){
      districtList = Const.wpDistrictList;
      
    }
    else if(selectedProvince == "North western"){
      districtList = Const.nwDistrictList;
    }
    ///TODO add all province
  }

  void initDistrictCity(){
      setState(() {
        selectedDistrict = "Select District";
        selectedCity = "Select city";  
      });
  }

  void _getCity(){
    setState(() {
        selectedCity = "Select city";  
      });
    if(selectedDistrict == "Puthlam"){
      cityList = Const.PuththalamaCityList;
    }
    else if(selectedDistrict == "Kurunegala"){
      cityList = Const.KurunegalaCityList;
    }
    ///TODO add all district
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


  void _signInOnClick() async {
    final from = _childCreateAccountFormKey.currentState;
    bool valid = false;
    
    if (from.validate()) {
      from.save();
      valid = true;
    }
    print("valid "+valid.toString());

    if(valid == true){
      
      if(selectedProvince =="Select province"){
        _showAlert("select a province");
        valid = false;
      }
      else if(selectedDistrict =="Select District"){
        _showAlert("select a district");
        valid = false;
      }
      else if(selectedCity =="Select city"){
        _showAlert("select a city");
        valid = false;
      }

      else if(_childPassword.currentState.textboxValue != _childConfirmPassword.currentState.textboxValue){
        _showAlert("password dosent match");
        valid = false;
      }
    }
    
    String response;

    if (valid == true) {
         
      await createAccoutForChild(
              childId,
              _childUserId.currentState.textboxValue,
              _childEmail.currentState.textboxValue,
              _childPassword.currentState.textboxValue,
              selectedProvince,
              selectedDistrict,
              selectedCity)
          .then((s) {
        response = s;
      });

      print("Response" + response);

      if (response == "Done") {
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
      }

      else{
        _showAlert(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("My Child"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => childHomePage(childId: childId,childName: childName,childAge: childAge,),
                )
              );  
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Text("Create account",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Color(Const.blackColor),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 100.0),
              child: Form(
                key: _childCreateAccountFormKey,
                child: Column(
                  children: <Widget>[
      
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: _childUserId,
                          hintText: "Enter your ID number here...",
                          labelText: "ID number",
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
                          inputType: TextInputType.numberWithOptions(),
                          validationKey: "emptyCheck"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                     Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: _childEmail,
                          hintText: "Enter your email address here...",
                          labelText: "E-mail",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.email,
                          prifix: "",
                          suffix: "",
                          maxLength: 100,
                          maxLines: 1,
                          obscureText: false,
                          enable: true,
                          autoCorrect: false,
                          inputType: TextInputType.numberWithOptions(),
                          validationKey: "emailCheck"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                     Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: _childPassword,
                          hintText: "Enter your password here...",
                          labelText: "Password",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.lock_outline,
                          prifix: "",
                          suffix: "",
                          maxLength: 100,
                          maxLines: 1,
                          obscureText: true,
                          enable: true,
                          autoCorrect: false,
                          inputType: TextInputType.numberWithOptions(),
                          validationKey: "emptyCheck"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                     Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: _childConfirmPassword,
                          hintText: "Re-Enter your password here...",
                          labelText: "Confirm Paaword",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.lock_outline,
                          prifix: "",
                          suffix: "",
                          maxLength: 100,
                          maxLines: 1,
                          obscureText: true,
                          enable: true,
                          autoCorrect: false,
                          inputType: TextInputType.numberWithOptions(),
                          validationKey: "emptyCheck"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text("Address",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: DropdownButton<String>(
                              items:
                                  provinceList.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String selectedItem) {
                                setState(() {
                                  selectedProvince = selectedItem;
                                  _getDistrict();
                                });
                              },
                              value: selectedProvince,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: DropdownButton<String>(
                              items:
                                  districtList.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String selectedItem) {
                                setState(() {
                                  selectedDistrict = selectedItem;
                                  _getCity();
                                });
                              },
                              value: selectedDistrict,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: DropdownButton<String>(
                              items: cityList.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String selectedItem) {
                                setState(() {
                                  
                                  selectedCity = selectedItem;
                                });
                              },
                              value: selectedCity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 200, right: 20.0),
                      child: GestureDetector(
                        child: Container(
                          // alignment: Alignment.center,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          // child: Text("Sign in",
                          //     style:
                          //         TextStyle(fontSize: 20.0, color: Colors.white)),
                          child: ButtonTheme(
                            minWidth: 175.0,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              child: const Text('Add Account',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              color: Color(Const.greenColor),
                              elevation: 4.0,
                              splashColor: Color(Const.orngeColor),
                              onPressed: () async {
                                _signInOnClick();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
