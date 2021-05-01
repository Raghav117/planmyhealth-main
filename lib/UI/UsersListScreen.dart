import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/PatientList.dart';
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
  List<Doctorlist> days = [];

  List<Patient> patient = [];

  @override
  void initState() {
    super.initState();
    getPatient();
  }

  //!--------------------------   For geting orders Id and Patients  --------------------------------------

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

  //!--------------------------   Main Widget ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
}
