import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  String phoneNumber;
  RegistrationScreen({this.phoneNumber});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _fname = new TextEditingController();
  TextEditingController _middleName = new TextEditingController();
  TextEditingController _lName = new TextEditingController();
  TextEditingController _policyNo = new TextEditingController();
  TextEditingController _nIC = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _conatctNo = new TextEditingController();
  TextEditingController _dateOfBirth = new TextEditingController();
  TextEditingController _insuranceIDate = new TextEditingController();
  TextEditingController _issuedPlace = new TextEditingController();

  String valueChoose;
  List listItems = ["3rd Party", "Premium", "Custom"];
  var selected_date;
  final format = DateFormat("yyyy-MM-dd");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  SharedPreferences prefs;
  final _codeController = TextEditingController();

  initSherePrefernce() async {
    prefs = await SharedPreferences.getInstance();
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
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Registration Form",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Register Now",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
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
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _fname,
                                    decoration: InputDecoration(
                                      hintText: "First Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "First Name is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _middleName,
                                    decoration: InputDecoration(
                                      hintText: "Middle Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _lName,
                                    decoration: InputDecoration(
                                      hintText: "Last Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Last Name is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _policyNo,
                                    decoration: InputDecoration(
                                      hintText: "Policy No",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Policy Number is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _nIC,
                                    decoration: InputDecoration(
                                      hintText: "NIC",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "national idennty card Number is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _address,
                                    decoration: InputDecoration(
                                      hintText: "Address",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Address is not entered";
                                      }
                                      return null;
                                    },
                                    maxLines: 3,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _conatctNo,
                                    decoration: InputDecoration(
                                      hintText: "Contact No",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Contact is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: DateTimeField(
                                    controller: _dateOfBirth,
                                    onChanged: (value) {
                                      selected_date = value;
                                    },
                                    format: format,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: 'Date of Birth',
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                    },
                                  ),
                                  // child: TextFormField(
                                  //   controller: _dateOfBirth,
                                  //   decoration: InputDecoration(
                                  //     icon: Icon( Icons.date_range),
                                  //     hintText: "Date of Birth",
                                  //     hintStyle: TextStyle(color: Colors.grey),
                                  //     border: InputBorder.none,
                                  //   ),
                                  //   validator: (String value){
                                  //     if (value.isEmpty){
                                  //       return"Date of Birth is not entered";
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: DateTimeField(
                                    controller: _insuranceIDate,
                                    onChanged: (value) {
                                      selected_date = value;
                                    },
                                    format: format,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: 'Insurance Issued Date',
                                    ),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1900),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                    },
                                  ),
                                  // child: TextFormField(
                                  //   controller: _insuranceIDate,
                                  //   decoration: InputDecoration(
                                  //     icon: Icon( Icons.date_range),
                                  //     hintText: "Insurance Issued Date",
                                  //     hintStyle: TextStyle(color: Colors.grey),
                                  //     border: InputBorder.none,
                                  //   ),
                                  //   validator: (String value){
                                  //     if (value.isEmpty){
                                  //       return"Insurance Issued Date is not entered";
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: TextFormField(
                                    controller: _issuedPlace,
                                    decoration: InputDecoration(
                                      hintText: "Issued Place",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Insurance Issued Date is not entered";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200])),
                                  ),
                                  child: DropdownButton(
                                    hint: Text("Select the Type Of Insurance"),
                                    dropdownColor: Colors.white,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36,
                                    isExpanded: true,
                                    underline: SizedBox(
                                      height: 2,
                                    ),
                                    value: valueChoose,
                                    onChanged: (newValue) {
                                      setState(() {
                                        valueChoose = newValue;
                                      });
                                    },
                                    items: listItems.map((valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            color: Colors.indigo,
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                _formkey.currentState.save();
                                prefs.setString(
                                    "userId", prefs.getString('userId'));
                                prefs.setBool('isLogin', true);
                                final usersref =
                                    Firestore.instance.collection('userId');
                                DocumentSnapshot docCurrent;

//
//
//                                FirebaseUser user =
//                                    await FirebaseAuth.instance.currentUser();

                                docCurrent = await usersref
                                    .document(widget.phoneNumber)
                                    .get();

                                await usersref
                                    .document(widget.phoneNumber)
                                    .setData({
                                  "uid": widget.phoneNumber,
                                });
//                                if (!docCurrent.exists) {
//
//
//                                }

                                var documentReference = Firestore.instance
                                    .collection('users')
                                    .document(widget.phoneNumber);

                                Firestore.instance
                                    .runTransaction((transaction) async {
                                  await transaction.set(
                                    documentReference,
                                    {
                                      "userID": widget.phoneNumber,
                                      "fName": _fname.text,
                                      "middleName": _middleName.text,
                                      "lName": _lName.text,
                                      "policyNumber": _policyNo.text,
                                      "nIC": _nIC.text,
                                      "address": _address.text,
                                      "contactNo": _conatctNo.text,
                                      "dateOfBirth": _dateOfBirth.text,
                                      "insuranceIssuedDate":
                                          _insuranceIDate.text,
                                      "issuedPlace": _issuedPlace.text,
                                      "typeOfInsurance": valueChoose,
                                    },
                                  );
                                });
                                //  Map<String,dynamic> data ={
                                //    "userID":widget.phoneNumber,
                                //    "fName":_fname.text,
                                //    "middleName":_middleName.text,
                                //    "lName":_lName.text,
                                //    "policyNumber":_policyNo.text,
                                //    "nIC":_nIC.text,
                                //    "address":_address.text,
                                //    "contactNo":_conatctNo.text,
                                //    "dateOfBirth":_dateOfBirth.text,
                                //    "insuranceIssuedDate":_insuranceIDate.text,
                                //    "issuedPlace":_issuedPlace.text,
                                //  "typeOfInsurance":valueChoose,};
                                // Firestore.instance.collection("registration").add(data);
                                Navigator.of(context).pushNamed('/mainpage');
                                print("scsess");
                              } else {
                                print("Unsecseesfull");
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            textColor: Colors.white,
                            child: Text(
                              "Register",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
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
