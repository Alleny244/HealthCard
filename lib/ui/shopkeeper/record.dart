import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class Record extends StatefulWidget {
  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  TextEditingController emailC = TextEditingController();
  TextEditingController pswdC = TextEditingController();
  TextEditingController cpswdC = TextEditingController();
  TextEditingController regC = TextEditingController();
  String email = "";
  String pswd = "";
  String cpswd = "";
  String errorcpswd = "";
  String errorEmail = "";
  String displayMsg = "";
  String reg = " ";
  String errorReg = " ";
  DateTime date;
  String hname = "";
  String dname = "";
  Map datas = {};
  User shopkeeper;
  String id;
  @override
  void initState() {
    super.initState();
    shopkeeper = FirebaseAuth.instance.currentUser;
    String uid = shopkeeper.uid;
    email = shopkeeper.email;
    date = shopkeeper.metadata.lastSignInTime;

    FirebaseFirestore.instance
        .collection("Shopkeeper")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        datas = documentSnapshot.data();
        print(datas);
        hname = datas['shopkeeperName'];
        dname = datas['shopName'];
      } else {}
    });
  }

  void submit() {
    String medicine = pswdC.text.toString();
    String disease = emailC.text.toString();
    var obj = [
      {
        'medicine': medicine,
        'disease': disease,
        'date': date,
        'hname': hname,
        'dname': dname
      }
    ];
    FirebaseFirestore.instance.collection('users').doc(id).update(
        {"record": FieldValue.arrayUnion(obj)}).then((value) => print("added"));
    // Navigator.pushNamed(context, '/shopkeeperRegister');
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    id = data['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Record"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox.fromSize(
                  size: Size.fromHeight(60),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Disease",
                    errorText: errorEmail == "" ? null : '$errorEmail',
                    hintText: "Viral Fever",
                  ),
                  controller: emailC,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Medicine",
                  ),
                  controller: pswdC,
                ),
                // TextField(
                //   decoration: InputDecoration(
                //     errorText: errorcpswd == "" ? null : '$errorcpswd',
                //     labelText: "Confirm password",
                //   ),
                //   controller: cpswdC,
                // ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: submit,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(displayMsg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
