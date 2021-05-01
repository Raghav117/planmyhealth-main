import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/SelectWallness.dart';
import 'package:plan_my_health/UI/addMedicines.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/UI/SelectTest.dart';
import 'package:plan_my_health/UI/findings.dart';
import 'package:plan_my_health/UI/pdfOpener.dart';
import 'package:plan_my_health/UI/suspectedDisease.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:plan_my_health/model/Diagnosis.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:plan_my_health/model/Wellness.dart';
import 'package:plan_my_health/model/findings.dart';
import 'package:plan_my_health/model/suspectedDisease.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Home.dart';

class Prescription extends StatefulWidget {
  Prescription(
      {Key key,
      this.name,
      this.age,
      this.gender,
      this.pid,
      this.mobile,
      this.patient})
      : super(key: key);

  final String name;
  final String age;
  final String pid;
  final String gender;
  final String mobile;
  final Patient patient;
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  ApiHelper apiHelper = ApiHelper();
  TextEditingController medicineSerchController,
      remarkController = TextEditingController();

  List<Map<String, String>> dia = [];
  List<Map<String, String>> spe = [];
  List<Medicinelist> medicinelist = [];
  DateTime followupdate;
  List<Finding> findings = [];
  List<SuspectedDisease> suspectedDisease = [];
  var isSelected = false;
  var mycolor = Colors.green;

  var diagnosislistStatus = <bool>[];

  String name, id, medid;
  bool hospitalise;
  List<SelectMedicineList> selectMedicineList = [];
  List<bool> colors = [];
  List<bool> suspectedColors = [];

  List<SelectTestList> selectTestList = [];
  List<SelectedDisease> selectedDiseaseList = [];

  List<Wellnesslist> selectwellnesslist = [];

  String diagnosisSelected;
  String specialitiesSelected, timeSelected, quntitySelected, withSelected;

  double rat = 5;

  @override
  void initState() {
    super.initState();

    followupdate = DateTime.now().add(Duration(days: 3));
    getMedicines();
    getDiagnosis();
    getSpecialities();
    getShared();
    getFindings();
    getSuspectedDisease();
    medicineSerchController = TextEditingController();
  }

  void getSuspectedDisease() async {
    var response = await http.get("http://3.15.233.253:5000/diagnosis");
    var data = jsonDecode(response.body);
    data["diagnosislist"].forEach((element) {
      suspectedDisease.add(SuspectedDisease.fromJson(element));
    });
  }

  void getFindings() async {
    var response = await http.get("http://3.15.233.253:5000/findings");
    print(response.body);
    var data = jsonDecode(response.body);
    data["findinglist"].forEach((element) {
      findings.add(Finding.fromJson(element));
    });
  }

  void getSpecialities() {
    apiHelper.getSpecialitieslist().then((value) {
      print("get Diagnosis");
      print(value[0].name);
      for (Specialitieslist specialitieslist in value) {
        spe.add({
          "name": specialitieslist.name.toString(),
          "sId": specialitieslist.sId.toString()
        });
        print(specialitieslist.sId.toString());
      }
      setState(() {});
    });
  }

  void getDiagnosis() {
    apiHelper.getDiagnosislist().then((value) {
      for (Diagnosislist diagnosislist in value) {
        dia.add({
          "diagnosisName": diagnosislist.diagnosisName.toString(),
          "sId": diagnosislist.sId.toString()
        });
      }
      setState(() {});
    });
  }

