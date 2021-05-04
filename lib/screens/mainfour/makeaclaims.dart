import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insmanager/screens/mainfour/myclaims.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MakeClaim extends StatefulWidget {
  String vehicle;
  String userId;
  MakeClaim({this.vehicle, this.userId});

  @override
  _MakeClaimState createState() => _MakeClaimState();
}

class _MakeClaimState extends State<MakeClaim> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  SharedPreferences prefs;
  String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  var uuid = Uuid();
  var selectedVehicle, selectedType;

  File _image;
  final picker = ImagePicker();

  Future getImageFromGallary() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  initSheardPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    initSheardPreference();
    super.initState();
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('claims/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        var documentReference =
            Firestore.instance.collection('claims').document(selectedVehicle);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              "userId": prefs.getString("userId"),
              "licensePlate": selectedVehicle,
              "ClaimInformation": _claimInformation.text ?? "",
              "ClaimValue": _claimValue.text ?? "",
              "imageUrl": value,
              "claimId": uuid.v4(),
              "currentDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            },
          );
        });
      },
    );
  }

  TextEditingController _claimInformation = new TextEditingController();
  TextEditingController _claimValue = new TextEditingController();

  Widget _buildDropDown() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('addVehicle')
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CupertinoActivityIndicator(),
            );

          return Container(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                      child: Icon(Icons.directions_car),
                    )),
                new Expanded(
                  flex: 4,
                  child: DropdownButton(
                    value: selectedVehicle,
                    isDense: true,
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        selectedVehicle = valueSelectedByUser;
                      });
                    },
                    hint: Text('Choose Vehicle'),
                    items: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return DropdownMenuItem<String>(
                        value: document.data['licensePlate'],
                        child: Text(document.data['licensePlate']),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTextFeild() {
    return Form(
      key: _formkey,
      child: Container(
        child: Column(
          children: [
            TextFormField(
              controller: _claimInformation,
              decoration: InputDecoration(
                icon: Icon(Icons.info_outline),
                labelText: "Enter your Claim Information",
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _claimValue,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.monetization_on_outlined),
                labelText: "Enter the Claim Value",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image == null ? Text("Images are not Loaded") : Image.file(_image),
            FloatingActionButton(
              backgroundColor: Colors.indigo,
              onPressed: getImageFromGallary,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                  MaterialPageRoute(builder: (context) => Claims()),
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
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            ListTile(
              title: Text(
                "Registered Vehicles",
                style: TextStyle(fontSize: 20),
              ),
            ),
            _buildDropDown(),
            ListTile(
              title: Text(
                "Claim Information",
                style: TextStyle(fontSize: 20),
              ),
            ),
            _buildTextFeild(),
            ListTile(
              title: Text(
                "Claim Value",
                style: TextStyle(fontSize: 20),
              ),
            ),
            _buildImagePicker(),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                color: Colors.indigo,
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    _formkey.currentState.save();
                    uploadImageToFirebase(context);
                    //  Firestore.instance.collection("addVehicle").add(data);
                    Navigator.of(context).pushNamed('/claims');
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
                  "Add Claim",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
