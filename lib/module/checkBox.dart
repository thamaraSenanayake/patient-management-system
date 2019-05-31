import 'package:flutter/material.dart';
import 'package:first/const.dart';

class checkBox extends StatefulWidget{
  bool initValue;
  String title;
  IconData iconName;
  String subtitle;
  int color;
  int checkBoxType;

  checkBox(
      {
      Key key,
      this.checkBoxType,
      this.initValue,
      this.title,
      this.iconName,
      this.subtitle,
      this.color,    
      })
      : super(key: key);

  
  @override
  checkBoxState createState() => checkBoxState();
  
  }
  
class checkBoxState extends State<checkBox> {
  bool checkBoxValue;
  
  void valueChanged(bool value){
    setState(() => widget.initValue = value);
    checkBoxValue = value;
    
  }

  @override
  Widget build(BuildContext context) {
    checkBoxValue = widget.initValue;
    var layout;
    if (widget.checkBoxType == 1) {
        layout = CheckboxListTile(
                    value: widget.initValue,
                    title:  Text(widget.title, style: TextStyle(color: Color(Const.greenColor),fontWeight:FontWeight.w600)),                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: valueChanged,
                    activeColor: Color(widget.color),
                    
                  );
    } else {
        layout = CheckboxListTile(
                    value: widget.initValue,
                    title:  Text(widget.title, style: TextStyle(color:Color(Const.greenColor),fontWeight:FontWeight.w900)),
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Icon(widget.iconName,color: Color(Const.greenColor)),
                    onChanged: valueChanged,
                    activeColor: Color(widget.color),
                    subtitle: Text(widget.subtitle,style: TextStyle(color:Color(Const.greenColor))),
                                 
                  );
    }

   
      
      return (Theme(
        data: new ThemeData(
          
          accentColor: Colors.blue,
          fontFamily: 'Georgia',
         
        ),
        child: layout ,
      ));
    }

}