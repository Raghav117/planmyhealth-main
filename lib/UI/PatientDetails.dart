import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/global/design.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:plan_my_health/src/pages/call.dart';
import 'package:url_launcher/url_launcher.dart' as launch;

import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/search.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'patient.dart' as p;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
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
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Prescription(
                            patient: patient,
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
                            // color: primary,.
                            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                            child: Text("Back",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: primary, width: 3)),
                            // color: primary,
                            // padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            "http://3.15.233.253/" +
                                                patient.picture,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Icon(
                                                    Icons.account_box_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          patient.name,
                                          style: GoogleFonts.roboto(
                                              fontSize: 24,
                                              color: primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Age: " +
                                              (patient.age.toString() == "null"
                                                  ? "0"
                                                  : patient.age.toString()),
                                          style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "Gender: " + patient.gender,
                                          style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    widget.city.toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // color: Color.fromRGBO(204, 224, 241, 0.3)
                              // color: primary.withOpacity(0.2)
                            ),
                            child: Column(
                              // spacing: 30,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(color: primary)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Symptoms",
                                              style: GoogleFonts.roboto(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  patient.symptoms.length,
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    patient.symptoms[index],
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(color: primary)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Services",
                                              style: GoogleFonts.roboto(
                                                  color: primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(patient.services,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // SizedBox(
                                //   height: 20,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Container(
                                //     width: double.infinity,
                                //     // color: primary,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       // color: Color.fromRGBO(
                                //       //     204, 224, 241, 0.3)
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Column(
                                //         children: [
                                //           Text(
                                //             "Services",
                                //             style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 18),
                                //           ),
                                //           SizedBox(
                                //             height: 20,
                                //           ),
                                //           Text(patient.services,
                                //               style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //               )),
                                //           SizedBox(
                                //             height: 20,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: primary)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Remarks",
                                          style: GoogleFonts.roboto(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(patient.remarks,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Container(
                                //     width: double.infinity,
                                //     // color: primary,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       // color: Color.fromRGBO(
                                //       //     204, 224, 241, 0.3)
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Column(
                                //         children: [
                                //           Text(
                                //             "Remarks",
                                //             style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 18),
                                //           ),
                                //           SizedBox(
                                //             height: 20,
                                //           ),
                                //           Text(patient.remarks,
                                //               style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //               )),
                                //           SizedBox(
                                //             height: 20,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: primary)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Health Issue",
                                          style: GoogleFonts.roboto(
                                              color: primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                                patient.Primary_Health_Issue,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Container(
                                //     width: double.infinity,
                                //     // color: primary,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       // color: Color.fromRGBO(
                                //       //     204, 224, 241, 0.3)
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Column(
                                //         children: [
                                //           Text(
                                //             "Health Issue",
                                //             style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 18),
                                //           ),
                                //           SizedBox(
                                //             height: 20,
                                //           ),
                                //           Text(patient.Primary_Health_Issue,
                                //               style: GoogleFonts.roboto(
                                //                 color: Colors.black,
                                //               )),
                                //           // SizedBox(
                                //           //   height: 20,
                                //           // ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
                                    MainAxisAlignment.spaceEvenly,
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
                                          color: primary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "View Details",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await [
                                        Permission.camera,
                                        Permission.microphone
                                      ].request();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CallPage(
                                                    channelName: "demo2",
                                                    role:
                                                        ClientRole.Broadcaster,
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: primary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Vedio Call",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: 8),
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
                                          color: primary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "Prescriptions",
                                          style: GoogleFonts.roboto(
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
                                      "https://wa.me/+91${widget.number}?text=Hello ${patient.name},\nThis is ${data.name} trying to connect with you for your ${widget.patient.Primary_Health_Issue}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: primary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Whatsapp",
                                      style: GoogleFonts.roboto(
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
                                      color: primary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Create Prescription",
                                      style: GoogleFonts.roboto(
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
}
