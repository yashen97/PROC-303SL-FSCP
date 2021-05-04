import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insmanager/Animation/Loading.dart';
import 'package:insmanager/screens/mainfour/vehicles_screen.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController _policyNo = new TextEditingController();
  TextEditingController _chasisEngineNo = new TextEditingController();
  TextEditingController _licensePlate = new TextEditingController();
  TextEditingController _year = new TextEditingController();
  TextEditingController _brand = new TextEditingController();
  TextEditingController _model = new TextEditingController();
  TextEditingController _vehicleRegisterDate = new TextEditingController();
  bool loading = false;
  SharedPreferences prefs;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var selected_date;
  final format = DateFormat("yyyy-MM-dd");

  var uuid = Uuid();

  File _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
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
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        var documentReference = Firestore.instance
            .collection('addVehicle')
            .document(_licensePlate.text);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              "policyNo": _policyNo.text,
              "chasisEnginNo": _chasisEngineNo.text,
              "licensePlate": _licensePlate.text,
              "Year": _year.text,
              "Brand": _brand.text,
              "model": _model.text,
              "vehicleRegisterDate": _vehicleRegisterDate.text,
              "imageUrl": value,
              "user_id": prefs.getString("userId")
            },
          );
        });

        setState(() {
          loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainInterface()),
        );

        // Map<String, dynamic> data = {
        //   "policyNo": _policyNo.text,
        //   "chasisEnginNo": _chasisEngineNo.text,
        //   "licensePlate": _licensePlate.text,
        //   "Year": _year.text,
        //   "Brand": _brand.text,
        //   "model": _model.text,
        //   "vehicleRegisterDate": _vehicleRegisterDate.text,
        //   "imageUrl": value,
        // };
        // Firestore.instance.collection("addVehicle").add(data);
        // // Navigator.of(context).pushNamed('/vehicle');
      },
    );
  }

//   Future<String> uploadFile(File _image) async {
//   StorageReference storageReference = FirebaseStorage.instance
//       .ref()
//       .child('sightings/${Path.basename(_image.path)}');
//   StorageUploadTask uploadTask = storageReference.putFile(_image);
//   await uploadTask.onComplete;
//   print('File Uploaded');
//   String returnURL;
//   await storageReference.getDownloadURL().then((fileURL) {
//     returnURL =  fileURL;
//   });
//   return returnURL;
// }

  Widget _buildImagePicker() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image == null
                ? Text("Image is not Loaded")
                : Image.file(
                    _image,
                    width: 200.0,
                    height: 200,
                  ),
            FloatingActionButton(
              backgroundColor: Colors.indigo,
              onPressed: getImageFromGallery,
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                      MaterialPageRoute(builder: (context) => Vehicle()),
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
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _policyNo,
                        decoration: InputDecoration(
                          hintText: "Policy Number",
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
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _chasisEngineNo,
                        decoration: InputDecoration(
                          hintText: "Chasis Engine Number",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _licensePlate,
                        decoration: InputDecoration(
                          hintText: "License Plate",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "License Plate is not entered";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _year,
                        decoration: InputDecoration(
                          hintText: "Year",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Year is not entered";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _brand,
                        decoration: InputDecoration(
                          hintText: "Brand",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Brand Name is not entered";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: TextFormField(
                        controller: _model,
                        decoration: InputDecoration(
                          hintText: "Model",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Model is not entered";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey[200])),
                      ),
                      child: DateTimeField(
                        controller: _vehicleRegisterDate,
                        onChanged: (value) {
                          selected_date = value;
                        },
                        format: format,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: 'Registered Date',
                        ),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
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
                    _buildImagePicker(),
                    SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.indigo,
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            _formkey.currentState.save();
                            // Map<String, dynamic> data = {
                            //   "policyNo": _policyNo.text,
                            //   "chasisEnginNo": _chasisEngineNo.text,
                            //   "licensePlate": _licensePlate.text,
                            //   "Year": _year.text,
                            //   "Brand": _brand.text,
                            //   "model": _model.text,
                            //   "vehicleRegisterDate": _vehicleRegisterDate.text,
                            // };

                            setState(() {
                              loading = true;
                            });
                            uploadImageToFirebase(context);
                            //  Firestore.instance.collection("addVehicle").add(data);
                            Navigator.of(context).pushNamed('/vehicle');
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
                          "Add Vehicle",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
