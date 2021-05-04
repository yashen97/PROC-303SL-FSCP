import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/mainfour/makeaclaims.dart';
import 'package:insmanager/screens/maininterface_screen.dart';

class Claims extends StatefulWidget {
  String vehicle;
  String userId;
  Claims({this.vehicle, this.userId});

  @override
  _ClaimsState createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("Claims"),
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ClaimBody(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: deprecated_member_use
                  GestureDetector(
                    onTap: () {},
                    child: RaisedButton(
                      color: Colors.indigo,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MakeClaim(
                                      userId: widget.userId,
                                    )));
                      },
                      child: Text(
                        "Make a Claim",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ClaimBody() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('claims')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data.documents.map((document) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Claim Reference No :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['claimId'].toString() ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Claim Date :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['currentDate'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Lisence Plate :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['licensePlate'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
}
