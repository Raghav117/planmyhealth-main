import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/speciality.dart';

class Specialityy extends StatefulWidget {
  @override
  _AccrediationsState createState() => _AccrediationsState();
}

class _AccrediationsState extends State<Specialityy> {
  List<Speciality> specialtiy = [];
  List<bool> colors = [];

  getAccrediations() async {
    var response = await http.get("http://3.15.233.253:5000/specialities");
    print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["specialitieslist"]) {
      colors.add(false);
      specialtiy.add(Speciality.fromJson(data));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAccrediations();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speciality"),
        centerTitle: true,
      ),
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: specialtiy.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      setState(() {
                        colors[index] = !colors[index];
                      });
                    },
                    // tileColor:
                    title: Text(
                      specialtiy[index].name,
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            colors[index] == false ? Colors.black : Colors.blue,
                      ),
                    ),
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
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
