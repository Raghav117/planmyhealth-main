import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/UI/findings.dart';
import 'dart:convert';
import '../model/findings.dart';

class HomeVisitForm extends StatefulWidget {
  @override
  _HomeVisitFormState createState() => _HomeVisitFormState();
}

class _HomeVisitFormState extends State<HomeVisitForm> {
  @override
  void initState() {
    super.initState();
    getFindings();
  }

  List<Finding> findings = [];

  void getFindings() async {
    var response = await http.get("http://3.15.233.253:5000/findings");
    print(response.body);
    var data = jsonDecode(response.body);
    data["findinglist"].forEach((element) {
      findings.add(Finding.fromJson(element));
    });
  }

  DateTime intime = DateTime.now();
  DateTime outtime = DateTime.now();
  List issue = [];
  List treatment = [];
  List equipments = [];
  List recomandation = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Visit"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "In Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                  onTap: () async {
                    var time = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: intime,
                      lastDate: DateTime(2025),
                    );
                    if (time != null) intime = time;
                    setState(() {});
                  },
                  child: Text(intime.toString())),
              SizedBox(
                height: 30,
              ),
              Text(
                "Out Time",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                  onTap: () async {
                    var time = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate: intime,
                      lastDate: DateTime(2025),
                    );
                    if (time != null) outtime = time;
                    setState(() {});
                  },
                  child: Text(outtime.toString())),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  var response =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Findings(
                        findings: findings,
                      );
                    },
                  ));
                  if (response != null) issue = response;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(
                      "Issue Offered",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      "+",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              issue.indexOf(true) == -1
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Not Selected"),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: issue.length,
                        itemBuilder: (context, index) {
                          return issue[index] == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(findings[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                )
                              : Container();
                        },
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  var response =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Findings(
                        findings: findings,
                      );
                    },
                  ));
                  if (response != null) treatment = response;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(
                      "Treatement Offered",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      "+",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              treatment.indexOf(true) == -1
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Not Selected"),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: treatment.length,
                        itemBuilder: (context, index) {
                          return treatment[index] == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(findings[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                )
                              : Container();
                        },
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  var response =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Findings(
                        findings: findings,
                      );
                    },
                  ));
                  if (response != null) equipments = response;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(
                      "Equipement & Consumables used",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      "+",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              equipments.indexOf(true) == -1
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Not Selected"),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: equipments.length,
                        itemBuilder: (context, index) {
                          return equipments[index] == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(findings[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                )
                              : Container();
                        },
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  var response =
                      await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Findings(
                        findings: findings,
                      );
                    },
                  ));
                  if (response != null) recomandation = response;
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Further recommendation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "+",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              recomandation.indexOf(true) == -1
                  ? Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Not Selected"),
                      ),
                    )
                  : Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: recomandation.length,
                        itemBuilder: (context, index) {
                          return recomandation[index] == true
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(findings[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      )),
                                )
                              : Container();
                        },
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Charges",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Charges"),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Remarks",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                // keyboardType: TextInputType.number,

                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Remarks"),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.blue,
                  child: Text("Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
