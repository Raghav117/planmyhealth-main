import 'package:flutter/material.dart';
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
        title: Text('Profile'),
        backgroundColor: Colors.green,
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
                          // color: Colors.green,
                          color: Colors.white,
                          // border: Border.all(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              // leading: Image.network(
                              //   "http://3.15.233.253/" + patient.picture,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       Icon(Icons.account_box_outlined),
                              // ),
                              // leading: Image.network(
                              //   "http://3.15.233.253/" + global.data.picture,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       Icon(Icons.account_box_outlined),
                              // ),
                              title: Text(
                                patient.name.toString(),
                              ),
                              subtitle: Text(patient.email.toString()),
                              isThreeLine: true,
                              // trailing: Text(
                              //   global.data.experience.toString() +
                              //       " Years Experience",
                              //   style: TextStyle(fontSize: 15),
                              // ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Mobile Number",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(global.data.mobile.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.age.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.gender.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.cityId.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.height.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.weight.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.food_habit.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.lifestyle.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.water_intake_daily.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child:
                                      Text(patient.medical_history.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient
                                      .preferred_mode_of_treatment
                                      .toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.Primary_Health_Issue.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      patient.preferredlanguage.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.services.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.blood_group.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.occupation.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.exercise_flag.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child:
                                      Text(patient.sick_frequently.toString()),
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
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(patient.meals_per_day.toString()),
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
