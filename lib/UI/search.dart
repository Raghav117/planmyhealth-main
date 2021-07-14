import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/global/design.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/model/PatientList.dart';
import 'package:plan_my_health/model/doctorsCheckup.dart';

import '../global/global.dart' as global;
import 'pdfOpener.dart';
import '../model/Patient.dart';

class Search extends StatefulWidget {
  final bool previous;
  final Patient patient;
  Search({
    Key key,
    this.previous,
    this.patient,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with WidgetsBindingObserver {
  List<Doctorlist> orderList;
  List<Patient> patient = [];
  bool onCall = false;
  ApiHelper apiHelper = ApiHelper();
  List<Map> m;
  bool loading = true;
  bool show = false;
  var data;

  @override
  void initState() {
    super.initState();
    getPrescriptionData();
  }

  getPrescriptionData() async {
    if (widget.previous == false) {
      var response = await http.get(
          "http://3.15.233.253:5000/doctorprecriptionlist?doctorid=${global.data.sId}");
      data = jsonDecode(response.body);
      for (var element in data["doctorlist"]) {
        if (element["userdata"].length > 0 && element["doctors"].length > 0)
          for (var element2 in element["doctors"]) {
            patient.add(Patient.fromJson(element, element2));
          }
      }
    } else {
      var response = await http.post(
          "http://3.15.233.253:5000/previoususerprecription",
          body: {"userid": widget.patient.id});
      data = jsonDecode(response.body);
      for (var element in data["precriptiondetails"]) {
        if (element["userdata"].length > 0 && element["doctors"].length > 0)
          for (var element2 in element["doctors"]) {
            patient.add(Patient.fromJson(element, element2));
          }
      }
      print(data);
    }

    print(patient);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text(
          'Prescription List',
          style: GoogleFonts.roboto(),
        ),
        backgroundColor: primary,
      ),
      body: SafeArea(
          child: loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                      children: patient.map((e) {
                    if (e.pdffile == null)
                      return Container();
                    else
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PdfOpener(
                                url: "http://3.15.233.253/" +
                                    e.pdffile.replaceAll("/var/www/html/", ""),
                              ),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: primary, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Name",
                                            style: GoogleFonts.roboto(
                                                color: primary)),
                                      ),
                                      Expanded(
                                        child: Text(e.name.toString(),
                                            style: GoogleFonts.roboto()),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Mobile Number",
                                            style: GoogleFonts.roboto(
                                                color: primary)),
                                      ),
                                      Expanded(
                                        child: Text(e.mobile.toString(),
                                            style: GoogleFonts.roboto()),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Date",
                                            style: GoogleFonts.roboto(
                                                color: primary)),
                                      ),
                                      Expanded(
                                        child: Text(e.dateOfJoining.toString(),
                                            style: GoogleFonts.roboto()),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Diagnosis",
                                            style: GoogleFonts.roboto(
                                                color: primary)),
                                      ),
                                      Expanded(
                                        child: Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: e.diagnosis
                                              .map((e) => Text(
                                                  e["diagnosis_name"],
                                                  style: GoogleFonts.roboto()))
                                              .toList(),
                                        )),
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
                )),
    );
  }
}
