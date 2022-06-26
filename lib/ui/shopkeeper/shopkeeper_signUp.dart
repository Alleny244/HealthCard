import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';

class ShopRegister extends StatefulWidget {
  @override
  _ShopRegisterState createState() => _ShopRegisterState();
}

class _ShopRegisterState extends State<ShopRegister> {
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
  void register() async {
    email = emailC.text.toString();
    pswd = pswdC.text.toString();
    cpswd = cpswdC.text.toString();
    reg = regC.text.toString();
    if (pswd.isEmpty || cpswd.isEmpty)
      setState(() {
        errorcpswd = "Password cannot be empty";
      });
    else if (pswd != cpswd) {
      setState(() {
        errorcpswd = "Password not Matching";
      });
    } else {
      setState(() {
        errorcpswd = "";
      });
    }
    if (email == "") {
      setState(() {
        errorEmail = "Please provide an email";
      });
    } else {
      setState(() {
        errorEmail = "";
      });
    }

    if (reg == "") {
      setState(() {
        errorReg = "Please provide Registration Number";
      });
    } else {
      setState(() {
        errorReg = "";
      });
    }

    if (errorEmail == "" && errorcpswd == "" && errorReg == "") {
      displayMsg = await userRegistration(email, pswd);
      setState(() {
        if (displayMsg == "") {
          displayMsg = "Registration Successfull";
        }
      });
      Navigator.pushNamed(context, '/selectUserType');
    }
  }

  Future<String> getDisplayMessage() async =>
      await userRegistration(email, pswd);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor registration"),
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
                    labelText: "Email",
                    errorText: errorEmail == "" ? null : '$errorEmail',
                    hintText: "something@email.com",
                  ),
                  controller: emailC,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "NMC Registration Number",
                    // errorText: errorReg == " " ? null : '$errorReg',
                    hintText: "xxxxx",
                  ),
                  controller: regC,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  controller: pswdC,
                ),
                TextField(
                  decoration: InputDecoration(
                    errorText: errorcpswd == "" ? null : '$errorcpswd',
                    labelText: "Confirm password",
                  ),
                  controller: cpswdC,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: register,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Register",
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
