import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:first/const.dart';

class Http_Request {
  Dio _dio;
  Uuid _uuid;
  Response _response;
  String _file_name;

  String get file_name => _file_name;

  Http_Request() {
    _dio = new Dio();
    _dio.options.baseUrl = Const.imageUploader;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 5000;
    _uuid = new Uuid();
  }
  
  //Returns a unique file name to save on server
  String getFileName(String filePath) {
    String path = "";
    
    //Set File name (Unique name)
    List<String> pathString = filePath.split('/');
    _file_name =
        getUniqueID() + '.' + pathString[pathString.length - 1].split('.')[1];
    pathString[pathString.length - 1] = _file_name;
    for (final item in pathString) {
      if (pathString[0] != item) {
        path += "/" + item;
      }
    }
    return path;
  }

  //Post data to the server
  Future<String> postRequest(String url, var param) async {
    try {
      //Set Form data
      FormData formData = new FormData.from(param);

      //Send post value
      _response = await _dio.post(url, data: formData);
      return _response.toString();
    } on Exception {
      return "Error!";
    }
  }

  //Generate a Unique ID
  String getUniqueID() {
    return _uuid.v1();
  }
}
