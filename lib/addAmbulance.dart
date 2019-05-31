import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';
import 'package:flutter/material.dart';

final _formKey = new GlobalKey<FormState>();
final _conNum = new GlobalKey<TextBoxState>();


class AddAmbulance extends StatefulWidget {
  String id;
  AddAmbulance({this.id});
  _AddAmbulanceState createState() => _AddAmbulanceState();
}

class _AddAmbulanceState extends State<AddAmbulance> {
  var provinceList = ['Select province', 'Western', 'North western','southern','north central','Sabaragamuwa','Uva','Central','Eastern'];
  var districtList = ['Select District'];
  var cityList = ['Select city'];

  var selectedProvince = "Select province";
  var selectedDistrict = "Select District";
  var selectedCity = "Select city";

  var errorDisplay="";

  void _getDistrict() {
    setState(() {
          selectedDistrict = "Select District";
          selectedCity = "Select city";
        });
    if (selectedProvince == "Western") {
      setState(() {
        districtList = Const.wpDistrictList;
      });
    } else if (selectedProvince == "North western") {
      setState(() {
        districtList = Const.nwDistrictList;
      });
    }

    ///TODO add all province
  }

  void _getCity() {
    setState(() {
      selectedCity = "Select city";
    });
    if (selectedDistrict == "Puthlam") {
      setState(() {
        cityList = Const.PuththalamaCityList;
      });
    } else if (selectedDistrict == "Kurunegala") {
      setState(() {
        cityList = Const.KurunegalaCityList;
      });
    }

    ///TODO add all district
  }


  void addDoctorButtonClick() async{
    bool valid =true;
    final from = _formKey.currentState;

    if( selectedCity == 'Select city'){
      setState(() {
        errorDisplay ="Select hospital location";
      });
      valid = false;
    }

    

    if(valid){
      if (from.validate()) {
        from.save();
        valid = true;
      }
    }

    
    
    
    if(valid){
      
      String response;
      await getAmbulance(
            widget.id,
            selectedCity,
            _conNum.currentState.textboxValue)
          .then((s) {
            setState(() {
              response = s;
            });
      });
      print(response);
      if(response == 'Done'){
        Navigator.pop(context, null);

      }
      else{
        setState(() {
          errorDisplay =response;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 510.0,
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
                        "Add Ambulance",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "Select Destination",
                style:
                    TextStyle(color: Color(Const.blackColor), fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 20.0,
                  ),
                  Container(
                    height: 40.0,
                    child: DropdownButton<String>(
                      items: provinceList.map((String dropDownStringItem) {
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
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 20.0,
                  ),
                  Container(
                    height: 40.0,
                    child: DropdownButton<String>(
                      items: districtList.map((String dropDownStringItem) {
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
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 0.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 20.0,
                  ),
                  Container(
                    height: 40.0,
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
              height: 50.0,
            ),

            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),

                child: textBox(
                  textBoxType: 2,
                  key: _conNum,
                  hintText: "Enter Contact number here...",
                  labelText: "Contact Number",
                  helpText: "",
                  helperText: "helper text",
                  iconName: Icons.phone,
                  prifix: "",
                  suffix: "",
                  maxLength: 10,
                  maxLines: 1,
                  obscureText: false,
                  enable: true,
                  autoCorrect: false,
                  inputType: TextInputType.numberWithOptions(),
                  validationKey: "emptyCheck"
                ),
                        
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Text(
                errorDisplay,
                style:
                    TextStyle(color: Colors.red, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 144),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: const Text('Add',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Color(Const.greenColor),
                elevation: 4.0,
                splashColor: Color(Const.orngeColor),
                onPressed: () {
                  addDoctorButtonClick();
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
