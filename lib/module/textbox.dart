import 'package:flutter/material.dart';


class textBox extends StatefulWidget {
  int textBoxType;
  String hintText;
  String helpText;
  String helperText;
  String labelText;
  String icon;
  String prifix;
  String suffix;
  String validationKey;
  bool autoCorrect;
  int maxLength;
  int maxLines;
  bool obscureText;
  var formKey;
  IconData iconName;
  bool enable;
  TextInputType inputType;

  textBox(
      {Key key,
      this.textBoxType,
      this.formKey,
      this.hintText,
      this.helperText,
      this.labelText,
      this.helpText,
      this.iconName,
      this.prifix,
      this.suffix,
      this.autoCorrect,
      this.maxLines,
      this.maxLength,
      this.obscureText,
      this.enable,
      this.inputType,
      this.validationKey
      
      })
      : super(key: key);

  

  @override
  TextBoxState createState() => TextBoxState();
}

class TextBoxState extends State<textBox> {
  
  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  String textboxValue="";

  @override
  Widget build(BuildContext context) {
    TextInputType inputType = widget.inputType ;
    var layout;
    if(widget.textBoxType == 2){
      layout = TextFormField(
          decoration: InputDecoration(
            
            
            enabledBorder:OutlineInputBorder(

              borderSide: BorderSide(
                color: Color(0xFF2A8D00),
                width: 3.0,    
                  
              ),

              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )
            ),
            
            hintText: widget.hintText,
            helperText: widget.helpText,
            labelText: widget.labelText,
           
          
          errorStyle: TextStyle(
            color:Color(0x00ff0000),
          ),

            // add Icon
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0),
              child: new Icon(widget.iconName),
            ),

            prefixText: widget.prifix,
            suffixText: widget.suffix,
            suffixStyle: const TextStyle(color: Colors.grey,fontSize: 12.0),
            prefixStyle: const TextStyle(color: Colors.grey,fontSize: 12.0),

          ),
          
          autocorrect: widget.autoCorrect,
          maxLength: widget.maxLength,
          enabled: true,
          keyboardType:inputType,
          maxLines: widget.maxLines,
          //hide the text (e.g., for passwords).
          obscureText: widget.obscureText,
          
          onSaved: (text) {
            textboxValue = text;
            return text;
          },
 
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20.0,
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
          
          
          
          validator: (value) {

            if(widget.validationKey == "emptyCheck"){
              
              if (value.isEmpty) {  
                return 'Please enter some text';
              }
            
            }
            
            else if(widget.validationKey == "emailCheck"){
              if (value.isEmpty || !value.contains('@')) {  
                return 'Please enter some text';
              }
            }

            else if(widget.validationKey == "idCheck"){
              RegExp regExp = new RegExp(r"^[0-9]{9}[v|a]{1}",
                caseSensitive: false,
                multiLine: false,
              );

              print("length "+value.length.toString());
              if ( value.length != 10) {  
                return 'Invalid id number';
              }
              else if(!(regExp.hasMatch(value))){
                return 'Invalid id number';
              }
            
            }
          },
          
          );
    }

    else if (widget.textBoxType == 1){
      layout = TextFormField(
          decoration: InputDecoration(
            
            
            enabledBorder:OutlineInputBorder(

              borderSide: BorderSide(
                color: Color(0xFF2A8D00),
                width: 3.0,    
                  
              ),

              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )
            ),
            
            hintText: widget.hintText,
            helperText: widget.helpText,
            labelText: widget.labelText,
           
          
          errorStyle: TextStyle(
            color:Color(0x00ff0000),
          ),

            

            prefixText: widget.prifix,
            suffixText: widget.suffix,
            suffixStyle: const TextStyle(color: Colors.grey,fontSize: 12.0),
            prefixStyle: const TextStyle(color: Colors.grey,fontSize: 12.0),

          ),
          
          autocorrect: widget.autoCorrect,
          maxLength: widget.maxLength,
          enabled: true,
          keyboardType:inputType,
          maxLines: widget.maxLines,
          //hide the text (e.g., for passwords).
          obscureText: widget.obscureText,
          
          onSaved: (text) {
            textboxValue = text;
            print("First text field: $text");
            return text;
          },
 
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20.0,
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
          
          
          
          validator: (value) {
            print(widget.validationKey);
            if(widget.validationKey == "emptyCheck"){
              
              if (value.isEmpty) {  
                return 'Please enter some text';
              }
            
            }
            
            else if(widget.validationKey == "idCheck"){
              RegExp regExp = new RegExp(r"^[0-9]{9}[v|a]{1}",
                caseSensitive: false,
                multiLine: false,
              );

              print("length "+value.length.toString());
              if ( value.length != 10) {  
                return 'Invalid id number';
              }
              else if(!(regExp.hasMatch(value))){
                return 'Invalid id number';
              }
            
            }

            else if(widget.validationKey == "year"){
              
              if (value.length != 4) {  
                return 'Invalid year';
              }
              else{
                if(!isNumeric(value)){
                  return 'Enter a numeric value';
                }
              }
            
            }

            else if(widget.validationKey == "month"){
              
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              else{
                if(!isNumeric(value)){
                  return 'Enter a numeric value';
                }
                else if(int.parse(value)>12 || int.parse(value)<0 ){
                  return 'invalid month';
                }
              }
            
            }

            else if(widget.validationKey == "day"){
              
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              else{
                if(!isNumeric(value)){
                  return 'Enter a numeric value';
                }
                else if(int.parse(value)>30 || int.parse(value)<0 ){
                  return 'invalid date';
                }
              }
            
            }

             else if(widget.validationKey == "numberCheck"){
              
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              else{
                if(!isNumeric(value)){
                  return 'Enter a numeric value';
                }
              }
            
            }

            else if(widget.validationKey == "emailCheck"){
              if (value.isEmpty || !value.contains('@')) {  
                return 'Please enter some text';
              }
            }
          },
          
      );
    }
    

    return (Theme(
      data: new ThemeData(
        primaryColor: Color(0xFF2A8D00),
        primaryColorDark: Color(0xFF2A8D00),
        fontFamily: "Roboto",
      ),
      child: layout ,
    ));
  }
}
