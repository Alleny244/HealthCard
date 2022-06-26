import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import './view_customers.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _ShopkeeperHomePageState createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User shopkeeper;
  TextEditingController shopNameC = TextEditingController();
  TextEditingController shopkeeperNameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  TextEditingController pidC = TextEditingController();
  Map datas = {};
  String email, uid;
  String shopName, shopkeeperName, address, vaccine;
  DateTime date;
  String imageUrl;
  int check = 0;
  String i = "";
  bool dataExists = false, imageExists = false, imageLoading = false;
  String pid = "";
  void add() {
    shopName = shopNameC.text.toString();
    shopkeeperName = shopkeeperNameC.text.toString();
    address = addressC.text.toString();
    vaccine = vaccineC.text.toString();

    CollectionReference users = firestore.collection('Shopkeeper');
    users.doc(uid).set({
      'shopName': shopName,
      'shopkeeperName': shopkeeperName,
      'address': address,
      'imageUrl': i,
    }).then((value) => print("added"));

    firestore
        .collection("Shopkeeper")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          email = shopkeeper.email;
          date = shopkeeper.metadata.lastSignInTime;
          imageUrl = datas['imageUrl'].toString();
          shopName = datas['shopName'].toString();
          shopkeeperName = datas['shopkeeperName'].toString();
          address = datas['address'].toString();
          vaccine = datas['vaccine'].toString();
          dataExists = true;
        });
      } else {
        setState(() {
          dataExists = false;
        });
      }
    });
  }

  void patientDetail() async {
    String vaccine = pidC.text.toString();
    String x = "";
    FirebaseFirestore.instance
        .collection('users')
        .where('vaccine', isEqualTo: vaccine)
        .get()
        .then((querySnapshot) {
      print(querySnapshot.docs[0].reference.id);
      firestore
          .collection("users")
          .doc(querySnapshot.docs[0].reference.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          datas = documentSnapshot.data();
          print(datas['name']);
          Navigator.pushNamed(context, '/addPatient', arguments: {
            'datas': datas,
            'id': querySnapshot.docs[0].reference.id,
          });
        } else {
          print("No patient");
        }
      });
    });
    print("idss is ${x}");
  }

  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile image;
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        Reference reference =
            FirebaseStorage.instance.ref().child('Shopkeeper/').child(uid);
        UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
          var url = await uploadTask.snapshot.ref.getDownloadURL();

          print(url);
          i = url;
          print(i);
          print("image added");
        });
      }
    } else {
      print("Grant permission");
    }
  }

  @override
  void initState() {
    super.initState();
    shopkeeper = FirebaseAuth.instance.currentUser;
    uid = shopkeeper.uid;
    email = shopkeeper.email;

    FirebaseFirestore.instance
        .collection("Shopkeeper")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();

          imageUrl = datas['imageUrl'];
          shopName = datas['shopName'];
          address = datas['address'];
          shopkeeperName = datas['shopkeeperName'];
          vaccine = datas['vaccine'];
          dataExists = true;
        });
      } else {
        setState(() {
          dataExists = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (imageUrl == null && imageExists == true) {
    //   setState(() {
    //     imageLoading = true;
    //   });
    // } else {
    //   setState(() {
    //     imageLoading = false;
    //   });
    // }
    return (!dataExists)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Doctor Page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Doctor Name",
                        ),
                        controller: shopNameC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Hospital Name",
                        ),
                        controller: shopkeeperNameC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Specialisation",
                        ),
                        controller: addressC,
                      ),
                      ElevatedButton(
                        onPressed: imageUpload,
                        child: Text("Upload photo"),
                      ),
                      ElevatedButton(
                        onPressed: add,
                        child: Text("Add"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          customerSignout();
                          Navigator.pushNamed(context, '/selectUserType');
                        },
                        child: Text("logout"),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Doctor page"),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(shopkeeperName),
                    accountEmail: Text(email),
                    currentAccountPicture:
                        imageUrl == null && imageExists == false
                            ? CircleAvatar(
                                radius: 40,
                              )
                            : imageLoading
                                ? SpinKitRotatingCircle(
                                    color: Colors.white,
                                    size: 50.0,
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_rounded),
                    title: Text("View customers"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewCustomers()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.update_sharp),
                    title: Text("Update Fields"),
                    onTap: () {
                      Navigator.pushNamed(context, '/shopkeeperUpdate');
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
                  imageUrl == null && imageExists == false
                      ? CircleAvatar(
                          radius: 80,
                        )
                      : imageLoading
                          ? SpinKitRotatingCircle(
                              color: Colors.white,
                              size: 50.0,
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                  SizedBox(height: 20),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Name"),
                    subtitle: Text(shopName),
                  ),
                  // SizedBox(height: 10),
                  // ListTile(
                  //   tileColor: Colors.grey[100],
                  //   title: Text("Email"),
                  //   subtitle: Text(email),
                  // ),
                  SizedBox(height: 10),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Specialisation"),
                    subtitle: Text(address),
                  ),
                  SizedBox(height: 10),
                  // ListTile(
                  //   tileColor: Colors.grey[100],
                  //   title: Text("Vaccine Status"),
                  //   subtitle: Text(vaccine),
                  // ),
                  // SizedBox(height: 10),
                  // ListTile(
                  //   tileColor: Colors.grey[100],
                  //   title: Text("Shopkeeper Name"),
                  //   subtitle: Text(shopkeeperName),
                  // ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 230,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Patient Id",
                        // errorText: errorEmail == " " ? null : '$errorEmail',
                        hintText: "xxxxx",
                      ),
                      controller: pidC,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/qrGenerator', arguments: {
                      //   'uid': uid,
                      // });
                      patientDetail();
                    },
                    icon: Icon(Icons.search),
                    label: Text("Search"),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
  }
}
