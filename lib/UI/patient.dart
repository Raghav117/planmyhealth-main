import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/UI/pdfOpener.dart';
import 'dart:convert';
import 'dart:io';
import '../model/doctorsCheckup.dart';
import '../global/global.dart' as global;
import '../model/Patient.dart' as p;

class Patient extends StatefulWidget {
  final p.Patient patient;

  const Patient({Key key, this.patient}) : super(key: key);
  @override
  _PatientState createState() => _PatientState(patient);
}

class _PatientState extends State<Patient> {
  final p.Patient patient;
  List<Map> m;
  bool loading = false;
  List<DoctorsCheckUp> doctorcheckup = List();
  List<UserData> userData = List();
  bool show = false;
  var data;
  List<String> documentsfiles = [];

  _PatientState(this.patient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text('Profile', style: GoogleFonts.dosis()),
        backgroundColor: Colors.greenAccent,
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          // color: Colors.greenAccent,
                          color: Colors.white,
                          // border: Border.all(color: Colors.greenAccent, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(patient.name.toString(),
                                  style: GoogleFonts.dosis()),
                              subtitle: Text(patient.email.toString(),
                                  style: GoogleFonts.dosis()),
                              isThreeLine: true,
                              // trailing: Text(
                              //   global.data.experience.toString() +
                              //       " Years Experience",
                              //   style: GoogleFonts.dosis(fontSize: 15),
                              // ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Mobile Number",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(global.data.mobile.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Age",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.age.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Gender",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.gender.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("City",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.cityId.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Height",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.height.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Weight",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.weight.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Food Habit",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.food_habit.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Life Style",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.lifestyle.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Water Intake Daily",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.water_intake_daily.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Medical History",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.medical_history.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Preferred Mode of Treatment",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.preferred_mode_of_treatment
                                          .toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Primary Health Issue",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.Primary_Health_Issue.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Preferred Language",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.preferredlanguage.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Mode Of Services",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.services.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Blood Group",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.blood_group.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Occupation",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.occupation.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Exercise Flag",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.exercise_flag.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Sick Frequently",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.sick_frequently.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Meals Per Day",
                                        style: GoogleFonts.dosis(
                                          color: Colors.greenAccent,
                                        ))),
                                Expanded(
                                  child: Text(patient.meals_per_day.toString(),
                                      style: GoogleFonts.dosis()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
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
    );
  }
}
