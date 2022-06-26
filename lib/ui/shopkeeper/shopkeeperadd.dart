import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPatient extends StatefulWidget {
  @override
  State<AddPatient> createState() => _AddPatientState();
}

Map customerData;

class _AddPatientState extends State<AddPatient> {
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    String id = data['id'];

    customerData = data['record'];

    print("ss $customerData");
    return (customerData != null)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Patient Details"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text(data['datas']['name']),
                  subtitle: Text(data['datas']['vaccine']),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/record', arguments: {
                      'id': id,
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Add Record",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Patient Details"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text(data['datas']['name']),
                  subtitle: Text(data['datas']['vaccine']),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/record', arguments: {
                      'id': id,
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Add Record",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ),
              ],
            ),
          );
  }
}
