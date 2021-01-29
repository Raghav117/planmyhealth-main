import 'dart:convert';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/Helpers/Medicine.dart';
//import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:plan_my_health/UI/SelectWallness.dart';
import 'package:plan_my_health/UI/Selections/Abc.dart';
import 'package:plan_my_health/UI/Selections/SeLectDisese.dart';

import 'package:plan_my_health/UI/Selections/SelectTest.dart';
import 'package:plan_my_health/UI/viewPdf.dart';
import 'package:plan_my_health/model/Diagnosis.dart';
import 'package:plan_my_health/model/Diagnostics.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:plan_my_health/model/Wellness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Prescription extends StatefulWidget {
  Prescription(
      {Key key, this.name, this.age, this.gender, this.pid, this.mobile})
      : super(key: key);

  final String name;
  final String age;
  final String pid;
  final String gender;
  final String mobile;
  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
//  GlobalKey<AutoCompleteTextFieldState<Medicinelist>> key = new GlobalKey();
  ApiHelper apiHelper = ApiHelper();
  TextEditingController medicineSerchController, remarkController;
  List<Map<String, String>> dia = [];
  List<Map<String, String>> spe = [];
  List<Medicinelist> medicinelist = [];
  var isSelected = false;
  var mycolor = Colors.green;

  var diagnosislistStatus = List<bool>();

  String name, id, medid;
  bool hospitalise;
  // List<Map<String, String>> selectMedicineList = [];
  // List<Map<String, String>> selectTestList = [];
  // List<Map<String, String>> selectWellnessList = [];

  //------------------------
  List<SelectMedicineList> selectMedicineList = [];

  List<SelectTestList> selectTestList = [];
  List<SelectedDisease> selectedDiseaseList = [];

  List<Wellnesslist> selectwellnesslist = [];

  //------------------
  String diagnosisSelected;
  String specialitiesSelected, timeSelected, quntitySelected, withSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMedicines();
    getDiagnosis();
    getSpecialities();
    getShared();
    medicineSerchController = TextEditingController();
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

  String url(String phone) {
    print("Call url function");
    if (Platform.isAndroid) {
      // add the [https]

      return "https://wa.me/$phone/?text= "; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone= "; // new line
    }
  }

  @override
  Medicines userSave = Medicines();
  String dropdownValue;
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 15, 15),
                      child: Text(
                        "Write Prescription",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: Colors.grey.shade600,
                    child: Column(
                      children: [
                        Row(children: [
                          Text(
                            "Name: " + widget.name.toString(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ]),
                        SizedBox(height: 5),
                        Row(children: [
                          Text("Gender: " +
                              widget.gender.toString() +
                              "           Age: " +
                              widget.age.toString() +
                              " years old"),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      height: MediaQuery.of(context).size.height - 184,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Select Suspected Disease",
                              //   style: TextStyle(
                              //       fontSize: 20,
                              //       color: Colors.black,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select Suspected Disease",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        selectedDiseaseList =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectDisese()));

                                        setState(() {});
                                        print("send back data" +
                                            selectedDiseaseList.length
                                                .toString());
                                      },
                                      child: Icon(Icons.add, size: 30))
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
                                  child: selectedDiseaseList.isEmpty
                                      ? Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              " Not Selected",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )),
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectedDiseaseList.length,
                                          itemBuilder: (context, index) {
                                            // print(selectTestList.toString());
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
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
                                                              selectedDiseaseList[
                                                                      index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20)),
                                                        ],
                                                      ),
                                                      Icon(Icons.delete,
                                                          size: 22)
                                                    ]),
                                                SizedBox(height: 8),
                                              ])),
                                            );
                                          })),

                              // Container(
                              //   height: 60,
                              //   decoration: BoxDecoration(
                              //       // color: AppColors.EDITTEXT_BG_COLOR,
                              //       // border: Border.all(
                              //       //     color: AppColors.EDITTEXT_BORDER_COLOR,
                              //       //     width: 1.0),
                              //       borderRadius: BorderRadius.circular(4)),
                              //   child: DropdownButtonFormField(
                              //     autovalidateMode: AutovalidateMode.disabled,
                              //     decoration: InputDecoration(
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.grey, width: 1.0)),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //             color: Colors.grey, width: 1.0),
                              //       ),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.grey, width: 1.0)),
                              //       labelText: "Suspected Disease",
                              //       hintText: "Select Suspected Disease",
                              //     ),
                              //     elevation: 2,
                              //     icon: Icon(Icons.arrow_drop_down),
                              //     value: diagnosisSelected,
                              //     onChanged: (value) {
                              //       setState(() {});
                              //       diagnosisSelected = value;
                              //     },
                              //     items: dia.map((type) {
                              //       return DropdownMenuItem(
                              //         value: type['sId'],
                              //         child: Text(
                              //           type['diagnosisName'],
                              //           style: TextStyle(color: Colors.black),
                              //         ),
                              //       );
                              //     }).toList(),
                              //     validator: (value) {
                              //       if (value == null) {
                              //         return "Select Country is required";
                              //       }
                              //       return null;
                              //     },
                              //   ),
                              // ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Add Medicines",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      // onTap: () {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => Abc()));
                                      // },
                                      // onTap: () {
                                      //   addMedicines(context);
                                      // },
                                      onTap: () async {
                                        selectMedicineList =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Abc(
                                                selectMedicineList:
                                                    selectMedicineList),
                                          ),
                                        );

                                        // setState(() {});
                                        print("send back data" +
                                            selectMedicineList.length //
                                                .toString());
                                      },
                                      child: Icon(Icons.add, size: 30))
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
                                  child: selectMedicineList.isEmpty
                                      ? Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              " Not Selected",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )),
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectMedicineList.length,
                                          itemBuilder: (context, index) {
                                            print(
                                                selectMedicineList.toString());
                                            return Container(
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
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 20)),
                                                      Icon(Icons.delete,
                                                          size: 22)
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
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ]));
                                          })),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select Test",
                                    style: TextStyle(
                                        fontSize: 20,
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
                                      child: Icon(Icons.add, size: 30))
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )),
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectTestList.length,
                                          itemBuilder: (context, index) {
                                            // print(selectTestList.toString());
                                            return Container(
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
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20)),
                                                      ],
                                                    ),
                                                    Icon(Icons.delete, size: 22)
                                                  ]),
                                              SizedBox(height: 8),
                                            ]));
                                          })),
                              Text(
                                "Need to Hospitalise",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),

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
                                      Text("Yes")
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
                                      Text("No")
                                    ],
                                  )),
                                ],
                              )),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {
                              //         hospitalise = false;
                              //       },
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //             color: Colors.grey,
                              //             borderRadius: BorderRadius.all(
                              //                 Radius.circular(6))),
                              //         alignment: Alignment.center,
                              //         child: Padding(
                              //           padding: const EdgeInsets.fromLTRB(
                              //               30, 10, 30, 10),
                              //           child: Text(
                              //             " No ",
                              //             style: TextStyle(
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.w600),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(width: 100),
                              //     GestureDetector(
                              //       onTap: () {
                              //         hospitalise = true;
                              //       },
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //             color: Colors.green,
                              //             borderRadius: BorderRadius.all(
                              //                 Radius.circular(6))),
                              //         alignment: Alignment.center,
                              //         child: Padding(
                              //           padding: const EdgeInsets.fromLTRB(
                              //               30, 10, 30, 10),
                              //           child: Text(
                              //             " Yes ",
                              //             style: TextStyle(
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.w600),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 12),
                              Text(
                                "Select Specialities",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 60,
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
                                    hintText: "Select Specialities",
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
                                        style: TextStyle(color: Colors.black),
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
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Wellness Tips",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        selectwellnesslist =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectWallness()));

                                        setState(() {});
                                        print("send back data" +
                                            selectwellnesslist.length
                                                .toString());
                                      },
                                      child: Icon(Icons.add, size: 30))
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            )),
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectwellnesslist.length,
                                          itemBuilder: (context, index) {
                                            print(selectTestList.toString());
                                            return Container(
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
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                            ],
                                                          ),
                                                          Icon(Icons.delete,
                                                              size: 22)
                                                        ]),
                                                    SizedBox(height: 8),
                                                  ]),
                                            );
                                          })),
                              Text(
                                "Remark",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                  controller: remarkController,
                                  keyboardType: TextInputType.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    labelText: "Write Remark",
                                    hintText: 'Type here...',
                                    hintStyle: TextStyle(
                                      letterSpacing: 0.4,
                                      fontFamily: "HelveticaNeueMedium",
                                      fontSize: 15,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0)),
                                  )),
                              // TextFormField(
                              //     controller: remarkController,
                              //     decoration: InputDecoration(
                              //       fillColor: Colors.black,
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.grey, width: 1.0)),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //             color: Colors.black, width: 1.0),
                              //       ),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(
                              //               color: Colors.black, width: 1.0)),
                              //       labelText: "Write Remark",
                              //       hintText: 'Type here...',
                              //       hintStyle: TextStyle(
                              //           letterSpacing: 0.4,
                              //           fontFamily: "HelveticaNeueMedium",
                              //           fontSize: 14,
                              //           color: Colors.grey),
                              //       suffixIcon: Container(
                              //         padding: const EdgeInsets.fromLTRB(
                              //             20, 12, 20, 12),
                              //       ),
                              //     )),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  print("sp-----------------" +
                                      specialitiesSelected.toString());

                                  var prescription = apiHelper
                                      .sendPrescription(
                                          widget.pid,
                                          widget.name,
                                          widget.gender,
                                          widget.age,
                                          814,
                                          "abc123",
                                          id,
                                          name,
                                          selectMedicineList,
                                          selectTestList,
                                          hospitalise,
                                          specialitiesSelected,
                                          selectwellnesslist,
                                          "hello remark",
                                          selectedDiseaseList)
                                      .then((value) {
                                    print("-------------------------");
                                    print(value);
                                    print("-------------------------");
                                    String url = "http://3.15.233.253/" +
                                        value.replaceAll("/var/www/html/", "");

                                    String domain =
                                        "https://www.planmyhealth.in/" +
                                            value.replaceAll(
                                                "/var/www/html/", "");

                                    String message = "Hello " +
                                        widget.name +
                                        "your prescription genreted by Dr. " +
                                        name +
                                        " \n Plese view your digital prescription by open below Link. \n *Link:* " +
                                        url +
                                        "\n\n *with domain* " +
                                        domain;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title:
                                              new Text("Successfully Complete"),
                                          content: new Text("patient " +
                                              widget.name +
                                              "'s prescription is ready to send as pdf On whatsApp"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            Row(
                                              children: [
                                                new FlatButton(
                                                  onPressed: () {
                                                    launch(
                                                        "https://wa.me/+91 " +
                                                            widget.mobile +
                                                            "/?text=" +
                                                            message +
                                                            "");
                                                  },
                                                  child: new Text(
                                                      "Send on Whatsapp"),
                                                ),
                                                SizedBox(width: 80),
                                                new FlatButton(
                                                    child: new Text(
                                                        "View and Send"),
                                                    onPressed: () =>

                                                        // Navigator.push(
                                                        //     this.context,
                                                        //     MaterialPageRoute(
                                                        //         builder:
                                                        //             (context) =>
                                                        //                 MyWebView(
                                                        //                   title:
                                                        //                       "Prescription",
                                                        //                   selectedUrl: url,
                                                        //                 )))
                                                        _launchURL(url)),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );

                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) => MyWebView(
                                    //       title: "Existing clients",
                                    //       selectedUrl: '$url'),
                                    // );
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      "Save Prescription",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ]),
                      )),
                ],
              ),
            )),
      ),
    );
  }

  _launchURL(String urlpdf) async {
    String url = urlpdf;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget medCard(Medicinelist medicinelist) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              medicinelist.drugName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              medicinelist.composition,
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  void addWellness(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 100,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Column(children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "   Select Wellness Tips",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close    "),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    FutureBuilder<List<Wellnesslist>>(
                      future: apiHelper.getWellnesslist(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Wellnesslist> data = snapshot.data;
                          return wellnessList(data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ],
                )),
              )
            ])));
  }

  ListView wellnessList(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return wellnessTile(data, index);
        });
  }

  ListTile wellnessTile(dynamic wellnesslist, int index) => ListTile(
      onTap: () {
        //--old
        // selectWellnessList.add({
        //   "id": wellnesslist[index].sId.toString(),
        //   "name": wellnesslist[index].wellnessname.toString()
        // });
        // setState(() {});
        // print(selectWellnessList.toString());

        Wellnesslist selectwellness = new Wellnesslist();

        selectwellness.sId = wellnesslist[index].sId.toString();
        selectwellness.wellnessname =
            wellnesslist[index].wellnessname.toString();
        selectwellnesslist.add(selectwellness);
        setState(() {});
        Navigator.of(context).pop();
      },
      title: Container(
        padding: const EdgeInsets.fromLTRB(8, 9, 8, 9),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Color(0xFFDDDDDD))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wellnesslist[index].wellnessname,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ));

  void addDisease(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 100,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Column(children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "   Select Disease",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close    "),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    FutureBuilder<List<Diagnosislist>>(
                      future: apiHelper.getDiagnosislist(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Diagnosislist> data = snapshot.data;
                          return diagnosislistView(data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ],
                )),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Add Medicine",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ])));
  }

  ListView diagnosislistView(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          diagnosislistStatus.add(false);
          return diagnosislistTtile(data, index);
        });
  }

  Card diagnosislistTtile(dynamic diagnosislist, int index) => Card(
        color: mycolor,
        child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ListTile(
              selected: diagnosislistStatus[index],
              leading: const Icon(Icons.info),
              title: new Text("Test"),
              subtitle: new Text(diagnosislistStatus[index].toString()),
              trailing: Checkbox(
                  checkColor: Colors.white, // color of tick Mark

                  value: diagnosislistStatus[index],
                  onChanged: (bool val) {
                    //   diagnosislistStatus[index] = !diagnosislistStatus[index];
                  }),
              onTap: () {
                toggleSelection(index);
              } // what should I put here,
              )
        ]),
      );
  void toggleSelection(int index) {
    print(diagnosislistStatus[index].toString());
    // setState(() {
    //   diagnosislistStatus[index] = !diagnosislistStatus[index];
    // });

    setState(() {
      if (diagnosislistStatus[index]) {
        setState(() {
          print("change color");
          mycolor = Colors.pink;
          diagnosislistStatus[index] = !diagnosislistStatus[index];
        });
      } else {
        setState(() {
          mycolor = Colors.red;
          diagnosislistStatus[index] = !diagnosislistStatus[index];
        });
      }
    });
  }
  //ListTile diagnosislistTtile(dynamic diagnosislist, int index) => ListTile(
  // onTap: () {
  //   SelectedDisease selectedDisease = new SelectedDisease();
  //   selectedDisease.id = diagnosislist[index].sId.toString();
  //   selectedDisease.name = diagnosislist[index].diagnosisName.toString();
  //   selectedDiseaseList.add(selectedDisease);
  //   setState(() {});
  //   print(selectTestList.length);
  //   setState(() {
  //     diagnosislistStatus[index] = !diagnosislistStatus[index];
  //   });
  // },
  // title: Container(
  //   padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
  //   decoration: BoxDecoration(
  //       color: Colors.green,
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       border: Border.all(color: Color(0xFFDDDDDD))),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         diagnosislist[index].diagnosisName,
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //       ),
  //       SizedBox(height: 5),
  //     ],
  //   ),
  // ),
  // trailing: Column(
  //   mainAxisAlignment: MainAxisAlignment.end,
  //   crossAxisAlignment: CrossAxisAlignment.end,
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     Checkbox(
  //         checkColor: Colors.white, // color of tick Mark
  //         activeColor: Colors.green,
  //         value: diagnosislistStatus[index],
  //         onChanged: (bool val) {}),
  //   ],
  // ),
  // onTap: () {
  //   print("Friend id" + diagnosislist[index].id);
  //   //print(selectedDisease);
  //   SelectedDisease selectedDisease = new SelectedDisease();
  //   selectedDisease.id = diagnosislist[index].sId.toString();
  //   selectedDisease.name = diagnosislist[index].diagnosisName.toString();
  //   selectedDiseaseList.add(selectedDisease);

  //   diagnosislistStatus[index] = !diagnosislistStatus[index];
  // },
  // title: Text(
  //   diagnosislist[index].diagnosisName,
  //   style: TextStyle(
  //     fontSize: 18,
  //   ),
  // ),
  // trailing: Column(
  //   mainAxisAlignment: MainAxisAlignment.end,
  //   crossAxisAlignment: CrossAxisAlignment.end,
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     Checkbox(
  //         checkColor: Colors.white, // color of tick Mark
  //         activeColor: Colors.green,
  //         value: diagnosislistStatus[index],
  //         onChanged: (bool val) {}),
  //   ],
  // ));

  void addTest(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 100,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Column(children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "   Select Test",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close    "),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    FutureBuilder<List<Diagnosticslist>>(
                      future: apiHelper.getDiagnosticslist(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Diagnosticslist> data = snapshot.data;
                          return diagnosticslistView(data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ],
                )),
              )
            ])));
  }

  ListView diagnosticslistView(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return diagnosticslisTtile(data, index);
        });
  }

  ListTile diagnosticslisTtile(dynamic diagnosticslist, int index) => ListTile(
      onTap: () {
        //old methed
        // selectTestList.add({
        //   "id": diagnosticslist[index].sId.toString(),
        //   "name": diagnosticslist[index].name.toString()
        // });
        // setState(() {});
        // print(selectTestList.toString());

        //--- new
        SelectTestList selectTes = new SelectTestList();
        selectTes.id = diagnosticslist[index].sId.toString();
        selectTes.name = diagnosticslist[index].name.toString();
        selectTestList.add(selectTes);
        setState(() {});
        print(selectTestList.length);
        Navigator.of(context).pop();
      },
      title: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Color(0xFFDDDDDD))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diagnosticslist[index].name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Text(diagnosticslist[index].bloodQuantityRequired,
                style: TextStyle(fontSize: 12))
          ],
        ),
      ));
  void addMedicines(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height - 100,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " Add Medicines",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("close  "),
                    )
                  ],
                ),
                SizedBox(height: 20),
                // AutoCompleteTextField<Medicinelist>(
                //   key: key,
                //   controller: medicineSerchController,
                //   clearOnSubmit: false,
                //   suggestions: medicinelist,
                //   style: TextStyle(color: Colors.black, fontSize: 16.0),
                //   decoration: InputDecoration(
                //     counterText: "",
                //     focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                //     enabledBorder: OutlineInputBorder(
                //       borderSide: BorderSide(color: Colors.grey, width: 1.0),
                //     ),
                //     border: OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                //     labelText: "Search Medicines",

                //     hintText: "Search Medicines",

                //     // prefix: Icon(
                //     //   Icons.search,
                //     //   color: Colors.green,
                //     // ),
                //   ),
                //   itemFilter: (item, query) {
                //     return item.drugName
                //         .toLowerCase()
                //         .startsWith(query.toLowerCase());
                //   },
                //   itemSorter: (a, b) {
                //     return a.drugName.compareTo(b.drugName);
                //   },
                //   itemSubmitted: (item) {
                //     print("item id" + item.sId);
                //     setState(() {
                //       medicineSerchController.text = item.drugName;
                //       medid = item.sId;
                //     });
                //   },
                //   itemBuilder: (context, item) {
                //     // ui for the autocompelete row
                //     return medCard(item);
                //   },
                // ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // height: 60,
                        // width: MediaQuery.of(context).size.width/2,
                        decoration: BoxDecoration(
                            // color: AppColors.EDITTEXT_BG_COLOR,
                            // border: Border.all(
                            //     color: AppColors.EDITTEXT_BORDER_COLOR,
                            //     width: 1.0),
                            borderRadius: BorderRadius.circular(4)),
                        child: DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                            labelText: "Taken Time",
                            hintText: "Taken Time",
                            // labelStyle:
                          ),
                          elevation: 2,
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          value: timeSelected,
                          onChanged: (value) {
                            setState(() {});
                            timeSelected = value;
                          },
                          items: <String>[
                            'One time in a day',
                            'Two  time in a day',
                            'Three time in a day',
                            'Four time in a day'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12)),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Taken Time is required";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        height: 60,
                        // width: MediaQuery.of(context).size.width / 2 - 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4)),
                        child: DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0)),
                            labelText: "Taken Quantity ",
                            hintText: "Taken Quantity",
                          ),
                          elevation: 2,
                          icon: Icon(Icons.arrow_drop_down),
                          value: quntitySelected,
                          onChanged: (value) {
                            setState(() {});
                            quntitySelected = value;
                          },
                          items: <String>['Half', 'One', 'Two']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null) {
                              return "Taken Quantity is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(4)),
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.disabled,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                      labelText: "Taken With ",
                      hintText: "Taken With",
                    ),
                    elevation: 2,
                    icon: Icon(Icons.arrow_drop_down),
                    value: withSelected,
                    onChanged: (value) {
                      setState(() {});
                      withSelected = value;
                    },
                    items: <String>['water', 'Millk']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Taken With is required";
                      }
                      return null;
                    },
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    medicineSerchController.clear();
                    timeSelected = "";
                    quntitySelected = "";
                    withSelected = "";
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Add more Medicine",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("medicines Name: " +
                        medicineSerchController.text.toString());
                    print("time: " + timeSelected.toString());
                    print("qut: " + quntitySelected.toString());
                    print("with: " + withSelected.toString());
//--------old
                    // selectMedicineList.add({
                    //   "id": medid.toString(),
                    //   "name": medicineSerchController.text.toString(),
                    //   "time": timeSelected.toString(),
                    //   "qut": quntitySelected.toString(),
                    //   "with": withSelected.toString()
                    // });

                    SelectMedicineList selectMedicine =
                        new SelectMedicineList();

                    selectMedicine.id = medid.toString();

                    selectMedicine.name =
                        medicineSerchController.text.toString();
                    selectMedicine.time = timeSelected.toString();
                    selectMedicine.qut = quntitySelected.toString();
                    selectMedicine.withtake = withSelected.toString();
                    selectMedicineList.add(selectMedicine);
                    setState(() {});
                    print("===================================");
                    print(selectMedicineList[0]);
                    print('value is--> ' + json.encode(selectMedicineList[0]));
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Save ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
