import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Vehicle extends StatefulWidget {
  String userId;
  Vehicle({this.userId});

  @override
  _VehicleState createState() => _VehicleState(userId: userId);
}

class _VehicleState extends State<Vehicle> {
  TextEditingController _policyNo = new TextEditingController();
  TextEditingController _chasisEngineNo = new TextEditingController();
  TextEditingController _licensePlate = new TextEditingController();
  TextEditingController _year = new TextEditingController();
  TextEditingController _brand = new TextEditingController();
  TextEditingController _model = new TextEditingController();
  TextEditingController _vehicleRegisterDate = new TextEditingController();

  CollectionReference ref = Firestore.instance.collection('addVehicle');

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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var selected_date;
  final format = DateFormat("yyyy-MM-dd");

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
      resizeToAvoidBottomInset: false,
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
      body: Container(
        child:Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    newqq(),
                  ],
                ),
              ),
            ),
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
            .where('user_id', isEqualTo: widget.userId)
            .snapshots(),
        // stream: Firestore.instance.collection('Videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: ListView.builder(
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
                                      child: Text("Vehicle Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () {

                                            _policyNo.text = document['policyNo'];
                                            _licensePlate.text = document['licensePlate'];
                                            _chasisEngineNo.text = document['chasisEnginNo'];
                                            _year.text = document['Year'];
                                            _brand.text = document['Brand'];
                                            _model.text = document['model'];
                                            _vehicleRegisterDate.text = document['vehicleRegisterDate'];


                                            showDialog(context: context, builder: (context)=>Dialog(
                                              child: Container(
                                                color: Colors.indigo[200],
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ListView(
                                                    shrinkWrap: true,
                                                    children: [
                                                      _buildTextField(_policyNo, "Policy No"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_licensePlate, "License Plate"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_chasisEngineNo, "Chasis Engine Number"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_year, "Year"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_brand, "Brand"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_model, "Model"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      _buildTextField(_vehicleRegisterDate, "Vehicle Registered Date"),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      RaisedButton(
                                                        color: Colors.indigo,
                                                        onPressed: () {
                                                          snapshot.data.documents[index].reference.updateData({
                                                          "policyNo":_policyNo.text,
                                                          'licensePlate':_licensePlate.text,
                                                          'chasisEnginNo': _chasisEngineNo.text ,
                                                          'Year':_year.text,
                                                          'Brand':_brand.text,
                                                          'model':_model.text,
                                                          'vehicleRegisterDate':_vehicleRegisterDate.text,
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
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        focusColor: Colors.white,
                                        onPressed: (){
                                          _policyNo.text = document['policyNo'];
                                          _licensePlate.text = document['licensePlate'];
                                          _chasisEngineNo.text = document['chasisEnginNo'];
                                          _year.text = document['Year'];
                                          _brand.text = document['Brand'];
                                          _model.text = document['model'];
                                          _vehicleRegisterDate.text = document['vehicleRegisterDate'];


                                          showDialog(context: context, builder: (context)=>Dialog(
                                            child: Container(
                                              color: Colors.indigo[200],
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: [
                                                    _buildTextField(_policyNo, "Policy No"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_licensePlate, "License Plate"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_chasisEngineNo, "Chasis Engine Number"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_year, "Year"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_brand, "Brand"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_model, "Model"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    _buildTextField(_vehicleRegisterDate, "Vehicle Registered Date"),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    RaisedButton(
                                                      color: Colors.indigo,
                                                      onPressed: () {
                                                        snapshot.data.documents[index].reference.delete()
                                                            .whenComplete(() => Navigator.pop(context));
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(50.0),
                                                      ),
                                                      textColor: Colors.white,
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                        },
                                      )
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
                              child: Image.network(document['imageUrl'],
                                width: 100, height: 100,fit: BoxFit.contain,),
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
                                      text: 'Policy Number :',
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
                                      text: 'Vehicle Registered Date :',
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
                            SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          );
        });
  }
}
