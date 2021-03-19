import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   print("geting doctore list");
  //   getuserlist();
  // }

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
          content: new Text("Do you wish to make prescription for pationt ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Prescription()));
              },
            ),
          ],
        );
      },
    );
  }

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
    // print(data);
    // data["doctorlist"].forEach((element) {
    //   element["userdata"].forEach((ele) {
    //     doctorcheckup.add(DoctorsCheckUp.fromJson(ele));
    //   });
    //   element["userdata"].forEach((ele) {
    //     userData.add(UserData.fromJson(ele));
    //   });
    // });
    // print(doctorcheckup);
    // print(userData);
    // print(userData[0].id);
    loading = false;
    setState(() {});
  }

  List<Map> m;
  bool loading = true;
  bool show = false;
  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        centerTitle: true,
        title: Text(
          'Prescription List',
          style: GoogleFonts.dosis(),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SafeArea(
          child: loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                      children: patient.map((e) {
                    int index = patient.indexOf(e);
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
                                border: Border.all(
                                    color: Colors.greenAccent, width: 3)),
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
                                        child: Text(e.name.toString()),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text("Mobile Number"),
                                      ),
                                      Expanded(
                                        child: Text(e.mobile.toString()),
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
                                        child: Text(e.dateOfJoining.toString()),
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
                                        child: Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: e.diagnosis
                                              .map((e) =>
                                                  Text(e["diagnosis_name"]))
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

  // ListView _jobsListView(data) {
  //   print("---------------------");
  //   print("length of get users list" + data.length.toString());
  //   return ListView.builder(
  //       itemCount: data.length,
  //       itemBuilder: (context, index) {
  //         if (data[index].userdata.length > 0)
  //           return _tile(data[index].userdata[0]);
  //         return Container();
  //       });
  // }

  // ListTile _tile(dynamic user) => ListTile(
  //       tileColor: Colors.green.shade50,
  //       // onTap: () async => await launch(url("+91 " + user.mobile.toString())),
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) =>
  //                     PatientDetails(number: user.mobile.toString())));
  //       },
  //       leading: Container(
  //           width: 54,
  //           height: 54,
  //           decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               image: DecorationImage(
  //                   fit: BoxFit.fill,
  //                   image: NetworkImage(
  //                       "https://i1.wp.com/www.sardiniauniqueproperties.com/wp-content/uploads/2015/10/square-profile-pic-2.jpg")))),
  //       title: Row(
  //         children: [
  //           Text(
  //             user.name.toString(),
  //             style: TextStyle(
  //               fontSize: 20,
  //             ),
  //           ),
  //           SizedBox(width: 2),
  //         ],
  //       ),
  //       subtitle: Padding(
  //         padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
  //         child: Text(
  //           user.mobile.toString(),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //           softWrap: false,
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontFamily: "HelveticaNeueMedium",
  //               fontSize: 14),
  //         ),
  //       ),
  //       trailing: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             " [ " + user.gender.toString() + " ]",
  //             style: TextStyle(
  //               color: Colors.greenAccent,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 18,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Container(
  //               child: Text(user.age.toString() + " Years",
  //                   style: TextStyle(color: Colors.black))),
  //         ],
  //       ),
  //     );

  // String url(String phone) {
  //   print("Call url function");
  //   if (Platform.isAndroid) {
  //     // add the [https]
  //     setState(() {
  //       onCall = true;
  //     });
  //     return "https://wa.me/$phone/?text= "; // new line
  //   } else {
  //     // add the [https]
  //     return "https://api.whatsapp.com/send?phone=$phone= "; // new line
  //   }
  // }
}
