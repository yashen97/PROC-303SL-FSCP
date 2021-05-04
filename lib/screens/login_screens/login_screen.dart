import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../maininterface_screen.dart';
import 'phoneverification.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _pw;
  String _mobile;

  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List pointList = <Offset>[];
  SharedPreferences prefs;
  final _codeController = TextEditingController();

  initSherePrefernce() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isLogin')) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainInterface()));
    }
  }

  @override
  void initState() {
    initSherePrefernce();
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
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60.0),
                      topRight: Radius.circular(60.0),
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(95, 27, 225, .3),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200])),
                                ),
                                child: TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.drive_file_rename_outline),
                                    hintText: "Mobile",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _mobile = value;
                                    });
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Mobile Number is not entered";
                                    }
                                    return null;
                                  },
                                  onSaved: (String mobile) {
                                    _mobile = mobile;
                                  },
                                ),
                              ),
//                              Container(
//                                padding: EdgeInsets.all(10),
//                                decoration: BoxDecoration(
//                                  border: Border(
//                                      bottom:
//                                          BorderSide(color: Colors.grey[200])),
//                                ),
//                                child: TextFormField(
//                                  decoration: InputDecoration(
//                                    icon: Icon(Icons.lock_outline),
//                                    hintText: "Password",
//                                    hintStyle: TextStyle(color: Colors.grey),
//                                    border: InputBorder.none,
//                                  ),
//                                  onChanged: (value) {
//                                    setState(() {
//                                      _pw = value;
//                                    });
//                                  },
//                                  onSaved: (String pw) {
//                                    _pw = pw;
//                                  },
//                                  validator: (String value) {
//                                    if (value.isEmpty) {
//                                      return "Password is not entered";
//                                    }
//                                    return null;
//                                  },
//                                  obscureText: true,
//                                ),
//                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/forgetpwpage');
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 50),
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 100),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.indigo,
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              print("success");

                              _formkey.currentState.save();

                              loginUser(phoneController.text, context,
                                  "+94" + phoneController.text, "");

//                              final usersref =
//                                  Firestore.instance.collection('admin');
//                              var docCurrent;
//
//                              FirebaseUser user =
//                                  await FirebaseAuth.instance.currentUser();
//
//                              docCurrent = await usersref
//                                  .where(
//                                    'username',
//                                    isEqualTo: phoneController.text,
//                                  )
//                                  .getDocuments();
//                              print(user.uid);
//                              print(docCurrent);
//
//                              if (docCurrent.exists) {
//                                Navigator.pushReplacement(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) => MainInterface()));
//                              } else {
//                                Fluttertoast.showToast(
//                                    msg: "Invalid Username or Password",
//                                    toastLength: Toast.LENGTH_SHORT,
//                                    gravity: ToastGravity.CENTER,
//                                    timeInSecForIosWeb: 1,
//                                    backgroundColor: Colors.red,
//                                    textColor: Colors.white,
//                                    fontSize: 16.0);
//                              }

//                                    var mobile_number =
//                                    phoneController.text.length ==
//                                        10
//                                        ? phoneController.text
//                                        .substring(1, 10)
//                                        .toString()
//                                        : phoneController.text
//                                        .toString();
//
//                                    await Firestore.instance.collection("registration").document(mobile_number).get().then((value){
//                                      setState(() {
//                                        // first add the data to the Offset object
//                                        List.from(value.data['userID']).forEach((element){
//                                          pointList.add(element);
//
//                                          print(pointList.length);
//                                        });
//
//                                      });
//                                    });
                            } else {
                              print("Unsecseesfull");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          textColor: Colors.white,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18),
                          ),
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
}
