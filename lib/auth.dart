import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String> customerRegistration(String email, String password) async {
  String displayMsg = " ";
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print(email);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      displayMsg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      displayMsg = 'The account already exists for that email.';
    }
  } catch (e) {
    print(e);
  }
  return displayMsg;
}

Future<String> customerSignIn(String email, String password) async {
  String displayMsg = " ";
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = _auth.currentUser;
    print(user.email);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      displayMsg = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      displayMsg = 'Wrong password provided for that user.';
    }
  }
}
