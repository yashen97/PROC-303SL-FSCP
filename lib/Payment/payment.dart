/*
This is payment page
 */
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:intl/intl.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  String amount;
  PaymentPage({this.amount});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  SharedPreferences prefs;

  initSharePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  void initState() {
    initSharePreference();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startOneTimePayment(BuildContext context, String ref_id) async {
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1213092", // Replace your Merchant ID
      "merchant_secret": "4ToiGbImI4a4uPXwXw4Up14Et6yNg4tmN8LKlUhgTQYr",
      "notify_url": "",
      "order_id": ref_id.toString(),
      "items": "Lesson Paymenrts",
      "amount": widget.amount,
      "currency": "LKR",
      "first_name": "",
      "last_name": "",
      "email": "yashenraveesha97@gmail.com",
      "phone": "",
      "address": "",
      "city": "",
      "country": "Sri Lanka",
      "delivery_address": "",
      "delivery_city": "",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    void showAlert(BuildContext context, String title, String msg) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    PayHere.startPayment(paymentObject, (paymentId) {
      SavePayments();
    }, (error) {
      print("One Time Payment Failed. Error: $error");
      showAlert(context, "Payment Failed", "$error");
    }, () {
      print("One Time Payment Dismissed");
      showAlert(context, "Payment Dismissed", "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(
        //     color: Colors.black, //change your color here
        //   ),
        //   elevation: 0,
        //   title: Text(
        //     'Payment',
        //     style: TextStyle(color: Colors.blueAccent),
        //   ),
        //   backgroundColor: Colors.white,
        //   bottom: PreferredSize(
        //       child: Container(
        //         color: Colors.grey[100],
        //         height: 1.0,
        //       ),
        //       preferredSize: Size.fromHeight(1.0)),
        // ),
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text("Payment"),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainInterface()),
                );
              },
            ),
          ),
          backgroundColor: Colors.indigo[700],
          elevation: 22,
          shadowColor: Colors.indigoAccent,
          brightness: Brightness.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: SizedBox(),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'total_payment',
                          ),
                        ),
                        Container(
                          child: Text('\RS ' + widget.amount,
                              style: TextStyle(color: Colors.black)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      Text(
//                          AppLocalizations.of(context)
//                              .translate('payment_method'),
//                          style: TextStyle(
//                              fontSize: 16, fontWeight: FontWeight.bold)),
//                      GestureDetector(
//                        onTap: () {
//                          showModalBottomSheet<void>(
//                            context: context,
//                            builder: (BuildContext context) {
//                              return _createChoosePayment();
//                            },
//                          );
//                        },
//                        child: Text(
//                            AppLocalizations.of(context).translate('change'),
//                            style:
//                                TextStyle(color: PRIMARY_COLOR, fontSize: 14)),
//                      ),
//                    ],
//                  ),
//                  Container(
//                    margin: EdgeInsets.only(top: 16),
//                    child: Row(
//                      children: [
//                        Container(
//                          margin: EdgeInsets.only(right: 8),
//                          padding: EdgeInsets.all(4),
//                          decoration: BoxDecoration(
//                            border: Border.all(
//                              color: Color(0xffcccccc),
//                              width: 1.0,
//                            ),
//                          ),
//                          child:
//                              Image.asset('assets/images/visa.png', height: 10),
//                        ),
//                        Text(
//                            AppLocalizations.of(context)
//                                .translate('visa_card_ending_in1'),
//                            style: TextStyle(
//                                fontSize: 14,
//                                fontWeight: FontWeight.bold,
//                                color: CHARCOAL))
//                      ],
//                    ),
//                  ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(32),
                child: SizedBox(
                    width: double.maxFinite,
                    child: RaisedButton(
                      elevation: 2,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3.0),
                          side: BorderSide(color: Colors.blueAccent)),
                      onPressed: () {
//                      showLoading(AppLocalizations.of(context)
//                          .translate('payment_success'));

                        startOneTimePayment(context, "23232323232423");
                      },
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      color: Colors.indigo,
                      child: Text(
                        "Online Payment",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }

  void showLoading(String textMessage) {
    _progressDialog(context);
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
      _buildShowDialog(context, textMessage);
    });
  }

  Future _progressDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return null;
            },
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Future _buildShowDialog(BuildContext context, String textMessage) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return null;
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      textMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.blue)),
                        onPressed: () {
//                          StaticVariable.useWhiteStatusBarForeground = true;
//                          Navigator.of(context).pushAndRemoveUntil(
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      BottomNavigationBarPage()),
//                              (Route<dynamic> route) => false);
                        },
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text(
                          'ok',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  SavePayments() async {
    var documentReference =
    Firestore.instance.collection('Payments').document();

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          "userId": prefs.getString("userId"),
          "amount": widget.amount,
          "paymentDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        },
      );
    });

    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainInterface()));
  }
}
