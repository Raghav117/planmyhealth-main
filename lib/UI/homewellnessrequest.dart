import 'package:flutter/material.dart';
import '../global/global.dart';
import 'package:http/http.dart' as http;

class HomeWellnessRequest extends StatefulWidget {
  @override
  _HomeWellnessRequestState createState() => _HomeWellnessRequestState();
}

class _HomeWellnessRequestState extends State<HomeWellnessRequest> {
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

  List<String> serviceMode = ["Call", "Chat", "Home Visit", "Video", "Clinic"];
  int serviceModeIndex = 0;

  int index = 0;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Wellness Request"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: loading == true
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                      width: MediaQuery.of(context).size.width / 1.2,
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
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Service Mode",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
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
                    SizedBox(
                      height: 50,
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
                    SizedBox(
                      height: 50,
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
                              child: Dialog(
                                child: Container(
                                  height: 300,
                                  child:
                                      Center(child: Text("Successfully Done")),
                                ),
                              ));
                        } else {
                          showDialog(
                              context: context,
                              child: Dialog(
                                child: Container(
                                  height: 300,
                                  child: Center(
                                      child: Text("All Fields are Compulsory")),
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
      ),
    );
  }
}
