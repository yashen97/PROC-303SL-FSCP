import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/maininterface_screen.dart';

class Vehicle extends StatefulWidget {
  String userId;
  Vehicle({this.userId});
  @override
  _VehicleState createState() => _VehicleState(userId: userId);
}

class _VehicleState extends State<Vehicle> {
  String userId;
  _VehicleState({this.userId});

  @override
  void initState() {
    print(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("Vehicles"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            newqq(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        Navigator.of(context)
                            .pushReplacementNamed('/addvehicle');
                      },
                      child: Text(
                        "Add a Vehicle",
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
          ],
        ),
      ),
    );
  }

  Widget newqq() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('addVehicle')
            .where('user_id', isEqualTo: userId)
            .snapshots(),
        // stream: Firestore.instance.collection('Videos').snapshots(),
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
                  child: Row(
                    children: <Widget>[
                      Text(userId),
                      Expanded(
                        child: Container(
                          child: Image.network(document['imageUrl'],
                              width: 100, height: 100),
                        ),
                      ),
                      Expanded(
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
                                        text: 'Policy NUmber :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['policyNo'].toString() ??
                                            "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'License Plate :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['licensePlate'] ?? "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Chasis Engine Number :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['chasisEnginNo'] ?? "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Year :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['Year'] ?? "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Brand :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['Brand'] ?? "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Model :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['model'] ?? "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Vegicle Registered Date :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        text: document['vehicleRegisterDate'] ??
                                            "",
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
}
