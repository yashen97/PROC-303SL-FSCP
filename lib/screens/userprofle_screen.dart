import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("My Profile"),
        ),
        leading:Padding(
          padding: const EdgeInsets.only(top: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
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
          borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),bottomLeft:Radius.circular(10)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: SizedBox(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:30),
        child: Container(
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.indigoAccent,
                        ),
                        //boxShadow: BoxShadow(),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/user.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Colors.indigoAccent,
                          ),
                        color: Colors.white
                      ),
                      child: Icon(Icons.edit,color: Colors.indigoAccent,),
                    ),)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text("Insurance Policy number",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
              ),SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5),
                // child: UserNameTexts(),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: ContactTexts(),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: insuranceDetails(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


Widget insuranceDetails() {
  return StreamBuilder(
      stream: Firestore.instance.collection('addVehicle').snapshots(),
      // stream: Firestore.instance.collection('Videos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.documents.map((document) {
            return Expanded(
              child: Column(
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
                            text: document['policyNo'].toString() ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Vehicle Name :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: document['vehiclename'] ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Vehicle Registered Date :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: document['vehicleRegisterDate'] ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      });
}
Widget userDetails() {
  return StreamBuilder(
      stream: Firestore.instance.collection('registration').snapshots(),
      // stream: Firestore.instance.collection('Videos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.documents.map((document) {
            return Expanded(
              child: Column(
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
                            text: document['policyNo'].toString() ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Vehicle Name :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: document['vehiclename'] ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Vehicle Registered Date :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                            text: document['vehicleRegisterDate'] ?? "",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      });
}