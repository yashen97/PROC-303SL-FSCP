import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgetPWScreen extends StatefulWidget {
  @override
  _ForgetPWScreenState createState() => _ForgetPWScreenState();
}

class _ForgetPWScreenState extends State<ForgetPWScreen> {
  String _mobile;


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
                  Text("Forget Password", style: TextStyle(color: Colors.white, fontSize: 40.0),),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Change your Password", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                ],
              ),
            ),
            SizedBox(
              height: 50,
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
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                      BorderSide(color: Colors.grey[200])),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon( Icons.phone_android_outlined),
                                    hintText: "Mobile Number",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  validator: (String value){
                                    if (value.isEmpty){
                                      return"Mobile Number is not entered";
                                    }
                                    if(value.length != 10){
                                      return "Please enter the valid Mobile Number";
                                    }
                                    return null;
                                  },
                                  onChanged: (value){
                                    //this.phoneNo = value;
                                  },
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
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
                             print('Success');
                            }else{
                              print("Unsecseesfull");
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          textColor: Colors.white,child: Text("Verify",style: TextStyle(fontSize: 18),),
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

