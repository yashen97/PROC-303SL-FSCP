
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  String userId;
  UserProfile({this.userId});
  @override
  _UserProfileState createState() => _UserProfileState(userId: userId);
}

class _UserProfileState extends State<UserProfile> {
  SharedPreferences prefs;

  initSheardPreference() async {
    prefs = await SharedPreferences.getInstance();
  }
  var value, selectedType;

  File _image;
  final picker = ImagePicker();

  Future getImageFromGallery(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('userImage/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) {
        var documentReference = Firestore.instance
            .collection('userImage')
            .document(userId);


        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              "imageUrl": value,
              "user_id": prefs.getString("userId"),
            },
          );
        });
      },
    );
  }


  TextEditingController _userID = new TextEditingController();
  TextEditingController _address = new TextEditingController();


  _buildTextField(TextEditingController controller, String lableText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.indigo,
        border: Border.all(color: Colors.blueAccent),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: lableText,
          labelStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }
  String userId;
  _UserProfileState({this.userId});



  @override
  void initState() {
    initSheardPreference();
    print(widget.userId);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text("My Profile"),
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
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: SizedBox(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: imageProfile(context),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(

                  child: policyNumber(),
                ), SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: UserNameTexts(),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContactTexts(),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: insuranceDetails(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget imageProfile(BuildContext context){
    return Center(
      child: Stack(
        children: [
          Column(
            children: [
              img(),
            ],
          ),
          // CircleAvatar(
          //
          //   radius: 80.0,
          //   // backgroundImage: _image==null? AssetImage('images/user.png'):Image.network("imageUrl"),
          //   backgroundImage: _image==null? AssetImage('images/user.png'):FileImage(File(_image.path)),
          // ),
          Positioned(
            bottom: 5.0,
            right: 150.0,


            child: InkWell(
              onTap: (){
                showModalBottomSheet(
                  context: context,
                  builder: ((builder)=>bottomSheet(context)),
                );
              },
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget bottomSheet(BuildContext context){
    return Container(
      height: 138,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text("Choose Profile Photo",style: TextStyle(
            fontSize: 20,
          ),),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(onPressed: (){
                getImageFromGallery(ImageSource.camera);
              },
                  icon: Icon(Icons.camera_alt),
                label: Text("Camera"),
              ),
              FlatButton.icon(onPressed: (){
                getImageFromGallery(ImageSource.gallery);
              },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: RaisedButton(
                  color: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    uploadImageToFirebase(context);
                    Navigator.of(context)
                        .pop(context);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 2.2,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget policyNumber() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: widget.userId)
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
  Widget UserNameTexts() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: widget.userId)
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
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            color: Colors.indigo,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      child: Text(
                                        "User Details", style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //         icon: Icon(Icons.edit),
                                  //         color: Colors.white,
                                  //         onPressed: () {}
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      // Text(userId),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'User Name :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['fName'].toString() ??
                                        "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Insurance Holder Name :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['fName'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'NIC :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['nIC'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Date of Birth :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['dateOfBirth'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        });
  }
  Widget ContactTexts() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: widget.userId)
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
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: [
                            Container(
                              color: Colors.indigo,
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      child: Text("Contact Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () {

                                            _userID.text = document['userID'];
                                            _address.text = document['address'];


                                            showDialog(context: context, builder: (context)=>Dialog(
                                              child: Container(
                                                color: Colors.indigo[200],
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      _buildTextField(_userID, "Mobile Number"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_address, "Address"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      RaisedButton(
                                                        color: Colors.indigo,
                                                        onPressed: () {
                                                          snapshot.data.documents[index].reference.updateData({
                                                            "userID":_userID.text,
                                                            'address':_address.text,
                                                          }).whenComplete(() => Navigator.pop(context));
                                                        },
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(50.0),
                                                        ),
                                                        textColor: Colors.white,
                                                        child: Text(
                                                          "Update",
                                                          style: TextStyle(fontSize: 18),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                          }
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        // Text(userId),
                        Column(
                          children: [
                            Container(
                              // child: Image.network(document['imageUrl'],
                              //   width: 100, height: 100,fit: BoxFit.contain,),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Mobile Number :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: document['userID'].toString() ??
                                          "",
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Address :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: document['address'] ?? "",
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
  Widget insuranceDetails() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('userID', isEqualTo: widget.userId)
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
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            color: Colors.indigo,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      child: Text(
                                        "Insurance Details", style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      // Text(userId),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Policy No :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['policyNumber'].toString() ??
                                        "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Insurance Type :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['typeOfInsurance'].toString() ??
                                        "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Insurance Issue Date :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['insuranceIssueDate'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Issued Place :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                    text: document['issuedPlace'] ?? "",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
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
                          backgroundColor: Colors.white,
                          radius: 80.0,
                          child: Image.network(document['imageUrl'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
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