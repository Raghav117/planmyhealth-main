import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launch;

import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/UsersListScreen.dart';
import 'package:plan_my_health/UI/editProfile.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/search.dart';
import 'package:plan_my_health/model/Patient.dart';

import 'patient.dart' as p;

class PatientDetails extends StatefulWidget {
  final Patient patient;
  PatientDetails({
    Key key,
    this.patient,
    this.city,
    this.number,
    this.sId,
  }) : super(key: key);
  final String number, sId, city;

  ApiHelper apiHelper = ApiHelper();
  @override
  _PatientDetailsState createState() => _PatientDetailsState(patient);
}

class _PatientDetailsState extends State<PatientDetails>
    with WidgetsBindingObserver {
  bool isLoading = true;
  ApiHelper apiHelper = ApiHelper();
  bool onCall = false;
  final Patient patient;

  _PatientDetailsState(this.patient);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // getUserdetails();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (onCall) {
      _showDialog();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _showDialog() {
    print("dialog box call");
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Call Conformation"),
          content: new Text("Do you wish to make prescription for patient ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Prescription(
                            name: patient.name,
                            age: patient.age.toString(),
                            gender: patient.gender,
                            pid: widget.sId,
                            mobile: patient.mobile.toString())));
              },
            ),
          ],
        );
      },
    );
  }

  // void getUserdetails() {
  //   apiHelper.getPatientDetails(widget.number).then((value) {
  //     print("get Diagnosis");
  //     print(value.name);
  //     patient = value;
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: patient == null
                ? Center(
                    child: Container(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            // color: Colors.green.shade300,
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                            child: Text("Back",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                        Container(
                          color: Colors.green.shade300,
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset("assets/logo.jpeg"),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.name,
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Age: " +
                                            patient.age.toString() +
                                            " years old ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Gender: " + patient.gender,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(height: 2, color: Colors.green),
                              SizedBox(height: 8),
                              Row(children: [
                                Icon(Icons.location_city),
                                SizedBox(width: 5),
                                Text(
                                  widget.city.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Card(
                          elevation: 10,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Symptoms",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: patient.symptoms.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        patient.symptoms[index]["name"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Services",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: patient.services.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        patient.services[index]["name"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                            //   color: Colors.pink.shade300,
                            child: Column(children: [
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => p.Patient(
                                              patient: patient,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "View Details",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Search(
                                              previous: true,
                                              patient: patient,
                                              // patient: patient,
                                            ),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Prescriptions",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  await launch.launch(
                                      "https://wa.me/+91${widget.number}?text=Hello ${patient.name},\nThis is ${data.name} trying to connect with you for your Health Issue");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Whatsapp",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _showDialog(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Create Prescription",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                        SizedBox(height: 15),
                      ],
                    ),
                  )),
      ),
    );
  }

  String url(String phone) {
    print("Call url function");
    if (Platform.isAndroid) {
      // add the [https]

      onCall = true;

      return "https://wa.me/$phone/?text= "; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone= "; // new line
    }
  }
}
