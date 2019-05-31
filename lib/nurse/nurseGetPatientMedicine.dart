import 'package:first/nurse/wardPatientSearch.dart';
import 'package:flutter/material.dart';
import 'package:first/const.dart';
import 'package:first/database.dart';

final _medicineController = TextEditingController();
final _qtyController = TextEditingController();
final _dayCountController = TextEditingController();

class nurseGetPatientMedicine extends StatefulWidget {
  String id;
  nurseGetPatientMedicine({this.id});

  _nurseGetPatientMedicineState createState() => _nurseGetPatientMedicineState();
}


class _nurseGetPatientMedicineState extends State<nurseGetPatientMedicine> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "first ui interface",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Roboto"),
      home: getDataContain(id: widget.id,),
    );
  }
}

class getDataContain extends StatefulWidget {
  String id;

  getDataContain({this.id});
  _getDataContainState createState() => _getDataContainState();
}

class _getDataContainState extends State<getDataContain> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Const.orngeColor),
        title: Text("Patient Medicine"),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => wardPatientSearch(),
                  ));  
                            
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List>(
          future: getMedicine(widget.id),
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
        String time;
        String afterBefore;

        if (list[i]['time'] == '1') {
          time = "Morning";
        } else if (list[i]['time'] == '2') {
          time = "noon";
        } else if (list[i]['time'] == '3') {
          time = "Night";
        }

        if (list[i]['after_before'] == '1') {
          afterBefore = "after";
        }

        if (list[i]['after_before'] == '2') {
          afterBefore = "before";
        }
        return Card(
          elevation: 2.0,
          color: Colors.white,
          child: ListTile(
            title: Text('take ' +
                list[i]['count'] +
                ' ' +
                list[i]['medicine'] +
                '   take it at ' +
                time.toString()),
            subtitle: Text(afterBefore.toString() + ' having your meal'),
            
          ),
        );



      },
    );
  }
}
