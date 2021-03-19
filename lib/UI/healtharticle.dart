import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/healtharticlelist.dart';
import '../global/global.dart';

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();
  List<Health> list = [];
  getHealth() async {
    var response = await http.post("http://3.15.233.253:5000/healtharticlelist",
        body: {"doctorid": data.sId});
    print(response);
    var result = jsonDecode(response.body);
    print(result["healtharticlelist"].length);
    var element;
    for (element in result["healtharticlelist"]) {
      list.add(Health.fromJson(element));
    }
    print(list);
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    getHealth();
    getSpecialities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Health Article", style: GoogleFonts.dosis()),
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
                          "Speciality",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.15,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0)),
                            ),
                            value:
                                special.length == 0 ? spe[0]["name"] : special,
                            onChanged: (value) {
                              setState(() {
                                special = value;
                              });
                            },
                            items: spe.map((type) {
                              return DropdownMenuItem(
                                value: type['name'],
                                child: Text(
                                  type['name'],
                                  style: GoogleFonts.dosis(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          "Subject",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: GoogleFonts.dosis(),
                              controller: subject,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Subject",
                                  labelText: "Subject"),
                            ),
                          ),
                        ),
                        Text(
                          "Description",
                          style: GoogleFonts.dosis(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: GoogleFonts.dosis(),
                              controller: description,
                              maxLines: 10,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Description",
                                  labelText: "Description"),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (subject.text.length != 0 &&
                                description.text.length != 0) {
                              setState(() {
                                loading = true;
                              });
                              if (special.length == 0) {
                                special = spe[0]["name"];
                              }
                              var resonse = await http.post(
                                  "http://3.15.233.253:5000/healtharticle",
                                  body: {
                                    "speciality": special,
                                    "subject": subject.text,
                                    "description": description.text,
                                    "doctorid": data.sId
                                  });
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
                                              child: Text(
                                            "Successfully Done",
                                            style: GoogleFonts.dosis(),
                                          )),
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
                                            style: GoogleFonts.dosis(),
                                          )),
                                        ),
                                      ));
                            }
                          },
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Save",
                              style: GoogleFonts.dosis(color: Colors.white),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 1.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                              child: Text(
                                                "Speciality",
                                                style: GoogleFonts.dosis(),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                list[index]
                                                    .speciality
                                                    .toString(),
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
                                                "Subject",
                                                style: GoogleFonts.dosis(),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                list[index].subject.toString(),
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
                                                "Description",
                                                style: GoogleFonts.dosis(),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                list[index]
                                                    .description
                                                    .toString(),
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
                              );
                              // return ListTile(
                              //   title: Text(list[index].speciality.toString()),
                              //   subtitle: Text(list[index].subject.toString() +
                              //       "\n" +
                              //       list[index].description),
                              //   isThreeLine: true,
                              // );
                            },
                          ),
                        )
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
}
