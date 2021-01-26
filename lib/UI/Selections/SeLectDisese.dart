import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Diagnosis.dart';

class SelectDisese extends StatefulWidget {
  SelectDisese({Key key}) : super(key: key);

  @override
  _SelectDiseseState createState() => _SelectDiseseState();
}

class _SelectDiseseState extends State<SelectDisese> {
  ApiHelper apiHelper = ApiHelper();
  List<SelectedDisease> selectedDiseaseList = [];
  Color mycolor = Colors.white;

  var diagnosislistStatus = List<bool>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, selectedDiseaseList);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(children: [
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "   Select Disease",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, selectedDiseaseList);
                },
                child: Text("close    "),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
                child: Column(
              children: [
                FutureBuilder<List<Diagnosislist>>(
                  future: apiHelper.getDiagnosislist(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Diagnosislist> data = snapshot.data;
                      return diagnosislistView(data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            )),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, selectedDiseaseList);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Save Diagnosis",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  ListView diagnosislistView(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          diagnosislistStatus.add(false);
          return diagnosislistTtile(data, index);
        });
  }

  Card diagnosislistTtile(dynamic diagnosislist, int index) => Card(
        color: mycolor,
        child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ListTile(
              selected: diagnosislistStatus[index],
              leading: const Icon(Icons.info),
              title: new Text(diagnosislist[index].diagnosisName),
              subtitle: new Text(diagnosislistStatus[index].toString()),
              trailing: Checkbox(
                  checkColor: Colors.white, // color of tick Mark

                  value: diagnosislistStatus[index],
                  onChanged: (bool val) {
                    //   diagnosislistStatus[index] = !diagnosislistStatus[index];
                  }),
              onTap: () {
                print(diagnosislistStatus[index].toString());
                // setState(() {
                //   diagnosislistStatus[index] = !diagnosislistStatus[index];
                // });

                setState(() {
                  if (!diagnosislistStatus[index]) {
                    setState(() {
                      print("change color");
                      //  mycolor = Colors.pink;
                      diagnosislistStatus[index] = !diagnosislistStatus[index];

                      SelectedDisease selectedDisease = new SelectedDisease();
                      selectedDisease.id = diagnosislist[index].sId.toString();
                      selectedDisease.name =
                          diagnosislist[index].diagnosisName.toString();
                      selectedDiseaseList.add(selectedDisease);

                      print("change" + selectedDiseaseList.length.toString());
                      setState(() {});
                    });
                  } else {
                    setState(() {
                      //  mycolor = Colors.red;
                      diagnosislistStatus[index] = !diagnosislistStatus[index];
                    });
                  }
                });
              } // what should I put here,
              )
        ]),
      );
}
