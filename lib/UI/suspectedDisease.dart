import 'package:flutter/material.dart';
import 'package:plan_my_health/model/suspectedDisease.dart';

class SuspectedDiseases extends StatefulWidget {
  final List<SuspectedDisease> suspectedDisease;

  const SuspectedDiseases({Key key, this.suspectedDisease}) : super(key: key);

  @override
  _SuspectedDiseasesState createState() =>
      _SuspectedDiseasesState(suspectedDisease);
}

class _SuspectedDiseasesState extends State<SuspectedDiseases> {
  final List<SuspectedDisease> suspectedDisease;
  List<bool> colors = [];

  _SuspectedDiseasesState(this.suspectedDisease);
  @override
  void initState() {
    super.initState();
    suspectedDisease.forEach((element) {
      colors.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SuspectedDiseases"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: suspectedDisease.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                setState(() {
                  colors[index] = !colors[index];
                });
              },
              tileColor:
                  colors[index] == false ? Colors.transparent : Colors.yellow,
              title: Text(
                suspectedDisease[index].diagnosisName,
                style: TextStyle(fontSize: 20),
              ),
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.pop(context, colors);
            },
            child: Container(
              child: Text("Done"),
            ),
          )
        ],
      ),
    );
  }
}
