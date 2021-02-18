import 'package:flutter/material.dart';

class HomeWellnessRequest extends StatefulWidget {
  @override
  _HomeWellnessRequestState createState() => _HomeWellnessRequestState();
}

class _HomeWellnessRequestState extends State<HomeWellnessRequest> {
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
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Category",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
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
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
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
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
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
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Mobile Number",
                        labelText: "Mobile Number"),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
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
