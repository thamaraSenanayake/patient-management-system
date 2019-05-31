import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

Future launchURL(String url) async{
    
    if(await canLaunch(url)){
      
      await launch(url,forceSafariVC:false,forceWebView:false);
    }
    else{
      print("cant");
    }
  }