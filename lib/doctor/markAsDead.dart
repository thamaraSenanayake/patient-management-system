import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/module/textbox.dart';
import 'package:flutter/material.dart';



final _formKey = new GlobalKey<FormState>();
final _des = new GlobalKey<TextBoxState>();


class MarkAsDead extends StatefulWidget {
  String patientId;
  MarkAsDead({this.patientId});
  _MarkAsDeadState createState() => _MarkAsDeadState();
}

class _MarkAsDeadState extends State<MarkAsDead> {
  String errorDisplay="";

  void addDoctorButtonClick() async{
    bool valid =true;
    final from = _formKey.currentState;
    
    if (from.validate()) {
        from.save();
        valid = true;
    }

    if(valid){
      
      String response;
      await addDeathReport(
            widget.patientId,
            _des.currentState.textboxValue)
          .then((s) {
            setState(() {
              response = s;
            });
      });
      print(response);
      if(response == 'DONE!'){
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
            height: 350.0,
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
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Death report",
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
                      hintText: "Enter death Cause here...",
                      labelText: "Death Cause",
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
                  padding: EdgeInsets.only(top: 10.0),
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
