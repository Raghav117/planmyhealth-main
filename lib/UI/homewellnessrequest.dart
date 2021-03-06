import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plan_my_health/model/healthwellness.dart';
import '../global/global.dart';
import 'package:http/http.dart' as http;

class HomeWellnessRequest extends StatefulWidget {
  @override
  _HomeWellnessRequestState createState() => _HomeWellnessRequestState();
}

class _HomeWellnessRequestState extends State<HomeWellnessRequest> {
  List<Wellness> list = [];
  getWellness() async {
    var response =
        await http.post("http://3.15.233.253:5000/homewellnesslist", body: {
      "doctorid": data.sId,
    });
    print(response);
    var result = jsonDecode(response.body);
    print(result["homewellnesslist"].length);
    var element;
    for (element in result["homewellnesslist"]) {
      list.add(Wellness.fromJson(element));
    }
    loading = false;
    print(list);
    setState(() {});
  }

  TextEditingController client = TextEditingController();
  TextEditingController mobile = TextEditingController();
  List<String> _DoctorCategory = <String>[
    'Doctor',
    'Clinic',
    'Hospital',
    'Poly Clinic',
    'Nursing Home',
    'Nurse',
    'Physiotherapist',
    'AYUSH',
    'Psychologist',
    'Dietitian',
    'Caregiver',
    'Specialist',
  ];
  @override
  void initState() {
    super.initState();
    getWellness();
  }

  // bool loading = true;

  List<String> serviceMode = ["Call", "Chat", "Home Visit", "Video", "Clinic"];
  int serviceModeIndex = 0;

  int index = 0;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Wellness Request"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Category",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.15,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        value: index,
                        onChanged: (value) {
                          setState(() {
                            index = value;
                          });
                        },
                        items: _DoctorCategory.map((type) {
                          int i = _DoctorCategory.indexOf(type);
                          return DropdownMenuItem(
                            value: i,
                            child: Text(
                              type,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      "Service Mode",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.15,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                        ),
                        value: serviceModeIndex,
                        onChanged: (value) {
                          setState(() {
                            serviceModeIndex = value;
                          });
                        },
                        items: serviceMode.map((type) {
                          int i = serviceMode.indexOf(type);
                          return DropdownMenuItem(
                            value: i,
                            child: Text(
                              type,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      "Client Name",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: client,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Client Name",
                              labelText: "Client Name"),
                        ),
                      ),
                    ),
                    Text(
                      "Mobile Number",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: mobile,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Mobile Number",
                              labelText: "Mobile Number"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (client.text.length != 0 &&
                            mobile.text.length != 0) {
                          setState(() {
                            loading = true;
                          });
                          var resonse = await http.post(
                              "http://3.15.233.253:5000/homewellness",
                              body: {
                                "servicemode": serviceMode[serviceModeIndex],
                                "category": _DoctorCategory[index],
                                "clientname": client.text,
                                "mobilenumber": mobile.text,
                                "doctorid": data.sId
                              });
                          print(resonse.body);
                          setState(() {
                            loading = false;
                          });
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      height: 300,
                                      child: Center(
                                          child: Text("Successfully Done")),
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
                                      color: Colors.green, width: 3)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("Category"),
                                        ),
                                        Expanded(
                                          child: Text(
                                              list[index].category.toString()),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("Service Mode"),
                                        ),
                                        Expanded(
                                          child: Text(list[index]
                                              .servicemode
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
                                          child: Text("Client Name"),
                                        ),
                                        Expanded(
                                          child: Text(list[index]
                                              .clientname
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
                                          child: Text("Mobile Number"),
                                        ),
                                        Expanded(
                                          child: Text(list[index]
                                              .mobilenumber
                                              .toString()),
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
            ),
    );
  }
}
