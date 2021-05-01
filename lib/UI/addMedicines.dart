import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';

// ignore: must_be_immutable
class AddMedicines extends StatefulWidget {
  AddMedicines({this.selectMedicineList}) : super();
  List<SelectMedicineList> selectMedicineList = [];
  final String title = "Select Medicines";

  @override
  _AddMedicinesState createState() => _AddMedicinesState();
}

class _AddMedicinesState extends State<AddMedicines> {
  ApiHelper apiHelper = ApiHelper();

  static List<Medicinelist> users = <Medicinelist>[];
  final TextEditingController serchController = TextEditingController();
  List<SelectMedicineList> selectMedicineList = [];
  String timeSelected, quntitySelected, withSelected, daysselected;

  String medname, medid;
  bool loading = true, showContainer = false;

  void getUsers() async {
    apiHelper.getMedicinelist().then((value) {
      setState(() {
        users = value;
        selectMedicineList = widget.selectMedicineList;
      });
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  Widget medCard(Medicinelist medicinelist) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              medicinelist.drugName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              medicinelist.composition,
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, selectMedicineList);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    " Add Medicines",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    controller: serchController,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0)),
                      labelText: "Search Medicines",
                      hintText: "Search Medicines",
                    )),
                suggestionsCallback: (pattern) async {
                  return users;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text(suggestion.drugName),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  print("printing " + suggestion.drugName);
                  setState(() {
                    medid = suggestion.sId;
                    serchController.text = suggestion.drugName;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        labelText: "Taken Time",
                        hintText: "Taken Time",
                      ),
                      elevation: 2,
                      icon: Icon(Icons.arrow_drop_down),
                      value: timeSelected,
                      onChanged: (value) {
                        setState(() {});
                        timeSelected = value;
                      },
                      items: <String>[
                        'One time in a day',
                        'Two times in a day',
                        'Three times in a day',
                        'Four times in a day'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        labelText: "Taken Quantity ",
                        hintText: "Taken Quantity",
                      ),
                      elevation: 2,
                      icon: Icon(Icons.arrow_drop_down),
                      value: quntitySelected,
                      onChanged: (value) {
                        setState(() {});
                        quntitySelected = value;
                      },
                      items: <String>['Half', 'One', 'Two']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Taken Quantity is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        labelText: "Taken With ",
                        hintText: "Taken With",
                      ),
                      elevation: 2,
                      icon: Icon(Icons.arrow_drop_down),
                      value: withSelected,
                      onChanged: (value) {
                        setState(() {});
                        withSelected = value;
                      },
                      items: <String>['Water', 'Millk']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Taken With is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        labelText: "For how many days",
                        hintText: "For how many days",
                      ),
                      elevation: 2,
                      icon: Icon(Icons.arrow_drop_down),
                      value: daysselected,
                      onChanged: (value) {
                        daysselected = value;
                        setState(() {});
                      },
                      items: <String>[
                        '1 day',
                        '2 days',
                        '3 days',
                        '4 days',
                        '5 days',
                        '6 days',
                        '1 week',
                        '15 days',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Taken With is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              showContainer ? container() : SizedBox(),
              SizedBox(
                height: 30,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showContainer = true;
                      });

                      if (showContainer == true) {
                        AddMedicines(
                          selectMedicineList: selectMedicineList,
                        );
                      } else {}
                      SelectMedicineList selectMedicine =
                          new SelectMedicineList();

                      selectMedicine.id = medid.toString();

                      selectMedicine.name = serchController.text;
                      selectMedicine.time = timeSelected.toString();
                      selectMedicine.qut = quntitySelected.toString();
                      selectMedicine.withtake = withSelected.toString();
                      selectMedicine.days = daysselected.toString();
                      selectMedicineList.add(selectMedicine);
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Add more Medicine",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: selectMedicineList.length > 0
                        ? () {
                            Navigator.pop(context, selectMedicineList);
                          }
                        : () {},
                    child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        alignment: Alignment.center,
                        child: Center(
                            child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget container() {
    return Card(
        elevation: 3.0,
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: selectMedicineList.length,
              itemBuilder: (context, index) {
                print(selectMedicineList.toString());
                return Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                selectMedicineList[index].name.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete, size: 18),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 50,
                            child: Text(
                              selectMedicineList[index].time.toString() +
                                  "," +
                                  selectMedicineList[index].qut.toString() +
                                  " tablet with " +
                                  selectMedicineList[index]
                                      .withtake
                                      .toString() +
                                  " for " +
                                  selectMedicineList[index].days.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ]));
              }),
        ));
  }
}
