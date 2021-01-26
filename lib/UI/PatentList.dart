import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:url_launcher/url_launcher.dart';

class ParientList extends StatefulWidget {
  ParientList({Key key}) : super(key: key);

  @override
  _ParientListState createState() => _ParientListState();
}

class _ParientListState extends State<ParientList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 15, 15),
              child: Text(
                "Welcome to My Plan Health",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                      child: Row(children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 14),
                        child: Text("Cardiology",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontFamily: "HelveticaNeueMedium")),
                      ),
                    ),
                    SizedBox(width: 18),
                    Container(
                      child: Text("Oncology"),
                    ),
                    SizedBox(width: 18),
                    Container(
                      child: Text("Neurology"),
                    ),
                  ])),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                tileColor: Colors.green.shade50,
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => PatientDetails(number: )));
                },
                //   onTap: () async => await launch(url("+91 7387563324")),
                leading: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://i1.wp.com/www.sardiniauniqueproperties.com/wp-content/uploads/2015/10/square-profile-pic-2.jpg")))),
                title: Row(
                  children: [
                    Text(
                      "Anarghya Sravan",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 2),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    "+91 9820891087",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "HelveticaNeueMedium",
                        fontSize: 14),
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      " [ M ]",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        child: Text("26 years",
                            style: TextStyle(color: Colors.black))),
                  ],
                ),
              ),
            ],
          ),
        ])),
      ),
    );
  }

  String url(String phone) {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text= "; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone= "; // new line
    }
  }
}
