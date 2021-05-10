import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/Payment/payment.dart';
import 'package:insmanager/screens/login_screens/login_screen.dart';
import 'package:insmanager/screens/mainfour/myclaims.dart';
import 'package:insmanager/screens/mainfour/vehicles_screen.dart';
import 'package:insmanager/screens/userprofle_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insmanager/loading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'chat/liveChat.dart';

class MainInterface extends StatefulWidget {
  String userId;
  MainInterface({this.userId});
  @override
  _MainInterfaceState createState() => _MainInterfaceState(userId: userId);
}

class _MainInterfaceState extends State<MainInterface> {

  String userId;
  _MainInterfaceState({this.userId});

  SharedPreferences prefs;

  bool loading = true;

  initSheardPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = false;
    });

    print(prefs.getString("userId") + "*******************************");
  }

  @override
  void initState() {
    initSheardPreference();
    print(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading?Loading(): Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("Home"),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                        // phoneNumber: phone,
                        userId: prefs.getString("userId"),
                      )));
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.0, top: 12),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // image: Image.file(),
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
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
      drawer: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                color: Colors.indigo,
                child: Center(
                  child: Column(
                    children: [
                      img(),
                      SizedBox(
                        height: 15,
                      ),
                      Name(),
                      policyNumber(),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(
                            // phoneNumber: phone,
                            userId: prefs.getString("userId"),
                          )));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }).catchError((e) {
                    print(e);
                  });
                },
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 125),
        child: ClaimBody(),
      ),
    );
  }

  Material ClaimBody() {
    return Material(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(
                                  peerId: "admin",
                                  peerAvatar: "",
                                  name: "kasun",
                                )));
                  },
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "Live Chat Agent",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.airport_shuttle_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Vehicle(
                                  userId: prefs.getString("userId"),
                                )));
                  },
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "My Vehicles",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.title,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Claims(
                                  userId: prefs.getString("userId"),
                                )));
                  },
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "My Claims",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentPage(
                            amount: 5000.toString(),
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.payment_outlined,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Payments",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget Name() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: prefs.getString("userId"))
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
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'User Name - ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              TextSpan(
                                  text: document['fName'].toString() ??
                                      "",
                                  style: TextStyle(color: Colors.black,fontSize: 18)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
  Widget policyNumber() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: prefs.getString("userId"))
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
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Insurance Policy No - ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              TextSpan(
                                  text: document['policyNumber'].toString() ??
                                      "",
                                  style: TextStyle(color: Colors.black,fontSize: 18)),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }

  Widget img() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('userImage')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        // stream: Firestore.instance.collection('Videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                var document = snapshot.data.documents[index].data;
                return Column(
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 50.0,
                          child: ClipRect(
                            child: Image.network(document['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
        });
  }
  Widget img1() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('userImage')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        // stream: Firestore.instance.collection('Videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index){
                var document = snapshot.data.documents[index].data;
                return Column(
                  children: <Widget>[
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius:10.0,
                          child: ClipRect(
                            child: Image.network(document['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
        });
  }

}
