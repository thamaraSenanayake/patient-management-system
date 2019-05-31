import 'package:flutter/material.dart';

class StackIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.green,
                  ),
                  child: Icon(Icons.local_offer, color: Colors.white),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50.0, top: 50.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.red,
                  ),
                  child: Icon(Icons.home, color: Colors.white),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50.0, top: 50.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.yellow,
                  ),
                  child: Icon(Icons.local_car_wash, color: Colors.white),
                ),
                Container(
                  margin: EdgeInsets.only(left: 120.0, top: 00.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.lightBlue,
                  ),
                  child: Icon(Icons.map, color: Colors.white),
                ),
              ],
            );
    
  }
}