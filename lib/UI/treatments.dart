import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/equipments.dart';

class Treatments extends StatefulWidget {
  @override
  _TreatmentsState createState() => _TreatmentsState();
}

class _TreatmentsState extends State<Treatments> {
  List<Treatment> equip = [];
  List<bool> colors = [];

  getTreatments() async {
    var response = await http.get("http://3.15.233.253:5000/procedures");
    print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["procedureslist"]) {
      colors.add(false);
      equip.add(Treatment.fromJson(data));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTreatments();
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Treatments",
          style: GoogleFonts.dosis(),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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
                      style: GoogleFonts.dosis(
                        fontSize: 18,
                        color: colors[index] == false
                            ? Colors.black
                            : Colors.greenAccent,
                      ),
                    ),
                    leading: colors[index] == false
                        ? Icon(Icons.check_box_outline_blank)
                        : Icon(
                            Icons.check_box,
                            color: Colors.greenAccent,
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
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                        child: Text(
                      "Done",
                      style: GoogleFonts.dosis(color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
    );
  }
}
