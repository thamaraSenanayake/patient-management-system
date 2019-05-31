import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/Details.dart';
import 'package:first/const.dart';


Future<List> getChildren(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getChildren.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> takeData(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getClinicRecoders.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  print(response.body);
  return json.decode(response.body);
}

Future<List> getUserDetails(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getUserDetails.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> getMedicine(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getMedicine.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> getMedicineToclinicRecord(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getMedicineToclinicRecord.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> getReportRecoders(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getReportRecoders.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> getAssignPatient(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getAssignPatient.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> getPatientDetails(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getPatientDetails.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<List> searchPatient(String id,String search) async {
  var url= "http://" + Const.ip + "/eMedicine/searchPatient.php";
  final response = await http.post(url,body: {
    "id":id,
    "search":search
  });
  return json.decode(response.body);
}

Future<List> getClinicRecodersToPrecription(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/getClinicRecodersToPrecription.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  return json.decode(response.body);
}

Future<double> calcBmi(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/calcBmi.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  
  return json.decode(response.body);
}

Future<String> removeMedicine(String id) async {
  var url= "http://" + Const.ip + "/eMedicine/removeMedicine.php";
  final response = await http.post(url,body: {
    "id":id,
  });
  
  return json.decode(response.body);
}

Future<String> updateMedicine(String id,String startDate,String endDate,String medicine,String count,String time,var after_before) async {
  var url= "http://" + Const.ip + "/eMedicine/updateMedicine.php";
  
  final response = await http.post(url,body: {
    "id":id,
    "startDate":startDate,
    "endDate":endDate,
    "medicine":medicine,
    "count":count,
    "time":time,
    "after_before":after_before,   
  });
  return json.decode(response.body);
}

Future<String> updateHieghtWeight(String id,String height,String weight) async {
  var url= "http://" + Const.ip + "/eMedicine/updateHieghtWeight.php";
  final response = await http.post(url,body: {
    "id":id,
    "height":height,
    "weight":weight,
  });
  return json.decode(response.body);
}

Future<String> addPatientRecord(String patientID,String doctorID,String title,String description) async {
  var url= "http://" + Const.ip + "/eMedicine/addPatientRecord.php";
  final response = await http.post(url,body: {
    "patientID":patientID,
    "doctorID":doctorID,
    "title":title,
    "description":description,
  });
  return json.decode(response.body);
}

Future<String> addPrescription(String clinicRecord,String startDate,String endDate,String medicine,String count,String time,var after_before) async {
  var url= "http://" + Const.ip + "/eMedicine/addPrescription.php";
  
  final response = await http.post(url,body: {
    "clinicRecord":clinicRecord,
    "startDate":startDate,
    "endDate":endDate,
    "medicine":medicine,
    "count":count,
    "time":time,
    "after_before":after_before,   
  });
  return json.decode(response.body);
}

Future<String> dataBaseSignIn(String id, String name,String email,String password,String DOB,String weight,String height,String gender, String bloodGroup,String province, String district,String city) async{
    var url = "http://"+Const.ip+"/eMedicine/adddata.php";
    print(DOB+" "+gender);
    final response = await http.post(url,body: {
       "id":id,
       "name":name,
       "email":email,
       "password":password,
       "gender":gender,
       "DOB":DOB,
       "bloodGroup":bloodGroup,
       "height":height,
       "weight":weight,
       "province":province,
       "district":district,
       "city":city
    });
    return json.decode(response.body); 
}


Future<String> createAccoutForChild(String currentId,String id,String email,String password,String province, String district,String city) async{
    var url = "http://"+Const.ip+"/eMedicine/createAccoutForChild.php";
              
    final response = await http.post(url,body: {
       "currentId": currentId,
       "id":id,
       "email":email,
       "password":password,
       "province":province,
       "district":district,
       "city":city
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> addChildDatabase(String name,String DOB,String weight,String height,String gender, String bloodGroup,String parentId) async{
    var url = "http://"+Const.ip+"/eMedicine/addChild.php";
    final response = await http.post(url,body: {
       "name":name,
       "gender":gender,
       "DOB":DOB,
       "bloodGroup":bloodGroup,
       "height":height,
       "weight":weight,
       "parentId":parentId
    });
    return json.decode(response.body); 
}

Future<String> dataBaseLogIn(String id, String password) async{
    var url = "http://"+Const.ip+"/eMedicine/login.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "password":password,
    });
    
    return json.decode(response.body); 
}


Future<String> assignDoctor(String patientID, String city,String title,String description) async{
    var url = "http://"+Const.ip+"/eMedicine/assignDoctor.php";
    
    final response = await http.post(url,body: {
       "patientID":patientID,
       "city":city,
       "title":title,
       "description":description,
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<String> assignOtherService(String patientID, String city,String type,String description) async{
    var url = "http://"+Const.ip+"/eMedicine/assignOtherService.php";
    
    final response = await http.post(url,body: {
       "patientID":patientID,
       "city":city,
       "type":type,
       "description":description,
    });
    
    return json.decode(response.body); 
}

Future<String> admitPatient(String patentId, String doctorId,String descrption) async{
    var url = "http://"+Const.ip+"/eMedicine/admitPatient.php";
    
    final response = await http.post(url,body: {
       "patentId":patentId,
       "doctorId":doctorId,
       "descrption":descrption,
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<bool> checkAdmit(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/checkAdmit.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> dischargePatient(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/dischargePatient.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> addRemovePatient(String patientId, String doctorId) async{
    var url = "http://"+Const.ip+"/eMedicine/addRemovePatient.php";
    
    final response = await http.post(url,body: {
       "patientId":patientId,
       "doctorId":doctorId
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<bool> checkAssign(String patientId,String doctorId) async{
    var url = "http://"+Const.ip+"/eMedicine/checkAssign.php";
    
    final response = await http.post(url,body: {
       "patientId":patientId,
       "doctorId":doctorId
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<String> addDeathReport(String patientId, String description) async{
    var url = "http://"+Const.ip+"/eMedicine/addDeathReport.php";
    
    final response = await http.post(url,body: {
       "id":patientId,
       "description":description
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<List> searchAssignPatient(String id, String search) async{
    var url = "http://"+Const.ip+"/eMedicine/searchAssignPatient.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "search":search
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<List> getWardPatient(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getWardPatient.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<List> searchWardPatient(String id, String search) async{
    var url = "http://"+Const.ip+"/eMedicine/searchWardPatient.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "search":search
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<List> getInvestigation(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getInvestigation.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> addMedicaleReport(String serviceProviderId, String patientId,String serviceId,String description, String title) async{
    var url = "http://"+Const.ip+"/eMedicine/addMedicaleReport.php";
    
    final response = await http.post(url,body: {
       "serviceProviderId":serviceProviderId,
       "patientId":patientId,
       "serviceId":serviceId,
       "title":title,
       "description":description
    });
    print(response.body);
    return json.decode(response.body); 
}



Future<List> giveMedicinePharmasist(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/giveMedicinePharmasist.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    return json.decode(response.body); 
}


Future<List> searchMedicinePharmasist(String id, String search) async{
    var url = "http://"+Const.ip+"/eMedicine/searchWardPatient.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "search":search
    });
    return json.decode(response.body); 
}

Future<List> getPrescriptionByCliniceRecord(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getPrescriptionByCliniceRecord.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> buyMedicine(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/buyMedicine.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> getAmbulance(String patientId,String city,String conNum) async{
    var url = "http://"+Const.ip+"/eMedicine/getAmbulance.php";
    
    final response = await http.post(url,body: {
       "patientId":patientId,
       "city":city,
       "conNum":conNum,
    });
    return json.decode(response.body); 
}


Future<List> getAmbulanceTrip(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getAmbulanceTrip.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<String> addNewPassword(String id,String password) async{
    var url = "http://"+Const.ip+"/eMedicine/addNewPassword.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "password":password,       
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<String> updatePassword(String id,String currentPassword,String newPasword) async{
    var url = "http://"+Const.ip+"/eMedicine/updatePassword.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "currentPassword":currentPassword,    
       "newPasword":newPasword,       
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> updateEmail(String id,String email) async{
    var url = "http://"+Const.ip+"/eMedicine/updateEmail.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "email":email,    
           
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<String> updateAddress(String id,String province,String district,String city) async{
    var url = "http://"+Const.ip+"/eMedicine/updateAddress.php";
    
    final response = await http.post(url,body: {
       "id":id,
       "province":province,    
       "district":district, 
       "city":city,    
           
    });
    print(response.body);
    return json.decode(response.body); 
}


Future<List> getAssignRequest(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getAssignRequest.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    print(response.body);
    return json.decode(response.body); 
}

Future<List> getAnalizeData(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/getAnalizeData.php";
    
    final response = await http.post(url,body: {
       "id":id,
    });
    return json.decode(response.body); 
}

Future<String> updateGetAmbulance(String id) async{
    var url = "http://"+Const.ip+"/eMedicine/updateGetAmbulance.php";
    
    final response = await http.post(url,body: {
       "id":id,     
    });
    
    print(response.body);
    return json.decode(response.body); 
}