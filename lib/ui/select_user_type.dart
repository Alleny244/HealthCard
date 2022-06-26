import 'package:flutter/material.dart';
import './customer/customer_launch_page.dart';
import './shopkeeper/shopkeeper_launch_page.dart';

// page for user sign in and sign up

class SelectUserType extends StatefulWidget {
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

// object of tab controller
TabController object;

class _SelectUserTypeState extends State<SelectUserType>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // initializing  tab controller object
    object = TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        backgroundColor: Colors.amber[700],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: object,
          children: [
            CustomerLaunchPage(), //present in /pages/login.dart
            ShopkeeperLaunchPage(), //present in /pages/signup.dart
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue[500],
        child: TabBar(
          indicatorColor: Colors.blue[900],

          overlayColor: MaterialStateProperty.all<Color>(
            Colors.blueAccent,
          ), //onhovering color

          labelColor: Colors.white, // icon color

          controller: object,

          tabs: [
            Tab(
              child: Text(
                "Patient",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Doctor",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
