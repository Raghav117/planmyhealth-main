import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  TextEditingController subject = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Health Article"),
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
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          "Subject",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
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
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
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
                                  child: Dialog(
                                    child: Container(
                                      height: 300,
                                      child: Center(
                                          child: Text("Successfully Done")),
                                    ),
                                  ));
                            } else {
                              showDialog(
                                  context: context,
                                  child: Dialog(
                                    child: Container(
                                      height: 300,
                                      child: Center(
                                          child: Text(
                                              "All Fields are Compulsory")),
                                    ),
                                  ));
                            }
                          },
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Save"),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
  @override
  void initState() {
    getSpecialities();
    // TODO: implement initState
    super.initState();
  }
}
