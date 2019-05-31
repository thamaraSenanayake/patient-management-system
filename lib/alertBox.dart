import 'package:flutter/material.dart';

void showAlert(String text,context){
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