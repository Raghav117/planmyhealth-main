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
              title: Text(
                suspectedDisease[index].diagnosisName,
                style: TextStyle(
                  fontSize: 18,
                  color: colors[index] == false ? Colors.black : Colors.blue,
                ),
              ),
              subtitle: Text(suspectedDisease[index].symptoms),
              leading: colors[index] == false
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(
                      Icons.check_box,
                      color: Colors.blue,
                    ),
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.pop(context, colors);
            },
            child: Container(
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Center(
                  child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}
