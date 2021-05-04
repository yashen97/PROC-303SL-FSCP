import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/login_screens/phoneverification.dart';
import 'package:insmanager/screens/login_screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insmanager/services/usermanagement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

 SharedPreferences prefs;

  TextEditingController phoneController = new TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
 List pointList = <Offset>[];
  initSheardPreference() async{
    prefs= await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    // TODO: implement initState
    initSheardPreference();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.indigo[900],
              Colors.indigo[800],
              Colors.indigo[400],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("SignUp", style: TextStyle(color: Colors.white, fontSize: 40.0),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Create a Account", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              height: 30,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.0),
                        topRight: Radius.circular(60.0),
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),)),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 200,left: 50,right: 30),
                        child: Form(

                          key: _formkey,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Colors.grey[200])),
                              ),
                              child: TextFormField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                  hintText: "Mobile Number",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a valid phone number';
                                  }
                                  if (phoneController.text.length == 9 ||
                                      phoneController.text.length == 10) {
                                  } else {
                                    return 'Please enter a valid phone number';
                                  }
                                }
                              ),
                            )),
                      ),

                      SizedBox(
                        height: 60,
                        width: 200,
                      ),

                      SizedBox(
                        width: 200,
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.indigo,
                          onPressed: ()async{
                            if (_formkey.currentState.validate()){
                              _formkey.currentState.save();

                              var mobile_number =
                              phoneController.text.length ==
                                  10
                                  ? phoneController.text
                                  .substring(1, 10)
                                  .toString()
                                  : phoneController.text
                                  .toString();

                              await Firestore.instance.collection("registration").document(mobile_number).get().then((value){
                                setState(() {
                                  // first add the data to the Offset object
                                  // List.from(value.data['userID']).forEach((element){
                                  //   pointList.add(element);
                                  //
                                  //   print(pointList.length);
                                  // });
                                  print(mobile_number);
                                  loginUser(mobile_number,context,"+94"+mobile_number,"");
                                });
                              });

                              // prefs.setString("userId",mobile_number);
                              // Navigator.pushReplacement(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => RegistrationScreen(
                              //               phoneNumber:mobile_number,
                              //             )));


                              // loginUser(
                              //     String phone, BuildContext context, String fullnumber, String type)
                              // Map<String,dynamic> data ={
                              //   "MobileNumber":mobile_number,
                              //
                              //   };
                              // Firestore.instance.collection("registration").add(data);
                              // Navigator.of(context).pushNamed('/mainpage');
                              print("scsess");
                            }else{
                              print("Unsecseesfull");
                            }

                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          textColor: Colors.white,child: Text("Sign In",style: TextStyle(fontSize: 18),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


 // Future<void> _sendCodeToPhoneNumber() async {
 //
 //   String phoneNumber = '+27'+_phoneNumberController.text.substring(1);
 //
 //   final PhoneVerificationFailed verificationFailed = (AuthException authException) {
 //     setState(() {
 //       print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');}
 //     );
 //   };
 //
 //   final PhoneCodeSent codeSent =
 //       (String verificationId, [int forceResendingToken]) async {
 //     this.verificationId = verificationId;
 //     print("code sent to " + phoneNumber);
 //   };
 //
 //   final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
 //       (String verificationId) {
 //     this.verificationId = verificationId;
 //     print("time out");
 //   };
 //
 //   await FirebaseAuth.instance.verifyPhoneNumber(
 //       phoneNumber: phoneNumber,
 //       timeout: const Duration(minutes: 1),
 //       verificationCompleted: null,
 //       verificationFailed: verificationFailed,
 //       codeSent: codeSent,
 //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
 // }
}

