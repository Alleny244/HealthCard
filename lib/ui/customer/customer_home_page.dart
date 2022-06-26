import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pii/ui/customer/customerUpdate.dart';
import '../../flutterfire/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import './visited_shops.dart';
import 'package:intl/intl.dart';
// import 'package:fluttertoast/fluttertoast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage _storage;

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

bool dataFilled = false;
User userId;
Map datas = {};

var list = [];

class _CustomerHomePageState extends State<CustomerHomePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  int check = 0;
  String n = "";
  String a = "";
  String v = "";
  String i = " ";
  String uid = "";
  String imageUrl = " ";
  String name = " ";
  String body = " ";
  String email = "";
  DateTime date;
  String address = "";
  String vaccine = "";
  String shopkeeperUid;

  Future<void> scan() async {
    String codeSanner = await BarcodeScanner.scan();
    shopkeeperUid = codeSanner.toString();
    var time = DateTime.now();
    print(shopkeeperUid);
    try {
      var obj = [
        {'shopkeeperUid': shopkeeperUid, 'time': time}
      ];
      String customerUid = FirebaseAuth.instance.currentUser.uid;
      FirebaseFirestore.instance
          .collection("users")
          .doc(customerUid)
          .update({"visitedStores": FieldValue.arrayUnion(obj)});

      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(customerUid)
          .get();
      print("<><><><><><><>><><>");
      print(snapshot.data());
      print("<><><><><><><>><><>");

      var custObj = [
        {'customerUid': customerUid.toString(), 'time': time}
      ];
      FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .update({"customers": FieldValue.arrayUnion(custObj)});

      var snapshotOfShopkeeper = await FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .get();
      print("<><><><><><><>><><>");
      print(snapshotOfShopkeeper.data());
      print("<><><><><><><>><><>");
    } catch (e) {
      print("<>\n<><>><><><\n\n${e.toString()}\n\n<><><><><>\n<");
    }
  }

  void add() {
    n = nameC.text.toString();
    a = addressC.text.toString();
    v = vaccineC.text.toString();

    // print(date);

    CollectionReference users = firestore.collection('users');
    users.doc(uid).set({
      'name': n,
      'address': a,
      'vaccine': v,
      'imageUrl': i,
    }).then((value) => print("added"));

    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          email = userId.email;
          date = userId.metadata.lastSignInTime;
          imageUrl = datas['imageUrl'].toString();
          name = datas['name'].toString();
          address = datas['address'].toString();
          vaccine = datas['vaccine'].toString();
          dataFilled = true;
          print("$imageUrl   $name    $address     $vaccine");
        });
      } else {
        setState(() {
          dataFilled = false;
        });
      }
    });
  }

//   void imageUpload() async {
//     var url;
//     final _pickr = ImagePicker();
//     PickedFile image;
// //handle permission
//     var permissionstatus = await Permission.photos.request();
//     if (permissionstatus.isGranted) {
//       image = await _pickr.getImage(source: ImageSource.gallery);
//       var file = File(image.path);
//       if (image != null) {
//         // FirebaseStorage.instance.ref('customer/$uid').putFile(file);
//         // var url = await FirebaseStorage.instance
//         //     .ref('customer/$uid')
//         //     .getDownloadURL();

//         // var snapshots =
//         //     _storage.ref().child('customers/$uid').putFile(file).snapshot;
//         // url = await snapshots.ref.getDownloadURL();

//         Reference reference =
//             FirebaseStorage.instance.ref().child('Customer/').child(uid);
//         UploadTask uploadTask = reference.putFile(file);
//         await uploadTask.whenComplete(() async {
//           url = await uploadTask.snapshot.ref.getDownloadURL();
//         });

//         print(url);
//         i = url;
//         print(i);
//         print("image added");

//         //   Fluttertoast.showToast(
//         //       msg: "Upload Complete",
//         //       toastLength: Toast.LENGTH_SHORT,
//         //       gravity: ToastGravity.CENTER,
//         //       timeInSecForIosWeb: 1,
//         //       backgroundColor: Colors.grey[400],
//         //       textColor: Colors.white,
//         //       fontSize: 16.0);
//       }
//     } else {
//       print("Grant permission");
//     }
// //select image
// // upload to storage
//   }
  var visitedStoresList;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser;
    uid = userId.uid;
    print('X${uid}');

    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          email = userId.email;
          datas = documentSnapshot.data();
          list = datas.values.toList();
          print(list);
          // imageUrl = list[2];
          imageUrl = datas['imageUrl'];
          // name = list[3];
          name = datas['name'];
          // address = list[1];
          address = datas['address'];
          // vaccine = list[0];
          vaccine = datas['vaccine'];
          dataFilled = true;
          print("Details$imageUrl   $name    $address     $vaccine");
          getVisitedStoresInfo();
        });
      } else {
        setState(() {
          print("new form");
          dataFilled = false;
        });
      }
    });
  }

  Future getVisitedStoresInfo() async {
    Map customerData;

    var customerUid = FirebaseAuth.instance.currentUser.uid;
    print(" d ${customerUid}");
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(customerUid)
        .get();
    customerData = documentSnapshot.data();
    print("aaa ${customerData}");

    print("hello");
    print(customerData['record'][0].toString());
    visitedStoresList = customerData['record'];

    visitedStoresList.forEach((visitedStore) async {
      print("the element is " + visitedStore.toString());
    });
  }

  Widget build(BuildContext context) {
    return (!dataFilled)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Patient page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Name",
                        ),
                        controller: nameC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Address",
                        ),
                        controller: addressC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Patient Id",
                        ),
                        controller: vaccineC,
                      ),
                      // ElevatedButton(
                      //   onPressed: imageUpload,
                      //   child: Text("Upload photo"),
                      // ),
                      ElevatedButton(
                        onPressed: add,
                        child: Text("Add"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Patient page"),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(name),
                    accountEmail: Text(email),
                    // currentAccountPicture: CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage: NetworkImage(imageUrl),
                    // ),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_rounded),
                    title: Text("View visited shops"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisitedShops()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.update_sharp),
                    title: Text("Update Fields"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerUpdate()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {
                      customerSignout();
                      Navigator.pushNamed(context, '/selectUserType');
                    },
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // CircleAvatar(
                  //   radius: 80,
                  //   backgroundImage: NetworkImage(imageUrl),
                  // ),
                  SizedBox(height: 20),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 30),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView(
                        children: visitedStoresList.map<Widget>((e) {
                          return Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Hospital Name : ${e['hname']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Doctor Name: ${e['dname']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Disease: ${e['disease']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          "Time: " +
                                              DateFormat.MMMd().add_jm().format(
                                                  DateTime.parse(e['date']
                                                      .toDate()
                                                      .toString())),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  // ElevatedButton.icon(
                  //   icon: Icon(Icons.camera_alt),
                  //   label: Text("Scan QR"),
                  //   onPressed: scan,
                  // ),
                ],
              ),
            ),
          );
  }
}
