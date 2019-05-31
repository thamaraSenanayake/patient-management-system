import 'package:first/Const.dart';
import 'package:first/module/textbox.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



final _formKey = new GlobalKey<FormState>();
final _des = new GlobalKey<TextBoxState>();


class PatientAdimt extends StatefulWidget {
  String patientId;
  PatientAdimt({this.patientId});
  _PatientAdimtState createState() => _PatientAdimtState();
}

class _PatientAdimtState extends State<PatientAdimt> {

  String doctorId;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    doctorId = (prefs.getString("ID") ?? '0');
  }

  void admitButtonClick(){
    final from = _formKey.currentState;
    bool valid = false;
    SharedPreferences prefs;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    String response;

    // if (valid == true) {
    //   await dataBaseLogIn(
    //           userId.currentState.textboxValue,
    //           password.currentState.textboxValue,)
    //       .then((s) {
    //     response = s;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 300.0,
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
                        "Admit report",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
           

            SizedBox(
              height: 60.0,
            ),
            
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),

                child: textBox(
                  textBoxType: 1,
                  key: _des,
                  hintText: "Enter Admit cause here...",
                  labelText: "Admit cause",
                  helpText: "",
                  helperText: "helper text",
                  iconName: Icons.lock,
                  prifix: "",
                  suffix: "",
                  maxLength: 20,
                  maxLines: 3,
                  obscureText: false,
                  enable: true,
                  autoCorrect: false,
                  inputType: TextInputType.numberWithOptions(),
                  validationKey: "emptyCheck"
                ),
                        
              ),
            ),


            Padding(
              padding: EdgeInsets.only(left: 144),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: const Text('Admit',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Color(Const.greenColor),
                elevation: 4.0,
                splashColor: Color(Const.orngeColor),
                onPressed: () async {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
