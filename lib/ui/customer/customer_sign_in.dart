import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerSignIn extends StatefulWidget {
  @override
  _CustomerSignInState createState() => _CustomerSignInState();
}

class _CustomerSignInState extends State<CustomerSignIn> {
  TextEditingController emailC = TextEditingController();
  TextEditingController pswdC = TextEditingController();

  String email = " ";
  String pswd = " ";
  String errorEmail = " ";
  String errorPass = " ";
  String displayMsg = " ";

  void login() async {
    email = emailC.text.toString();
    pswd = pswdC.text.toString();
    if (email == " ") {
      setState(() {
        errorEmail = "Please provide an email";
      });
    } else {
      setState(() {
        errorEmail = " ";
      });
    }
    if (pswd == " ") {
      setState(() {
        errorPass = "Please provide an password";
      });
    } else {
      setState(() {
        errorPass = " ";
      });
    }

    if (errorEmail == " " && errorPass == " ") {
      User user = await userSignIn(email, pswd).catchError((e) {
        setState(() {
          displayMsg = e;
        });
      });
      setState(() {
        if (user != null) {
          Navigator.pushReplacementNamed(
            context,
            '/customerHomePage',
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient login"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: errorEmail == " " ? null : '$errorEmail',
                  hintText: "something@email.com",
                ),
                controller: emailC,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "password",
                  errorText: errorPass == " " ? null : '$errorPass',
                ),
                controller: pswdC,
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: login,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(displayMsg),
            ],
          ),
        ),
      ),
    );
  }
}
