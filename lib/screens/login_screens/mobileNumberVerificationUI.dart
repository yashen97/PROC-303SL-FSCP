import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/login_screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insmanager/services/usermanagement.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  String _email;
  String _name;
  String _pw ;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                      bottomRight: Radius.circular(60.0),)),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
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
                                  decoration: InputDecoration(
                                    icon: Icon( Icons.drive_file_rename_outline),
                                    hintText: "User Name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),

                                  validator: (String value){
                                    if (value.isEmpty){
                                      return"Name is not entered";
                                    }
                                    return null;
                                  },
                                  onSaved: (String name){
                                    _name = name;
                                  },
                                  onChanged: (value){
                                    setState(() {
                                      _name = value;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[200])),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon( Icons.email_outlined),
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      _email=value;
                                    });
                                  },
                                  validator: (String value){
                                    if (value.isEmpty){
                                      return"Email is not entered";
                                    }
                                    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                      return "Please enter the valid email";
                                    }
                                    return null;
                                  },
                                  // onSaved: (String email){
                                  //   _email = email;
                                  // },
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[200])),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon( Icons.lock_outline),
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      _pw=value;
                                    });
                                  },
                                  validator: (String value){
                                    if (value.isEmpty){
                                      return"Password is not entered";
                                    }
                                    return null;
                                  },
                                  // onSaved: (String pw){
                                  //   _pw = pw;
                                  // },
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.indigo,
                          onPressed: (){
                            if (_formkey.currentState.validate()){
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: _email, password: _pw)
                                  .then((signedInUser){
                                UserManagement().storeNewUser(signedInUser, context);
                              })
                                  .catchError((e){
                                print(e);
                              });
                              Navigator.of(context).pushNamed('/registrationpage');
                            }else{
                              print("Unsecsessfull");
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
}
