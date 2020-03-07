import 'package:first/login.dart';
import 'package:flutter/material.dart';
import 'package:first/module/textbox.dart';
import 'package:first/home.dart';
import 'package:first/const.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final formKey = new GlobalKey<FormState>();

final userId = new GlobalKey<TextBoxState>();
final name = new GlobalKey<TextBoxState>();
final year = new GlobalKey<TextBoxState>();
final month = new GlobalKey<TextBoxState>();
final date = new GlobalKey<TextBoxState>();
final height = new GlobalKey<TextBoxState>();
final weight = new GlobalKey<TextBoxState>();
final email = new GlobalKey<TextBoxState>();
final password = new GlobalKey<TextBoxState>();
final confirmPassword = new GlobalKey<TextBoxState>();

var selectedBloodGroup = "Select Blood group";
var selectedProvince = "Select province";
var selectedDistrict = "Select District";
var selectedCity = "Select city";
var gender;

var bloodGroups = [
  'Select Blood group',
  'O+',
  'O-',
  'B+',
  'B-',
  'A+',
  'A-',
  'AB+',
  'AB-'
];
var provinceList = ['Select province', 'Western', 'North western','southern','north central','Sabaragamuwa','Uva','Central','Eastern'];
var districtList = ['Select District'];
var cityList = ['Select city'];

class Signin extends StatefulWidget {
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: SigninContain(),
    );
  }
}

class SigninContain extends StatefulWidget {
  _SigninContainState createState() => _SigninContainState();
}

class _SigninContainState extends State<SigninContain> {
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  void _getDistrict(){
    setState(() {
      selectedDistrict = "Select District";
      selectedCity = "Select city";
    });
    if(selectedProvince == "Western"){
      districtList = Const.wpDistrictList;
    }
    else if(selectedProvince == "North western"){
      districtList = Const.nwDistrictList;
    }
    ///TODO add all province
  }

  void _getCity(){
    setState(() {
      selectedDistrict = "Select District";
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

  SetSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void _signInOnClick() async {
    SharedPreferences prefs;

    final from = formKey.currentState;
    bool valid = false;
    
    if (from.validate()) {
      from.save();
      valid = true;
    }

    if(valid == true){
      if(selectedBloodGroup == "Select Blood group"){
        _showAlert("select a blood group");
        valid = false;
      }
      else if(selectedProvince =="Select province"){
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

      else if(password.currentState.textboxValue != confirmPassword.currentState.textboxValue){
        _showAlert("password dosent match");
        valid = false;
      }
    }
    
    print(valid);
    String response;
    String birthday = year.currentState.textboxValue+"-"+month.currentState.textboxValue+"-"+date.currentState.textboxValue;

    if (valid == true) {
      await dataBaseSignIn(
              userId.currentState.textboxValue,
              name.currentState.textboxValue,
              email.currentState.textboxValue,
              password.currentState.textboxValue,
              birthday,
              weight.currentState.textboxValue,
              height.currentState.textboxValue,
              gender,
              selectedBloodGroup,
              selectedProvince,
              selectedDistrict,
              selectedCity)
          .then((s) {
        response = s;
      });

      print("Response" + response);

      if (response == "DONE!") {

        prefs = await SharedPreferences.getInstance();
        prefs.setString("ID", userId.currentState.textboxValue);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
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
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              height: 1500.0,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF7D05), width: 8.0),
                  borderRadius: BorderRadius.circular(42.0),
                  color: Colors.white),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                height: 101.0,
                width: 315.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/logo.jpeg"),
                  ),
                  border: Border(
                      bottom: BorderSide(color: Color(0xFFFF7D05), width: 5.0)),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 150.0, left: 20.0),
                  child: Text("Sign in",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Color(Const.blackColor),
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 220.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: name,
                          hintText: "Enter your name here...",
                          labelText: "Name",
                          helpText: "",
                          helperText: "helper text",
                          iconName: Icons.account_circle,
                          prifix: "",
                          suffix: "",
                          maxLength: 100,
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
                          key: userId,
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
                          validationKey: "idCheck"),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                     Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: textBox(
                          textBoxType: 2,
                          key: email,
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
                          key: password,
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
                          key: confirmPassword,
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
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: Text("Date of birth",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: textBox(
                                textBoxType: 1,
                                key: year,
                                hintText: "year",
                                labelText: "Year",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "year"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            height: 50.0,
                            width: 80.0,
                            child: textBox(
                                textBoxType: 1,
                                key: month,
                                hintText: "month",
                                labelText: "Month",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 2,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "month"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            height: 50.0,
                            width: 80.0,
                            child: textBox(
                                textBoxType: 1,
                                key: date,
                                hintText: "Date",
                                labelText: "Date",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.calendar_view_day,
                                prifix: "",
                                suffix: "",
                                maxLength: 2,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "day"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 80.0,
                            child: Text("Gender",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 130.0,
                            child: RadioListTile(
                              value: 1,
                              groupValue: selectedRadio,
                              title: Text("Male"),
                              onChanged: (val) {
                                SetSelectedRadio(val);
                                gender = 'm';
                              },
                              activeColor: Color(Const.orngeColor),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            width: 154.0,
                            child: RadioListTile(
                              value: 2,
                              groupValue: selectedRadio,
                              title: Text("Female"),
                              onChanged: (val) {
                                SetSelectedRadio(val);
                                gender = 'f';
                              },
                              activeColor: Color(Const.orngeColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            width: 100.0,
                            child: Text("Blood Group",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 50.0,
                            width: 230.0,
                            child: DropdownButton<String>(
                              items:
                                  bloodGroups.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem),
                                );
                              }).toList(),
                              onChanged: (String selectedItem) {
                                setState(() {
                                  selectedBloodGroup = selectedItem;
                                });
                              },
                              value: selectedBloodGroup,
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
                            child: Text("Height",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: textBox(
                                textBoxType: 1,
                                key: height,
                                hintText: "Enter your height here",
                                labelText: "Height",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.arrow_upward,
                                prifix: "",
                                suffix: "cm",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "numberCheck"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: 100.0,
                            child: Text("Wieght",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(Const.blackColor),
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          Container(
                            height: 40.0,
                            width: 230.0,
                            child: textBox(
                                textBoxType: 1,
                                key: weight,
                                hintText: "Enter your weight here",
                                labelText: "Weight",
                                helpText: "",
                                helperText: "helper text",
                                iconName: Icons.av_timer,
                                prifix: "",
                                suffix: "kg",
                                maxLength: 4,
                                maxLines: 1,
                                obscureText: false,
                                enable: true,
                                autoCorrect: false,
                                inputType: TextInputType.numberWithOptions(),
                                validationKey: "numberCheck"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
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
                              child: const Text('Sign in',
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

                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 2.0),
                      child:GestureDetector(
                      
                        child: Container(
                          
                          alignment: Alignment.center,
                          height: 60.0,
                          child: Text("log In",
                              style: TextStyle(fontSize: 20.0, color: Color(0xFF2A8D00),decoration: TextDecoration.underline)),
                              
                        ),

                        onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context)=> Login(),
                                ));
                        },

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
