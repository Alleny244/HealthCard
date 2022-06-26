import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
// page for sign up for both customer and shopkeeper
import 'package:pii/flutterfire/auth.dart';

class ShopkeeperLaunchPage extends StatefulWidget {
  @override
  _ShopkeeperLaunchPageState createState() => _ShopkeeperLaunchPageState();
}

class _ShopkeeperLaunchPageState extends State<ShopkeeperLaunchPage> {
  void customerReg() {
    Navigator.pushNamed(context, '/shopkeeperRegister');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: customerReg,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.6,
              height: 60,
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () =>
                {Navigator.pushNamed(context, '/shopkeeperSignIn')},
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.6,
              height: 60,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SignInButton(
            Buttons.Google,
            text: "Sign in with Google",
            onPressed: () async {
              await googleSignIn();
              Navigator.pushNamed(context, '/shopkeeperGoogleHomePage');
            },
          )
        ],
      ),
    );
  }
}
