import 'package:first/ambulance/ambulanceHome.dart';
import 'package:first/doctor/doctorHome.dart';
import 'package:first/nurse/nurseHome.dart';
import 'package:first/otherService/otherServiceHome.dart';
import 'package:first/pharmacist/PharmacistHome.dart';
import 'package:flutter/material.dart';
import 'package:first/login.dart';
import 'package:first/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first/Const.dart';
import 'package:first/home.dart';


void main() => runApp(home());

class home extends StatefulWidget {
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: homeContain(),
    );
  }
}

class homeContain extends StatefulWidget {
  _homeContainState createState() => _homeContainState();
}

class _homeContainState extends State<homeContain> {

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = (prefs.getString("ID") ?? '0');
    String type = (prefs.getString("Type") ?? '0');
    
    //goto home page if user loged into the system before
    if(id != '0'){
      Const.id=id;
      print("const.id"+Const.id);

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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.topCenter,
                        
          
            
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color:Color(0xFFFF7D05), width: 8.0),
                  borderRadius: BorderRadius.circular(42.0),
                  color: Colors.white

                ),  
              ),

              Padding(
                padding: EdgeInsets.only(top: 150.0),
                child:Container(
                  height: 101.0,
                  width: 315.0,
                  decoration:BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/logo.jpeg"),
                    ), 
                    border:Border(bottom:BorderSide(color:Color(0xFFFF7D05), width: 5.0)),
                    
                  ),
                ), 
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(left: 70.0,right: 70.0),
                      child: GestureDetector(

                          child: Container(  
                            margin: EdgeInsets.only(top: 450.0),
                            alignment: Alignment.center,
                            height: 60.0,
                            decoration: BoxDecoration(
                              border: Border.all(color:Color(0xFFFF7D05), width: 3.0),
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.white

                            ),
                            child: Text("log in",
                                style:TextStyle(
                                      fontSize: 25.0, 
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                          ),

                          onTap:(){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context)=> login(),
                            ));
                          } ,
                        ),
                    ),
                    
                  ),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:Padding(
                      padding: EdgeInsets.only(left: 70.0,right: 70.0),
                      child: GestureDetector(

                          child: GestureDetector(

                            child: Container(  
                              margin: EdgeInsets.only(top: 530.0),
                              alignment: Alignment.center,
                              height: 60.0,
                              decoration: BoxDecoration(
                                border: Border.all(color:Color(0xFFFF7D05), width: 3.0),
                                borderRadius: BorderRadius.circular(50.0),
                                color: Colors.white

                              ),
                              child: Text("Sign in",
                                  style:TextStyle(
                                        fontSize: 25.0, 
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                            ),

                            onTap:(){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context)=> signin(),
                            ));
                          } ,
                          ),

                          
                        ),
                    ),
                    
                  ),
                ],
              ),
              Align(
                
                alignment: Alignment.bottomCenter,
                child:Row(
                  
                  children: <Widget>[
                    Expanded(
                      child:Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child:Container(  
                              alignment: Alignment.bottomCenter,
                              height: 122.0,
                              width: 180.0,
                              decoration:BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/images/background.png"),
                                ), 
                                
                              ),

                            ),
                      )
                      
                    ),
                    
                  ],

               ),

             ),
              
              
            ],
          
        
      ),
    );
  }
}
