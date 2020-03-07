import 'package:first/Const.dart';
import 'package:first/database.dart';
import 'package:first/module/sendMail.dart';
import 'package:first/module/textbox.dart';
import 'package:flutter/material.dart';

final _formKey = new GlobalKey<FormState>();
final _title = new GlobalKey<TextBoxState>();
final _des = new GlobalKey<TextBoxState>();

class MailSender extends StatefulWidget {
  String patientMail;
  String doctorId;
  MailSender({this.patientMail, this.doctorId});
  _MailSenderState createState() => _MailSenderState();
}

class _MailSenderState extends State<MailSender> {
  String errorDisplay = "";
  String doctorName;
  List userDeatils;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await getUserDetails(widget.doctorId).then((s) {
      userDeatils = s;
    });

    setState(() {
      doctorName = userDeatils[0]['name'];
    });
  }

  void sendMailButtonClick() async {
    bool valid = true;
    final from = _formKey.currentState;

    if (from.validate()) {
      from.save();
      valid = true;
    }

    if (valid) {
      Mail newMail = new Mail(
          to: widget.patientMail,
          subject: _title.currentState.textboxValue,
          text:
              'From: Dr.' + doctorName + '<br/>' + _des.currentState.textboxValue);
      newMail.sendMail();
      Navigator.pop(context, null);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 450.0,
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
                        "Send Mail",
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
              child: Column(
                children: <Widget>[
                  
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                    
                    child: textBox(
                        textBoxType: 1,
                        key: _title,
                        hintText: "Enter title here...",
                        labelText: "Title",
                        helpText: "",
                        helperText: "helper text",
                        iconName: Icons.lock,
                        prifix: "",
                        suffix: "",
                        maxLength: 50,
                        maxLines: 1,
                        obscureText: false,
                        enable: true,
                        autoCorrect: false,
                        inputType: TextInputType.numberWithOptions(),
                        validationKey: "emptyCheck"
                      ),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                    
                    child: textBox(
                        textBoxType: 1,
                        key: _des,
                        hintText: "Enter message here...",
                        labelText: "message",
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
                        inputType: TextInputType.numberWithOptions(),
                        validationKey: "emptyCheck"
                      ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                errorDisplay,
                style: TextStyle(color: Colors.red, fontSize: 18.0),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 144),
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: const Text('Send',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                color: Color(Const.greenColor),
                elevation: 4.0,
                splashColor: Color(Const.orngeColor),
                onPressed: () {
                  sendMailButtonClick();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
