import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/doctor.dart';
import '../global/global.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController aname = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController an = TextEditingController();
  TextEditingController code = TextEditingController();
  checkDoctorExists() async {
    mobileController.text = "8356928929";
    var response = await http.post("http://3.15.233.253:5000/checkdoctorexist",
        body: {
          "mobilenumber": mobileController.text
        }); //!  **************  To Do
    bool exists = jsonDecode(response.body)["status"];
    print(exists);
    if (exists == true) {
      data = Data.fromJson(jsonDecode(response.body)["data"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Account",
          style: GoogleFonts.dosis(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: loading == true
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Bank Account Name",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: GoogleFonts.dosis(),
                              controller: aname,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Bank Account Name",
                                  labelText: "Bank Account Name"),
                            ),
                          ),
                        ),
                        Text(
                          "Account Number",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: an,
                              style: GoogleFonts.dosis(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Account Number",
                                  labelText: "Account Number"),
                            ),
                          ),
                        ),
                        Text(
                          "IFSC Code",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          // height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: code,
                              style: GoogleFonts.dosis(),
                              // maxLines: 10,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "IFSC Code",
                                  labelText: "IFSC Code"),
                            ),
                          ),
                        ),
                        Text(
                          "UPI PIN",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: pin,
                              style: GoogleFonts.dosis(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Upi pin",
                                  labelText: "Upi pin"),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (aname.text.length != 0 &&
                                code.text.length != 0 &&
                                pin.text.length != 0 &&
                                an.text.length != 0) {
                              setState(() {
                                loading = true;
                              });
                              var resonse = await http.post(
                                  "http://3.15.233.253:5000/doctorbankdetailsupdate",
                                  body: {
                                    "accountname": aname.text,
                                    "ifsccode": code.text,
                                    "upipin": pin.text,
                                    "accountnumber": an.text,
                                    "mobilenumber": data.mobile.toString()
                                  });
                              checkDoctorExists();
                              Navigator.pop(context);

                              setState(() {
                                loading = false;
                              });
                              print(resonse.body);
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          height: 300,
                                          child: Center(
                                              child: Text("Successfully Done",
                                                  style: GoogleFonts.dosis())),
                                        ),
                                      ));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          height: 300,
                                          child: Center(
                                              child: Text(
                                                  "All Fields are Compulsory",
                                                  style: GoogleFonts.dosis())),
                                        ),
                                      ));
                            }
                          },
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Save",
                                style: GoogleFonts.dosis(color: Colors.white)),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        data.accountname.toString().toLowerCase() == null
                            ? Container()
                            : Container(
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
                                            child: Text(
                                              "Account Name",
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.accountname.toString(),
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Account Number",
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.accountnumber.toString(),
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "IFSC Code",
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.ifsccode.toString(),
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "UPI Pin",
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.upipin.toString(),
                                              style: GoogleFonts.dosis(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )),
    );
  }

  String special = "";
  ApiHelper apiHelper = ApiHelper();

  List<Map<String, String>> spe = [];
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
      loading = false;
      setState(() {});
    });
  }

  bool loading = true;
  @override
  void initState() {
    getSpecialities();
    // TODO: implement initState
    super.initState();
  }
}
