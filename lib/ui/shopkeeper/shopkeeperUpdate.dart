import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:fluttertoast/fluttertoast.dart';

bool defaultData = false;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage _storage;
User shopUser;

class ShopkeeperUpdate extends StatefulWidget {
  @override
  _ShopkeeperUpdateState createState() => _ShopkeeperUpdateState();
}

bool dataFilled = false;

User userId;
Map datas = {};

var list = [];

class _ShopkeeperUpdateState extends State<ShopkeeperUpdate> {
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
  bool imageChanged = false;
  bool dataExists = false;
  String u = "";

  void cancel() {
    Navigator.pushReplacementNamed(context, '/shopkeeperHomePage');
  }

  void update() {
    shopName = shopNameC.text.toString();
    shopkeeperName = shopkeeperNameC.text.toString();
    address = addressC.text.toString();
    vaccine = vaccineC.text.toString();

    // email = shopUser.email;
    // date = shopUser.metadata.lastSignInTime;

    // print(date);
    if (imageChanged) {
      print("Changing even when not pressed");
      CollectionReference users = firestore.collection('Shopkeeper');
      users.doc(uid).update({
        'shopName': shopName,
        'shopkeeperName': shopkeeperName,
        'address': address,
        'imageUrl': i,
        'vaccine': vaccine,
      }).then((value) => print("added"));
    } else {
      CollectionReference users = firestore.collection('Shopkeeper');
      users.doc(uid).update({
        'shopName': shopName,
        'shopkeeperName': shopkeeperName,
        'address': address,
        'imageUrl': u,
        // 'vaccine': vaccine,
      }).then((value) => print("added"));
    }

    Navigator.pushReplacementNamed(context, '/shopkeeperHomePage');
  }

  void imageUpload() async {
    print("uploading even when not uploaded");
    final _pickr = ImagePicker();
    PickedFile image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        _storage = FirebaseStorage.instance;
        var snapshot = _storage.ref().child('images/').putFile(file).snapshot;
        var url = await snapshot.ref.getDownloadURL();
        Reference reference =
            FirebaseStorage.instance.ref().child('Shopkeeper/').child(uid);
        UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
          var url = await uploadTask.snapshot.ref.getDownloadURL();

          print(url);
          print("image added");
        });
        imageChanged = true;
        i = url;

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
    userId = FirebaseAuth.instance.currentUser;
    uid = userId.uid;

    firestore
        .collection("Shopkeeper")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          defaultData = true;
          email = userId.email;
          datas = documentSnapshot.data();
          list = datas.values.toList();
          print(list);
          // imageUrl = list[2];
          imageUrl = datas['imageUrl'];
          u = imageUrl;
          sN = datas['shopName'];
          a = datas['address'];
          skName = datas['shopkeeperName'];
          v = datas['vaccine'];
          print(imageUrl);

          // print("Details  $imageUrl   $name    $address     $vaccine");
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return (defaultData != false)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Shopkeeper Update"),
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
                          hintText: "Doctor Name",
                        ),
                        controller: shopNameC..text = sN,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Hospital Name",
                        ),
                        controller: shopkeeperNameC..text = skName,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Specialisation",
                        ),
                        controller: addressC..text = a,
                      ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     hintText: "Vaccine Status",
                      //   ),
                      //   controller: vaccineC..text = v,
                      // ),
                      ElevatedButton(
                        onPressed: imageUpload,
                        child: Text("Upload photo"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: update,
                            child: Text("Update"),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                            onPressed: cancel,
                            child: Text("Cancel Update"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Shopkeeper Update"),
              centerTitle: true,
            ),
            body: SpinKitRotatingCircle(color: Colors.blue),
          );
  }
}
