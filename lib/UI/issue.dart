import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/equipments.dart';

class Iss extends StatefulWidget {
  @override
  _IssState createState() => _IssState();
}

class _IssState extends State<Iss> {
  List<Issue> equip = [];
  List<bool> colors = [];

  getIss() async {
    var response = await http.get("http://3.15.233.253:5000/healthissues");
    print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["healthissueslist"]) {
      colors.add(false);
      equip.add(Issue.fromJson(data));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getIss();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Issue"),
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
                  itemCount: equip.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      setState(() {
                        colors[index] = !colors[index];
                      });
                    },
                    // tileColor:
                    title: Text(
                      equip[index].description,
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
