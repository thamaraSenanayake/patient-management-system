import 'package:first/alertBox.dart';
import 'package:first/children/childHome.dart';
import 'package:first/doctor/patientPage.dart';
import 'package:first/pharmacist/PrescriptionSearch.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:first/Details.dart';
import 'package:first/const.dart';
import 'package:first/home.dart';
import 'package:first/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _medicineController = TextEditingController();
final _qtyController = TextEditingController();
final _dayCountController = TextEditingController();

class getPrescription extends StatefulWidget {
  String id;
  getPrescription({this.id});

  _getPrescriptionState createState() => _getPrescriptionState();
}

class _getPrescriptionState extends State<getPrescription> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: getDataContain(
        id: widget.id,
      ),
    );
  }
}

class getDataContain extends StatefulWidget {
  String id;

  getDataContain({this.id});
  _getDataContainState createState() => _getDataContainState();
}

class _getDataContainState extends State<getDataContain> {
  
  void doneClick() async {
    String response;
    await buyMedicine(widget.id).then((s) {
      response = s;
    });

    if (response == "DONE!") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PrescriptionSearch(),
          )
      );
    }
    else{
      showAlert(response,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("My Clinic Book"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionSearch(),
                  ));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List>(
          future: getPrescriptionByCliniceRecord(widget.id),
          builder: (ctx, ss) {
            if (ss.hasError) {
              print("error");
            }
            if (ss.hasData) {
              return item(list: ss.data);
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          doneClick();
        },
        foregroundColor: Colors.white,
        backgroundColor: Color(Const.orngeColor),
      ),
    );
  }
}

class item extends StatelessWidget {
  @override
  List list;

  item({this.list});

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (ctx, i) {
        String Duration = ((DateTime.parse(list[i]['endDate'])
                .difference(DateTime.parse(list[i]['startDate']))
                .inDays))
            .toString();

        return Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
              leading: Icon(Icons.note_add),
              title: Text(list[i]['medicine'] +
                  "    Qty. " +
                  list[i]['count'] +
                  " in " +
                  Duration +
                  " Days"),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Details(list: list, index: i),
                  ))),
        );
      },
    );
  }
}
