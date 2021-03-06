import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/UI/pdfOpener.dart';
import 'dart:convert';
import 'dart:io';
import '../model/doctorsCheckup.dart';
import '../global/global.dart' as global;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<Map> m;
  bool loading = false;
  List<DoctorsCheckUp> doctorcheckup = List();
  List<UserData> userData = List();
  bool show = false;
  var data;
  List<String> documentsfiles = [];

  @override
  void initState() {
    super.initState();
    getDocumentsFiles();
  }

  getDocumentsFiles() {
    if (global.data.documentfiles != null)
      global.data.documentfiles.split(',').forEach((tag) {
        documentsfiles.add(tag);
      });

    setState(() {});
  }

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
                              leading: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Image.network(
                                          "http://3.15.233.253/" +
                                              global.data.picture),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  "http://3.15.233.253/" + global.data.picture,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.account_box_outlined),
                                ),
                              ),
                              title: Text(
                                global.data.name,
                              ),
                              subtitle: Text(global.data.email),
                              isThreeLine: true,
                              trailing: Text(
                                global.data.experience.toString() +
                                    " Years Experience",
                                style: TextStyle(fontSize: 15),
                              ),
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
                                    child: Text("Date of Birth",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(global.data.dob.toString()),
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
                                  child: Text(global.data.gender.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Specialization",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.specialization.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Expanded(
                                    child: Text("Practice",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(global.data.practice.toString()),
                                )
                              ],
                            ),

                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(child: Text("Experience")),
                            //     Expanded(
                            //       child:
                            //           Text(global.data.experience.toString()),
                            //     )
                            //   ],
                            // ),

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Qualification",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.qualification.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Mode of Services",
                                          style: TextStyle(
                                            color: Colors.green,
                                          ))),
                                  Expanded(
                                    child: Text(
                                        global.data.modeofservices.toString()),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Row(
                              children: [
                                Expanded(
                                    child: Text("Clinic Name",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child:
                                      Text(global.data.clinicname.toString()),
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
                                  child: Text(global.data.cityId.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Address",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(global.data.address.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Working From",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                    child: Text(global.data.workingfrom
                                        .toString()
                                        .replaceAll(RegExp(r'TimeOfDay'), "")))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Working To",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(global.data.workingto
                                      .toString()
                                      .replaceAll(RegExp(r'TimeOfDay'), "")),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Registration Number",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.registrationno.toString()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            //     // InkWell(
                            //     //   onTap: () {
                            //     //     show = !show;
                            //     //     setState(() {});
                            //     //   },
                            //     //   child: Container(
                            //     //     decoration: BoxDecoration(
                            //     //         color: Colors.green,
                            //     //         borderRadius: BorderRadius.circular(20)),
                            //     //     child: Padding(
                            //     //       padding: const EdgeInsets.all(18.0),
                            //     //       child: Text(
                            //     //         "Prescription List",
                            //     //         style: TextStyle(
                            //     //             color: Colors.white,
                            //     //             fontWeight: FontWeight.bold),
                            //     //       ),
                            //     //     ),
                            //     //   ),
                            //     // ),
                            SizedBox(
                              height: 30,
                            ),
                            show == false
                                ? Container()
                                : Column(
                                    children: doctorcheckup.map((e) {
                                    int index = doctorcheckup.indexOf(e);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => PdfOpener(
                                              url: "http://3.15.233.253/" +
                                                  data["doctorlist"][index]
                                                          ["pdffile"]
                                                      .replaceAll(
                                                          "/var/www/html/", ""),
                                            ),
                                          ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 3)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Name"),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index].name),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:
                                                          Text("Mobile Number"),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index]
                                                              .mobile
                                                              .toString()),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Date"),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index]
                                                              .dateOfJoining
                                                              .toString()),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Diagnosis"),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          doctorcheckup[index]
                                                              .diagnosis
                                                              .toString()),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()),

                            Text("Signature",
                                style: TextStyle(
                                  color: Colors.green,
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 300,
                              width: 300,
                              child: Image.network(
                                "http://3.15.233.253/" +
                                    global.data.signature.toString(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.account_box_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text("Document File",
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 400,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: documentsfiles.length > 0
                            ? documentsfiles.length - 1
                            : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 300,
                            width: 300,
                            child: Image.network(
                              "http://3.15.233.253/" +
                                  documentsfiles[index + 1],
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.account_box_outlined),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
