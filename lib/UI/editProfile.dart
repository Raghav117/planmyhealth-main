import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/pdfOpener.dart';
import 'package:plan_my_health/global/design.dart';
import '../model/doctorsCheckup.dart';
import '../global/global.dart' as global;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<Map> m;
  bool loading = false;
  List<DoctorsCheckUp> doctorcheckup = [];
  List<UserData> userData = [];
  bool show = false;
  var data;
  List<String> documentsfiles = [];

  @override
  void initState() {
    super.initState();
    getDocumentsFiles();
  }

  //! --------------------   Get Documents Files ----------------------------------

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
        centerTitle: true,
        title: Text('Profile', style: GoogleFonts.roboto()),
        backgroundColor: primary,
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: primary, width: 3)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network("http://3.15.233.253/" +
                                    global.data.picture),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(global.data.name,
                                style: GoogleFonts.roboto(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(global.data.email,
                                style: GoogleFonts.roboto()),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                global.data.experience.toString() +
                                    " Years Experience",
                                style: GoogleFonts.roboto()),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Mobile Number",
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.mobile.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.dob.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.gender.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          color: primary,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.specialization.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                            color: primary,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Text(global.data.practice.toString(),
                                      style: GoogleFonts.roboto()),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Qualification",
                                        style: GoogleFonts.roboto(
                                            color: primary,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Text(
                                      global.data.qualification.toString(),
                                      style: GoogleFonts.roboto()),
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
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ))),
                                  Expanded(
                                    child: Text(
                                        global.data.modeofservices.toString(),
                                        style: GoogleFonts.roboto()),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Languages",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ))),
                                  Expanded(
                                    child: Text(global.data.language.toString(),
                                        style: GoogleFonts.roboto()),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Accrediation",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ))),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: global.data.accrediation
                                              .map(
                                                (e) => Text(
                                                    e["accrediation_name"] +
                                                        ",",
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.roboto()),
                                              )
                                              .toList()))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Specialities",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ))),
                                  Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: global.data.speciality
                                              .map(
                                                (e) => Text(e["name"] + ",",
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.roboto()),
                                              )
                                              .toList()))
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.clinicname.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.cityId.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(global.data.address.toString(),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                    child: Text(
                                        global.data.workingfrom
                                            .toString()
                                            .replaceAll(
                                                RegExp(r'TimeOfDay'), ""),
                                        style: GoogleFonts.roboto()))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Working To",
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.workingto
                                          .toString()
                                          .replaceAll(RegExp(r'TimeOfDay'), ""),
                                      style: GoogleFonts.roboto()),
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
                                        style: GoogleFonts.roboto(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Expanded(
                                  child: Text(
                                      global.data.registrationno.toString(),
                                      style: GoogleFonts.roboto()),
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
                                      child: Text("Facilites",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ))),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: global.data.facility
                                              .map(
                                                (e) => Text(e["facility"] + ",",
                                                    textAlign: TextAlign.left,
                                                    style:
                                                        GoogleFonts.roboto()),
                                              )
                                              .toList()))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
                                                  color: primary, width: 3)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Name",
                                                          style: GoogleFonts
                                                              .roboto()),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index].name,
                                                          style: GoogleFonts
                                                              .roboto()),
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
                                                          "Mobile Number",
                                                          style: GoogleFonts
                                                              .roboto()),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index]
                                                              .mobile
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto()),
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
                                                          style: GoogleFonts
                                                              .roboto()),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          userData[index]
                                                              .dateOfJoining
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto()),
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
                                                          style: GoogleFonts
                                                              .roboto()),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          doctorcheckup[index]
                                                              .diagnosis
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto()),
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
                                style: GoogleFonts.roboto(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                )),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  "http://3.15.233.253/" +
                                      global.data.signature.toString(),
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.account_box_outlined),
                                ),
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
                        style: GoogleFonts.roboto(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: documentsfiles.map((e) {
                            if (e == "") return Container();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: primary),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      "http://3.15.233.253/" + e,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.account_box_outlined),
                                    ),
                                  )),
                            );
                          }).toList(),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
