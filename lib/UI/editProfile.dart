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
  bool loading = true;
  List<DoctorsCheckUp> doctorcheckup = List();
  List<UserData> userData = List();
  bool show = false;
  var data;
  getPrescriptionData() async {
    var response =
        await http.get("http://3.15.233.253:5000/doctorprecriptionlist");
    data = jsonDecode(response.body);
    print(data);
    data["doctorlist"].forEach((element) {
      element["doctorscheckup"].forEach((ele) {
        doctorcheckup.add(DoctorsCheckUp.fromJson(ele));
      });
      element["userdata"].forEach((ele) {
        userData.add(UserData.fromJson(ele));
      });
    });
    print(doctorcheckup);
    print(userData);
    // print(userData[0].id);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    getPrescriptionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.green,
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                            global.data.picture,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.account_box_outlined),
                          ),
                          title: Text(global.data.name),
                          subtitle: Text(global.data.email),
                          trailing: Text(global.data.experience.toString() +
                              " Years Experience"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Mobile Number")),
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
                            Expanded(child: Text("Address")),
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
                            Expanded(child: Text("City")),
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
                            Expanded(child: Text("Clinic Name")),
                            Expanded(
                              child: Text(global.data.clinicname.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Date of Birth")),
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
                            Expanded(child: Text("Mode of Services")),
                            Expanded(
                              child:
                                  Text(global.data.modeofservices.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Qualification")),
                            Expanded(
                              child: Text(global.data.qualification.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Specialization")),
                            Expanded(
                              child:
                                  Text(global.data.specialization.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Registration Number")),
                            Expanded(
                              child:
                                  Text(global.data.registrationno.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            show = !show;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "Prescription List",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
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
                                              color: Colors.green, width: 3)),
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
                                                  child: Text("Mobile Number"),
                                                ),
                                                Expanded(
                                                  child: Text(userData[index]
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
                                                  child: Text(userData[index]
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
                              }).toList())
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
