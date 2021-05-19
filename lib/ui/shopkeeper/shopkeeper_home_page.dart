import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../flutterfire/shopkeeper.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

FirebaseStorage _storage;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User shopUser;

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _ShopkeeperHomePageState createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  TextEditingController shopNameC = TextEditingController();
  TextEditingController shopkeeperNameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  Map datas = {};
  List list = [];
  String shopName, shopkeeperName, address, vaccine, email, uid;
  String sN, skName, a, v;
  DateTime date;
  String i, imageUrl;
  int check = 0;

  bool dataExists = false;

  void add() {
    shopName = shopNameC.text.toString();
    shopkeeperName = shopkeeperNameC.text.toString();
    address = addressC.text.toString();
    vaccine = vaccineC.text.toString();
    setState(() {
      email = shopUser.email;
      date = shopUser.metadata.lastSignInTime;
    });

    print(date);

    CollectionReference users = firestore.collection('Shopkeeper');
    users.doc(uid).set({
      'shopName': shopName,
      'shopkeeperName ': shopkeeperName,
      'address': address,
      'imageUrl': i,
      'vaccine': vaccine,
    }).then((value) => print("added"));
    setState(() {
      dataExists = true;
    });
    firestore
        .collection("Shopkeeper")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          email = shopUser.email;
          date = shopUser.metadata.lastSignInTime;
          datas = documentSnapshot.data();
          list = datas.values.toList();
          print(list);
          imageUrl = list[3];
          sN = list[4];
          a = list[2];
          skName = list[0];
          v = list[1];
          dataExists = true;
        });
      } else {
        setState(() {
          dataExists = false;
        });
      }
    });
  }

  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        _storage = FirebaseStorage.instance;
        var snapshot =
            _storage.ref().child('shop/images/').putFile(file).snapshot;
        var url = await snapshot.ref.getDownloadURL();
        print(url);
        setState(() {
          i = url;
        });
        //   Fluttertoast.showToast(
        //       msg: "Upload Complete",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.grey[400],
        //       textColor: Colors.white,
        //       fontSize: 16.0);
      }
    } else {
      print("Grant permission");
    }
//select image
// upload to storage
  }

  @override
  void initState() {
    super.initState();
    shopUser = FirebaseAuth.instance.currentUser;
    uid = shopUser.uid;
    firestore
        .collection("Shopkeeper")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          list = datas.values.toList();

          imageUrl = list[3];
          sN = list[4];
          a = list[2];
          skName = list[0];
          v = list[1];

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
    print(list);
    // if (check == 0) {
    //   String uid = FirebaseAuth.instance.currentUser.uid;
    //   DocumentReference documentReference =
    //       FirebaseFirestore.instance.collection('Shopkeeper').doc(uid);

    //   FirebaseFirestore.instance.runTransaction((transaction) async {
    //     DocumentSnapshot snapshot = await transaction.get(documentReference);
    //     Map<String, Object> data = snapshot.data();

    //     if (snapshot.exists) {
    //       setState(() {
    //         dataExists = true;
    //         shopName = data['shopName'].toString();
    //         shopkeeperName = data['shopkeeperName'].toString();
    //         address = data['address'].toString();
    //         vaccine = data['vaccineStatus'].toString();
    //         print(data);
    //       });
    //     } else
    //       setState(() {
    //         dataExists = false;
    //         shopName = address = shopkeeperName = vaccine = "";
    //       });
    //   });
    //   check++;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopkeeper Page"),
        centerTitle: true,
      ),
      body: (!dataExists)
          ? SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Shop Name",
                        ),
                        controller: shopNameC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Shopkeeper Name",
                        ),
                        controller: shopkeeperNameC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Address",
                        ),
                        controller: addressC,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Vaccine Status",
                        ),
                        controller: vaccineC,
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
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Shop Name"),
                    subtitle: Text(sN),
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
                    title: Text("Adress"),
                    subtitle: Text(a),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Vaccine Status"),
                    subtitle: Text(v),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: Text("Shopkeeper Name"),
                    subtitle: Text(skName),
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
                      Navigator.pushNamed(context, '/qrGenerator', arguments: {
                        'uid': uid,
                      });
                    },
                    icon: Icon(Icons.qr_code_outlined),
                    label: Text("Generate QR"),
                  ),
                  SizedBox(height: 20),
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
    );
  }
}
