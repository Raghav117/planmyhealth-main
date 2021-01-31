import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Medicines.dart';
import 'package:plan_my_health/model/SelectMedicineList.dart';

class Abc extends StatefulWidget {
  Abc({this.selectMedicineList}) : super();
  List<SelectMedicineList> selectMedicineList = [];
  final String title = "Select Medicines";

  @override
  _AbcState createState() => _AbcState();
}

class _AbcState extends State<Abc> {
  ApiHelper apiHelper = ApiHelper();

  static List<Medicinelist> users = new List<Medicinelist>();
  final TextEditingController serchController = TextEditingController();
  List<SelectMedicineList> selectMedicineList = [];
  String timeSelected, quntitySelected, withSelected;

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " Add Medicines",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context, selectMedicineList);
                    },
                    child: Text("close  "),
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
//                      subtitle: Text('\$${suggestion['id']}'),
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
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    decoration: BoxDecoration(
                        // color: AppColors.EDITTEXT_BG_COLOR,
                        // border: Border.all(
                        //     color: AppColors.EDITTEXT_BORDER_COLOR,
                        //     width: 1.0),
                        borderRadius: BorderRadius.circular(4)),
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
                    width: MediaQuery.of(context).size.width / 2 - 20,
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
              Container(
                height: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
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
                      child: Text(value, style: TextStyle(color: Colors.black)),
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
              showContainer ? container() : SizedBox(),
              SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "For how many days",
                    border: OutlineInputBorder()),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showContainer = true;
                  });

                  if (showContainer == true) {
                    Abc(
                      selectMedicineList: selectMedicineList,
                    );
                  } else {}
                  SelectMedicineList selectMedicine = new SelectMedicineList();

                  selectMedicine.id = medid.toString();

                  selectMedicine.name = serchController.text;
                  selectMedicine.time = timeSelected.toString();
                  selectMedicine.qut = quntitySelected.toString();
                  selectMedicine.withtake = withSelected.toString();
                  selectMedicineList.add(selectMedicine);

                  // Navigator.pop(context, selectMedicineList)

                  print(" ---------------------- ");
                  print("medicines Name: " + serchController.text);
                  print("medicines Name: " + medid);
                  print("time: " + timeSelected.toString());
                  print("quant: " + quntitySelected.toString());
                  print("with: " + withSelected.toString());
//--------old
                  // selectMedicineList.add({
                  //   "id": medid.toString(),
                  //   "name": medicineSerchController.text.toString(),
                  //   "time": timeSelected.toString(),
                  //   "qut": quntitySelected.toString(),
                  //   "with": withSelected.toString()
                  // });

                  print("===================================");
                  print(selectMedicineList[0]);
                  print('value is--> ' + json.encode(selectMedicineList[0]));

                  // setState(() {
                  //   Navigator.pushReplacement(
                  //     context,
                  //     PageRouteBuilder(
                  //       transitionDuration: Duration.zero,
                  //       pageBuilder: (_, __, ___) => Abc(
                  //         selectMedicineList: selectMedicineList,
                  //       ),
                  //     ),
                  //   );
                  // });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Add more Medicine",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
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
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete, size: 22),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              selectMedicineList[index].time.toString() +
                                  "," +
                                  selectMedicineList[index].qut.toString() +
                                  " tablet with " +
                                  selectMedicineList[index].withtake.toString(),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      )
                    ]));
              }),
        ));
  }
}
