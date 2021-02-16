import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetails extends StatefulWidget {
  PatientDetails({Key key, this.number, this.sId, this.city}) : super(key: key);
  final String number, sId, city;

  ApiHelper apiHelper = ApiHelper();
  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails>
    with WidgetsBindingObserver {
  bool isLoading = true;
  ApiHelper apiHelper = ApiHelper();
  bool onCall = false;
  Patient patient;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserdetails();
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

  void getUserdetails() {
    apiHelper.getPatientDetails(widget.number).then((value) {
      print("get Diagnosis");
      print(value.name);
      patient = value;
      setState(() {});
    });
  }

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
                : Column(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ])
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            // Text(
                            //   "Problem: ",
                            //   style: TextStyle(
                            //       fontSize: 18, fontWeight: FontWeight.w800),
                            // ),
                            // SizedBox(height: 8),
                            // Text(
                            //   "Take the time to make some notes about your symptoms before you call or visit the doctor. Worrying about your symptoms is not a sign of weakness. Being honest about what you are experiencing doesn't mean that you are complaining. The doctor needs to know how you feel.",
                            //   style: TextStyle(
                            //       fontSize: 14, fontWeight: FontWeight.w400),
                            // ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                          //   color: Colors.pink.shade300,
                          child: Column(children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         print("Phone call");
                            //       },
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //             color: Colors.green,
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(6))),
                            //         alignment: Alignment.center,
                            //         child: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: Row(
                            //               children: [
                            //                 Icon(Icons.phone),
                            //                 SizedBox(width: 5),
                            //                 Text(
                            //                   "Phone",
                            //                   style: TextStyle(
                            //                       fontSize: 20,
                            //                       fontWeight: FontWeight.w600),
                            //                 ),
                            //               ],
                            //             )),
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         print("send email");
                            //       },
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //             color: Colors.green,
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(6))),
                            //         alignment: Alignment.center,
                            //         child: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: Row(
                            //               children: [
                            //                 Icon(Icons.email),
                            //                 SizedBox(width: 5),
                            //                 Text(
                            //                   "Email",
                            //                   style: TextStyle(
                            //                       fontSize: 20,
                            //                       fontWeight: FontWeight.w600),
                            //                 ),
                            //               ],
                            //             )),
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         print("send Message");
                            //       },
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //             color: Colors.green,
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(6))),
                            //         alignment: Alignment.center,
                            //         child: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: Row(
                            //               children: [
                            //                 Icon(Icons.message),
                            //                 SizedBox(width: 5),
                            //                 Text(
                            //                   "Message",
                            //                   style: TextStyle(
                            //                       fontSize: 20,
                            //                       fontWeight: FontWeight.w600),
                            //                 ),
                            //               ],
                            //             )),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showDialog(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
