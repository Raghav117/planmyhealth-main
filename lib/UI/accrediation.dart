import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:plan_my_health/model/accrediations.dart';

class Accrediations extends StatefulWidget {
  @override
  _AccrediationsState createState() => _AccrediationsState();
}

class _AccrediationsState extends State<Accrediations> {
  List<Accrediation> accrediation = [];
  List<bool> colors = [];

  getAccrediations() async {
    var response = await http.get("http://3.15.233.253:5000/getaccrediation");
    print(response.body);
    Map m = jsonDecode(response.body);
    for (var data in m["accrediationlist"]) {
      colors.add(false);
      accrediation.add(Accrediation.fromJson(data));
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
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Accrediations",
          style: GoogleFonts.dosis(),
        ),
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
                  itemCount: accrediation.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          colors[index] = !colors[index];
                        });
                      },
                      // tileColor:
                      title: Text(
                        accrediation[index].accrediationName,
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
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
    );
  }
}
