import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:plan_my_health/UI/equipments.dart';
import 'package:plan_my_health/UI/findings.dart';
import 'package:plan_my_health/UI/issue.dart';
import 'package:plan_my_health/UI/recomandation.dart';
import 'package:plan_my_health/UI/treatments.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:plan_my_health/model/equipments.dart';
import 'dart:convert';
import '../model/findings.dart';
import '../model/homevisit.dart';

class HomeVisitForm extends StatefulWidget {
  @override
  _HomeVisitFormState createState() => _HomeVisitFormState();
}

class _HomeVisitFormState extends State<HomeVisitForm> {
  TextEditingController charges = TextEditingController();
  TextEditingController remarks = TextEditingController();

  @override
  void initState() {
    super.initState();
    gethomevisit();
    getFindings();
    getEquipments();
    getIssue();
    getTreat();
    getRecommandation();
  }

  List<HomeVisit> homeVisit = [];

  gethomevisit() async {
    var response = await http.post("http://3.15.233.253:5000/gethomevisit",
        body: {"doctor_id": data.sId});
    print(response.body);

    var data1 = jsonDecode(response.body);
    data1["data"].forEach((element) {
      homeVisit.add(HomeVisit.fromJson(element));
    });
    print(homeVisit);
  }

  bool loading = true;
  List<Finding> findings = [];

  void getFindings() async {
    var response = await http.get("http://3.15.233.253:5000/findings");
    // print(response.body);
    var data = jsonDecode(response.body);
    data["findinglist"].forEach((element) {
      findings.add(Finding.fromJson(element));
    });
  }

  getEquipments() async {
    var response = await http.get("http://3.15.233.253:5000/equipments");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["equipmentslist"]) {
      equip.add(Equip.fromJson(data));
    }
  }

  getRecommandation() async {
    var response =
        await http.get("http://3.15.233.253:5000/getfurtherrecommendations");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["furtherrecommendationslist"]) {
      recom.add(Recomandation.fromJson(data));
    }
    setState(() {
      loading = false;
    });
  }

  getIssue() async {
    var response = await http.get("http://3.15.233.253:5000/healthissues");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["healthissueslist"]) {
      issues.add(Issue.fromJson(data));
    }
  }

  getTreat() async {
    var response = await http.get("http://3.15.233.253:5000/procedures");
    // print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["procedureslist"]) {
      treat.add(Treatment.fromJson(data));
    }
  }

  List<Equip> equip = [];
  List<Issue> issues = [];
  List<Treatment> treat = [];
  List<Recomandation> recom = [];

  DateTime intime = DateTime.now();
  DateTime outtime = DateTime.now();
  List issue = [];
  List treatment = [];
  List equipments = [];
  List recomandation = [];
  List<Asset> multiimages = List<Asset>();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 50,
        enableCamera: true,
        selectedAssets: multiimages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      multiimages = resultList;
    });
  }

  Widget buildGridView() {
    return multiimages.length == 0
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              elevation: 3.0,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(multiimages.length, (index) {
                  Asset asset = multiimages[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                }),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Visit"),
        centerTitle: true,
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "In Time",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            return Iss();
                          },
                        ));
                        if (response != null) issue = response;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            "Issue Offered",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "+",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        child: Text(issues[index].description,
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
                            return Treatments();
                          },
                        ));
                        if (response != null) treatment = response;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            "Treatement Offered",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "+",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        child: Text(treat[index].description,
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
                            return Equipments();
                          },
                        ));
                        if (response != null) equipments = response;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Text(
                            "Equipement & Consumables used",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            "+",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        child: Text(equip[index].name,
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
                            return Recomandations();
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "+",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
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
                                        child: Text(recom[index].name,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: charges,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Charges"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Remarks",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      // keyboardType: TextInputType.number,
                      controller: remarks,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Remarks"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: FlatButton(
                        onPressed: () => loadAssets(),
                        child: Text(
                          "Add Case Details ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    buildGridView(),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () async {
                          if (charges.text.length != 0 &&
                              remarks.text.length != 0 &&
                              recomandation.indexOf(true) != -1 &&
                              equipments.indexOf(true) != -1 &&
                              treatment.indexOf(true) != -1 &&
                              issue.indexOf(true) != -1) {
                            setState(() {
                              loading = true;
                            });
                            List furtherrecommendation = [],
                                furthertreatement = [],
                                furtherissues = [],
                                furtherequipments = [];
                            int i = -1;
                            recomandation.forEach((element) {
                              ++i;
                              if (element == true) {
                                furtherrecommendation.add(jsonEncode(recom[i]));
                              }
                            });
                            i = -1;
                            print(furtherrecommendation);
                            treatment.forEach((element) {
                              ++i;
                              if (element == true) {
                                furthertreatement.add(jsonEncode(treat[i]));
                              }
                            });
                            i = -1;
                            issue.forEach((element) {
                              ++i;
                              if (element == true) {
                                furtherissues.add(jsonEncode(issues[i]));
                              }
                            });

                            i = -1;
                            equipments.forEach((element) {
                              ++i;
                              if (element == true) {
                                furtherequipments.add(jsonEncode(equip[i]));
                              }
                            });
                            var response = await http.post(
                                "http://3.15.233.253:5000/savehomevisit",
                                body: {
                                  "furtherrecommendation":
                                      furtherrecommendation.toString(),
                                  "treatment": furthertreatement.toString(),
                                  "issues": furtherissues.toString(),
                                  "equipments": furtherequipments.toString(),
                                  "intime": intime.toString(),
                                  "outtime": outtime.toString(),
                                  "date": DateTime.now().toString(),
                                  "remark": remarks.text.toString(),
                                  "charges": charges.text.toString(),
                                  "doctorid": data.sId.toString()
                                });
                            setState(() {
                              print(response.body);
                              loading = false;
                            });
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        height: 300,
                                        width: 300,
                                        child: Center(
                                          child: Text("Successfully Saved"),
                                        ),
                                      ),
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Container(
                                        height: 300,
                                        width: 300,
                                        child: Center(
                                          child:
                                              Text("All fields are compulsory"),
                                        ),
                                      ),
                                    ));
                          }
                          setState(() {
                            loading = false;
                          });
                        },
                        color: Colors.blue,
                        child: Text("Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                        itemCount: homeVisit.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.5,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "In Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(homeVisit[index].intime)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Out Time",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(homeVisit[index].outtime)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Issues Offered",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            homeVisit[index].issues.length,
                                        itemBuilder: (context, index1) {
                                          return Text(
                                            homeVisit[index]
                                                .issues[index1]
                                                .description,
                                            textAlign: TextAlign.center,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Treatments",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            homeVisit[index].treatment.length,
                                        itemBuilder: (context, index1) {
                                          return Text(
                                            homeVisit[index]
                                                .treatment[index1]
                                                .description
                                                .toString(),
                                            textAlign: TextAlign.center,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Equipement & Consumables used",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            homeVisit[index].equipments.length,
                                        itemBuilder: (context, index1) {
                                          return Text(
                                            homeVisit[index]
                                                .equipments[index1]
                                                .name,
                                            textAlign: TextAlign.center,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Further Recomandations",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: homeVisit[index]
                                            .furtherrecommendation
                                            .length,
                                        itemBuilder: (context, index1) {
                                          return Text(
                                            homeVisit[index]
                                                .furtherrecommendation[index1]
                                                .name,
                                            textAlign: TextAlign.center,
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Charges",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(homeVisit[index].charges)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Remarks",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(homeVisit[index].remark)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
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
