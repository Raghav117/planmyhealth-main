import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_my_health/model/Diagnostics.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Diagnosis.dart';

class SelectTest extends StatefulWidget {
  SelectTest({Key key}) : super(key: key);

  @override
  _SelectTestState createState() => _SelectTestState();
}

class _SelectTestState extends State<SelectTest> {
  ApiHelper apiHelper = ApiHelper();

  Color mycolor = Colors.white;
  List<SelectTestList> selectTestList = [];
  var diagnosticslisStatus = List<bool>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, selectTestList);
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
                "   Select Test",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, selectTestList);
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
                FutureBuilder<List<Diagnosticslist>>(
                  future: apiHelper.getDiagnosticslist(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Diagnosticslist> data = snapshot.data;
                      return diagnosticslistView(data);
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
              Navigator.pop(context, selectTestList);
            },
            child: Container(
              height: 50,
              width: 125,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Save Test",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  ListView diagnosticslistView(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          diagnosticslisStatus.add(false);
          return diagnosticslisTtile(data, index);
        });
  }

  Card diagnosticslisTtile(dynamic diagnosticslist, int index) => Card(
        color: mycolor,
        child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ListTile(
              selected: diagnosticslisStatus[index],
              leading: const Icon(Icons.info),
              title: new Text(diagnosticslist[index].name),
              subtitle: new Text(diagnosticslist[index].bloodQuantityRequired),
              trailing: Checkbox(
                  checkColor: Colors.white, // color of tick Mark

                  value: diagnosticslisStatus[index],
                  onChanged: (bool val) {
                    //   diagnosticslisStatus[index] = !diagnosticslisStatus[index];
                  }),
              onTap: () {
                print(diagnosticslisStatus[index].toString());
                // setState(() {
                //   diagnosticslisStatus[index] = !diagnosticslisStatus[index];
                // });

                setState(() {
                  if (!diagnosticslisStatus[index]) {
                    setState(() {
                      print("change color");
                      //    mycolor = Colors.pink;
                      diagnosticslisStatus[index] =
                          !diagnosticslisStatus[index];

                      SelectTestList selectTes = new SelectTestList();
                      selectTes.id = diagnosticslist[index].sId.toString();
                      selectTes.name = diagnosticslist[index].name.toString();
                      selectTestList.add(selectTes);
                      setState(() {});
                      print(selectTestList.length);

                      print("change" + diagnosticslist.length.toString());
                      setState(() {});
                    });
                  } else {
                    setState(() {
                      //     mycolor = Colors.red;
                      diagnosticslisStatus[index] =
                          !diagnosticslisStatus[index];
                    });
                  }
                });
              } // what should I put here,
              )
        ]),
      );
}