  void getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("get img: " + prefs.getString('name').toString());
    setState(() {
      name = prefs.getString('name').toString();
      // id = prefs.getString('id').toString();
      id = "fc7d1b6999df38f1bc95367";
    });
  }

  void getMedicines() {
    apiHelper.getMedicinelist().then((value) {
      setState(() {
        medicinelist = value;
      });
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
          child: ListView(children: [
        ListTile(
          title: Text("Home", style: GoogleFonts.dosis()),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          },
        ),
        ListTile(
          title: Text("Logout", style: GoogleFonts.dosis()),
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return MyApp();
              },
            ));
          },
        ),
      ])),
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  color: Colors.greenAccent,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            if (scaffoldKey.currentState.isDrawerOpen) {
                              scaffoldKey.currentState.openEndDrawer();
                            } else {
                              scaffoldKey.currentState.openDrawer();
                            }
                          }),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Write Prescription",
                            style: GoogleFonts.dosis(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width,
                      // height: 100,
                      color: Colors.greenAccent.withOpacity(0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Name :",
                                  style: GoogleFonts.dosis(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(widget.name.toString() + ",  ",
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                    )),
                                Text(widget.gender.toString() + ",  ",
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                    )),
                                Text(widget.age.toString() + " years old ,  ",
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                    )),
                                Text(
                                    "Ht : " +
                                        widget.patient.height.toString() +
                                        ",  ",
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                    )),
                                Text("Wt : " + widget.patient.weight.toString(),
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                    )),
                              ]),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Symptoms",
                                    style: GoogleFonts.dosis(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: 20,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.patient.symptoms.length,
                                        itemBuilder: (context, index) => Text(
                                          widget.patient.symptoms[index] + ",",
                                          style: GoogleFonts.dosis(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Services",
                                    style: GoogleFonts.dosis(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(widget.patient.services,
                                      style: GoogleFonts.dosis(
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Remarks",
                                style: GoogleFonts.dosis(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(widget.patient.remarks,
                                  style: GoogleFonts.dosis(
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Health Issue",
                                style: GoogleFonts.dosis(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(widget.patient.Primary_Health_Issue,
                                  style: GoogleFonts.dosis(
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Findings",
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      var response = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Findings(
                                            findings: findings,
                                          ),
                                        ),
                                      );
                                      if (response != null) colors = response;
                                      // print(response);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.add,
                                        size: 20, color: Colors.greenAccent))
                              ],
                            ),
                            colors.indexOf(true) == -1
                                ? Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Not Selected",
                                          style: GoogleFonts.dosis()),
                                    ),
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: colors.length,
                                      itemBuilder: (context, index) {
                                        return colors[index] == true
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    findings[index].name,
                                                    style: GoogleFonts.dosis(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    )),
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Suspected Disease",
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      var response = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SuspectedDiseases(
                                            suspectedDisease: suspectedDisease,
                                          ),
                                        ),
                                      );
                                      print(response);
                                      setState(() {});
                                      if (response != null)
                                        suspectedColors = response;
                                      // print(response);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.add,
                                        size: 20, color: Colors.greenAccent))
                              ],
                            ),
                            suspectedColors.indexOf(true) == -1
                                ? Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Not Selected",
                                          style: GoogleFonts.dosis()),
                                    ),
                                  )
                                : Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: suspectedColors.length,
                                      itemBuilder: (context, index) {
                                        return suspectedColors[index] == true
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    suspectedDisease[index]
                                                        .diagnosisName,
                                                    style: GoogleFonts.dosis(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    )),
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),

                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add Medicines",
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      selectMedicineList = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddMedicines(
                                              selectMedicineList:
                                                  selectMedicineList),
                                        ),
                                      );

                                      setState(() {});
                                      print("send back data" +
                                          selectMedicineList.length //
                                              .toString());
                                    },
                                    child: Icon(Icons.add,
                                        size: 20, color: Colors.greenAccent))
                              ],
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(
                                        0xFFDDDDDD), //                   <--- border color
                                    width: 0.8,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: selectMedicineList.isEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            " Not Selected",
                                            style: GoogleFonts.dosis(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          )),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: selectMedicineList.length,
                                        itemBuilder: (context, index) {
                                          print(selectMedicineList.toString());
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          selectMedicineList[
                                                                  index]
                                                              .name
                                                              .toString(),
                                                          style:
                                                              GoogleFonts.dosis(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      15)),
                                                      Icon(Icons.delete,
                                                          size: 15)
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        selectMedicineList[
                                                                    index]
                                                                .time
                                                                .toString() +
                                                            "," +
                                                            selectMedicineList[
                                                                    index]
                                                                .qut
                                                                .toString() +
                                                            " tablet with " +
                                                            selectMedicineList[
                                                                    index]
                                                                .withtake
                                                                .toString() +
                                                            " for " +
                                                            selectMedicineList[
                                                                    index]
                                                                .days,
                                                        style:
                                                            GoogleFonts.dosis(
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ])),
                                          );
                                        })),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select Test",
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      selectTestList = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectTest()));

                                      setState(() {});
                                      print("send back data" +
                                          selectTestList.length.toString());
                                    },
                                    child: Icon(Icons.add,
                                        size: 20, color: Colors.greenAccent))
                              ],
                            ),

                            Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(
                                        0xFFDDDDDD), //                   <--- border color
                                    width: 0.8,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF0000000F),
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        15.0, // Move to right 10  horizontally
                                        15.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: selectTestList.isEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            " Not Selected",
                                            style: GoogleFonts.dosis(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          )),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: selectTestList.length,
                                        itemBuilder: (context, index) {
                                          // print(selectTestList.toString());
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                child: Column(children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.pages),
                                                        Text(
                                                            selectTestList[
                                                                    index]
                                                                .name,
                                                            style: GoogleFonts
                                                                .dosis(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15)),
                                                      ],
                                                    ),
                                                    Icon(Icons.delete, size: 15)
                                                  ]),
                                              SizedBox(height: 8),
                                            ])),
                                          );
                                        })),

                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Follow Up Date",
                                    style: GoogleFonts.dosis(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  followupdate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(2025),
                                  );
                                  setState(() {});
                                },
                                child: followupdate == null
                                    ? Container(
                                        child: Icon(Icons.add,
                                            color: Colors.greenAccent),
                                      )
                                    : Text(
                                        followupdate.day.toString() +
                                            '-' +
                                            followupdate.month.toString() +
                                            '-' +
                                            followupdate.year.toString(),
                                        style: GoogleFonts.dosis(
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Text(
                              "Hospitalization required ?",
                              style: GoogleFonts.dosis(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // SizedBox(height: 5),

                            Container(
                                child: Row(
                              children: [
                                SizedBox(width: 20),
                                Container(
                                    child: Row(
                                  children: [
                                    Radio(
                                      groupValue: hospitalise,
                                      value: true,
                                      onChanged: (val) {
                                        setState(() {
                                          hospitalise = val;

                                          print(hospitalise.toString());
                                        });
                                      },
                                    ),
                                    Text("Yes", style: GoogleFonts.dosis())
                                  ],
                                )),
                                SizedBox(width: 10),
                                Container(
                                    child: Row(
                                  children: [
                                    Radio(
                                      groupValue: hospitalise,
                                      value: false,
                                      onChanged: (val) {
                                        setState(() {
                                          hospitalise = val;
                                          print(hospitalise.toString());
                                        });
                                      },
                                    ),
                                    Text("No", style: GoogleFonts.dosis())
                                  ],
                                )),
                              ],
                            )),

                            SizedBox(height: 12),
                            Text(
                              "Specialist consultation",
                              style: GoogleFonts.dosis(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)),
                              child: DropdownButtonFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0)),
                                  labelText: "Specialities",
                                  hintText: "Specialist consultation",
                                ),
                                elevation: 2,
                                icon: Icon(Icons.arrow_drop_down),
                                value: specialitiesSelected,
                                onChanged: (value) {
                                  setState(() {});
                                  specialitiesSelected = value;
                                },
                                items: spe.map((type) {
                                  return DropdownMenuItem(
                                    value: type['name'],
                                    child: Text(
                                      type['name'],
                                      style: GoogleFonts.dosis(
                                          color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return "Select Country is required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Wellness Tips",
                                  style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      selectwellnesslist = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectWallness()));

                                      setState(() {});
                                      print("send back data" +
                                          selectwellnesslist.length.toString());
                                    },
                                    child: Icon(Icons.add,
                                        size: 20, color: Colors.greenAccent))
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(
                                        0xFFDDDDDD), //                   <--- border color
                                    width: 0.8,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF0000000F),
                                      blurRadius: 25.0, // soften the shadow
                                      spreadRadius: 5.0, //extend the shadow
                                      offset: Offset(
                                        15.0, // Move to right 10  horizontally
                                        15.0, // Move to bottom 10 Vertically
                                      ),
                                    )
                                  ],
                                ),
                                child: selectwellnesslist.isEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            " Not Selected",
                                            style: GoogleFonts.dosis(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                          )),
                                        ],
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: selectwellnesslist.length,
                                        itemBuilder: (context, index) {
                                          print(selectTestList.toString());
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(Icons.pages),
                                                              Text(
                                                                  selectwellnesslist[
                                                                          index]
                                                                      .wellnessname,
                                                                  style: GoogleFonts.dosis(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                            ],
                                                          ),
                                                          Icon(Icons.delete,
                                                              size: 15)
                                                        ]),
                                                    SizedBox(height: 8),
                                                  ]),
                                            ),
                                          );
                                        })),

                            Text(
                              "Ratings",
                              style: GoogleFonts.dosis(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            RatingBar.builder(
                              initialRating: 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.greenAccent,
                              ),
                              onRatingUpdate: (rating) {
                                rat = rating;
                                print(rating);
                              },
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Special notes",
                              style: GoogleFonts.dosis(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                                controller: remarkController,
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.dosis(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  labelText: "Write Remark",
                                  hintText: 'Type here...',
                                  hintStyle: GoogleFonts.dosis(
                                    fontSize: 15,
                                  ),
                                )),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                String url;
                                List<Finding> find = [];
                                List<SuspectedDisease> diagnosis = [];
                                int index = -1;
                                colors.forEach((element) {
                                  if (element == true) {
                                    find.add(findings[++index]);
                                  } else
                                    ++index;
                                });
                                index = -1;
                                suspectedColors.forEach((element) {
                                  if (element == true) {
                                    diagnosis.add(suspectedDisease[++index]);
                                  } else {
                                    ++index;
                                  }
                                });
                                var response = await http.post(
                                    "http://3.15.233.253:5000/checkdoctorexist",
                                    body: {
                                      "mobilenumber": mobileController.text
                                    });
                                var data = jsonDecode(response.body);
                                print(data["data"]["_id"]);
                                print(json.encode(suspectedDisease));
                                print(json.encode(selectMedicineList));
                                await apiHelper
                                    .sendPrescription(
                                        data["data"]["_id"].toString(),
                                        data["data"]["name"].toString(),
                                        data["data"]["gender"].toString(),
                                        widget.age.toString(),
                                        814,
                                        "abc123",
                                        widget.pid.toString(),
                                        widget.name.toString(),
                                        selectMedicineList,
                                        selectTestList,
                                        hospitalise,
                                        specialitiesSelected.toString(),
                                        selectwellnesslist,
                                        remarkController.text,
                                        find,
                                        followupdate,
                                        diagnosis,
                                        rat)
                                    .then((value) {
                                  print(value);
                                  if (value != null) {
                                    url = "http://3.15.233.253/" +
                                        value.replaceAll("/var/www/html/", "");
                                    print(url);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfOpener(
                                              url: url,
                                              name: widget.name,
                                              mobile: widget.mobile),
                                        )); //     );
                                  } else {
                                    print("Error");
                                  }
                                });
                              },
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  alignment: Alignment.center,
                                  child: Text("Save",
                                      style: GoogleFonts.dosis(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ]),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
