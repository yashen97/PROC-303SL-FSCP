import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/login_screens/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../maininterface_screen.dart';

SharedPreferences prefs;
final _codeController = TextEditingController();

Future<bool> loginUser(
    String phone, BuildContext context, String fullnumber, String type) async {
//  getSharedPreference();

  prefs = prefs = await SharedPreferences.getInstance();

  FirebaseAuth _auth = FirebaseAuth.instance;

  print(fullnumber);
  _auth.verifyPhoneNumber(
      phoneNumber: fullnumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        //  Navigator.of(context).pop();

        AuthResult result = await _auth.signInWithCredential(credential);

        FirebaseUser user = result.user;

        if (user != null) {
          final usersref = Firestore.instance.collection('userId');
          DocumentSnapshot docCurrent;

          FirebaseUser user = await FirebaseAuth.instance.currentUser();

          docCurrent = await usersref.document(phone).get();
          print(user.uid);
          print(docCurrent);

          if (!docCurrent.exists) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistrationScreen(
                          phoneNumber: phone,
                        )));
          } else {
            prefs.setString("userId", phone);
            prefs.setBool('isLogin', true);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainInterface()));
            // Navigator.of(context).pushNamed('/mainpage');
          }
        } else {
          print("Error");
        }

        //This callback would gets called when verification is done auto maticlly
      },
      verificationFailed: (AuthException exception) {
        print(exception);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Please wait few seconds...?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verificationId, smsCode: code);

                      AuthResult result =
                          await _auth.signInWithCredential(credential);

                      FirebaseUser user = result.user;

                      if (user != null) {
                        final usersref =
                            Firestore.instance.collection('userId');
                        DocumentSnapshot docCurrent;

                        FirebaseUser user =
                            await FirebaseAuth.instance.currentUser();

                        docCurrent = await usersref.document(phone).get();
                        print(user.uid);
                        print(docCurrent);

                        if (!docCurrent.exists) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen(
                                        phoneNumber: phone,
                                      )));
                        } else {
                          prefs.setString("userId", phone);
                          prefs.setBool('isLogin', true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainInterface()));
                          // Navigator.of(context).pushNamed('/mainpage');
                        }
                      } else {
                        print("Error");
                      }
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: null);
}
