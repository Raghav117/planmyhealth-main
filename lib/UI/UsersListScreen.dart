import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/PatientList.dart';
import 'package:url_launcher/url_launcher.dart';
import '../global/global.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with WidgetsBindingObserver {
  List<Doctorlist> orderList;
  bool onCall = false;
  ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("geting doctore list");
    // getuserlist();
    getPatient();
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
          title: new Text(
            "Call Conformation",
            style: GoogleFonts.dosis(),
          ),
          content: new Text(
            "Do you wish to make prescription for pationt ?",
            style: GoogleFonts.dosis(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: GoogleFonts.dosis(),
              ),
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

  // Future<List<Doctorlist> getuserlist() {
  //   apiHelper.getOderList().then((userlist) {
  //     // print(userlist.doctorlist[0].userdata[0].name);
  //     for (Doctorlist doctorlist in userlist.doctorlist) {
  //       List<Doctorlist> orderList = [];
  //       orderList.add(doctorlist);
  //       // for (Userdata userdata in doctorlist.userdata) {
  //       //   print(userdata.name);
  //       // }
  //     }
  //   });
  //   return orderList;
  // }
  List<Doctorlist> days = [];

  List<Patient> patient = [];

  getPatient() async {
    var response =
        await http.get("http://3.15.233.253:5000/orders?doctorid=${data.sId}");
    var result = jsonDecode(response.body);

    for (var element in result["doctorlist"]) {
      if (element["userdata"].length > 0)
        for (var element2 in element["doctors"]) {
          patient.add(Patient.fromJson(element, element2));
        }
    }
    print(patient);
    setState(() {});
  }

  // Future<List<Doctorlist>> getuserlist() async {
  //   await apiHelper.getOderList().then((userlist) {
  //     days.clear();
  //     userlist.doctorlist.forEach((element) {
  //       days.add(element);
  //     });
  //     // for (int i = 0; i <= userlist.doctorlist.length; i++) {
  //     //   print("adding");
  //     //   days.add(userlist.doctorlist[i]);
  //     // }
  //   });
  //   print("--------------------------------------- check-------------");
  //   print(days);
  //   return days;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        title: Text(
          'Create Presciption',
          style: GoogleFonts.dosis(),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
            child: ListView.builder(
          itemCount: patient.length,
          itemBuilder: (context, index) {
            return ListTile(
              tileColor: Colors.green.shade50,
              // onTap: () async => await launch(url("+91 " + user.mobile.toString())),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientDetails(
                              number: patient[index].mobile.toString(),
                              sId: patient[index].sId.toString(),
                              city: patient[index].cityId.toString(),
                              patient: patient[index],
                            )));
              },
              leading: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  "http://3.15.233.253/" + patient[index].picture,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.account_box_outlined),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    patient[index].name.toString(),
                    style: GoogleFonts.dosis(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 2),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  patient[index].mobile.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: GoogleFonts.dosis(color: Colors.black, fontSize: 14),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    " [ " + patient[index].gender.toString() + " ]",
                    style: GoogleFonts.dosis(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                      child: Text(patient[index].age.toString() + " Years",
                          style: GoogleFonts.dosis(color: Colors.black))),
                ],
              ),
            );
          },
        )),
      ),
    );
  }

  // ListView _jobsListView(List<Doctorlist> data) {
  //   return ListView.builder(
  //       itemCount: data.length,
  //       itemBuilder: (context, index) {
  //         if (data[index].userdata.length > 0)
  //           return _tile(data[index].userdata[0], data[index].sId, index);
  //         return Container();
  //       });
  // }

  // ListTile _tile(Userdata user, String sId, int index) => ListTile(
  //       tileColor: Colors.green.shade50,
  //       // onTap: () async => await launch(url("+91 " + user.mobile.toString())),
  //       onTap: () {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => PatientDetails(
  //                       number: user.mobile.toString(),
  //                       sId: sId.toString(),
  //                       city: user.cityId.toString(),
  //                       patient: patient[index],
  //                     )));
  //       },
  //       leading: Container(
  //         width: 54,
  //         height: 54,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //         ),
  //         child: Image.asset("assets/logo.jpeg"),
  //       ),
  //       title: Row(
  //         children: [
  //           Text(
  //             user.name.toString(),
  //             style: GoogleFonts.dosis(
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
  //           style: GoogleFonts.dosis(
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
  //             style: GoogleFonts.dosis(
  //               color: Colors.greenAccent,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 18,
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Container(
  //               child: Text(user.age.toString() + " Years",
  //                   style: GoogleFonts.dosis(color: Colors.black))),
  //         ],
  //       ),
  //     );

  String url(String phone) {
    print("Call url function");
    if (Platform.isAndroid) {
      // add the [https]
      setState(() {
        onCall = true;
      });
      return "https://wa.me/$phone/?text= "; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone= "; // new line
    }
  }
}
