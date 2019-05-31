import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:first/module/http_req.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUploader extends StatefulWidget {
  String text;
  bool error = false;

  ImageUploader({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  ImageUploaderState createState() => ImageUploaderState();
}

class ImageUploaderState extends State<ImageUploader> {
  String image = "no image selected";
  var imageFile;
  String userId;

  Http_Request _req;

  @override
  void initState() {
    getId();
    _req = new Http_Request();
  }

  void getId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = (prefs.getString("ID") ?? '0');
  }

  Future getImageGallery() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      List<String> pathString = imageFile.path.split(new RegExp(r"/"));
      image = pathString[pathString.length - 1];
      print(imageFile.lengthSync());
      widget.error = false;
    });
  }

  void errorDisplay() {
    setState(() {
      image = "select image";
      widget.error = true;
    });
  }

  //Post data to server
  void postData() async {
    var param = {
      "uploaded_file":await new UploadFileInfo(imageFile, _req.getFileName(imageFile.path)),
      "id":userId
    };

    String data = await _req.postRequest("/req_data.php", param);
    print("response: " + data.toString());
  }

  @override
  Widget build(BuildContext context) {
    var layout = Row(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color:Color(Const.greenColor),
          splashColor:Color(Const.orngeColor),
          padding: EdgeInsets.all(12.0),

          //Rounded edges
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),

          //Button on pressed event
          onPressed: getImageGallery,

          //Button text
          child: Text(
            widget.text, //Text
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right:8.0),
        ),
        Flexible(
          child: Container(          
            child: widget.error == false
                ? Text(image,overflow: TextOverflow.ellipsis,style: TextStyle(color: Color(Const.blackColor),))
                : Text(image, style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
   
    return (Theme(
      data: new ThemeData(
        accentColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      child: layout,
    ));
  }
}
