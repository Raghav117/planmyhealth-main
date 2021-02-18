import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'homewellnessrequest.dart';
import 'form.dart' as form;

class ParientList extends StatefulWidget {
  ParientList({Key key}) : super(key: key);

  @override
  _ParientListState createState() => _ParientListState();
}

class _ParientListState extends State<ParientList> {
  bool loading = true;
  Completer<GoogleMapController> _controller = Completer();
  List<String> options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 15, 15),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Welcome to My Plan Health," + data.name.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text("Log Out"),
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return MyApp();
                                  },
                                ));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  //         child: Container(
                  //             child: Row(children: [
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: Colors.green,
                  //               borderRadius: BorderRadius.all(Radius.circular(16)),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   vertical: 7, horizontal: 14),
                  //               child: Text("Cardiology",
                  //                   style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.w400,
                  //                       color: Colors.white,
                  //                       fontFamily: "HelveticaNeueMedium")),
                  //             ),
                  //           ),
                  //           SizedBox(width: 18),
                  //           Container(
                  //             child: Text("Oncology"),
                  //           ),
                  //           SizedBox(width: 18),
                  //           Container(
                  //             child: Text("Neurology"),
                  //           ),
                  //         ])),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // ListTile(
                        //   tileColor: Colors.green.shade50,
                        //   onTap: () {
                        //     // Navigator.push(context,
                        //     //     MaterialPageRoute(builder: (context) => PatientDetails(number: )));
                        //   },
                        //   //   onTap: () async => await launch(url("+91 7387563324")),
                        //   leading: Container(
                        //       width: 54,
                        //       height: 54,
                        //       decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //               fit: BoxFit.fill,
                        //               image: NetworkImage(
                        //                   "https://i1.wp.com/www.sardiniauniqueproperties.com/wp-content/uploads/2015/10/square-profile-pic-2.jpg")))),
                        //   title: Row(
                        //     children: [
                        //       Text(
                        //         "Anarghya Sravan",
                        //         style: TextStyle(
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //       SizedBox(width: 2),
                        //     ],
                        //   ),
                        //   subtitle: Padding(
                        //     padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        //     child: Text(
                        //       "+91 9820891087",
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //       softWrap: false,
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontFamily: "HelveticaNeueMedium",
                        //           fontSize: 14),
                        //     ),
                        //   ),
                        //   trailing: Column(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Text(
                        //         " [ M ]",
                        //         style: TextStyle(
                        //           color: Colors.green,
                        //           fontWeight: FontWeight.w800,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //       SizedBox(height: 10),
                        //       Container(
                        //           child: Text("26 years",
                        //               style: TextStyle(color: Colors.black))),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Offline",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                value: online,
                                activeColor: Colors.green,
                                onChanged: (value) async {
                                  if (value == false) {
                                    setState(() {
                                      loading = true;
                                    });
                                    var response = await http.post(
                                        "http://3.15.233.253:5000/doctorstatusupdate",
                                        body: {
                                          "status": "Offline",
                                          "statusservices": options.toString(),
                                          "mobilenumber": mobileController.text
                                        });
                                    setState(() {
                                      loading = false;
                                    });
                                    print(response.body);
                                  }
                                  setState(() {
                                    online = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              "Online",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                          ],
                        ),
                        online == false
                            ? Container()
                            : Material(
                                elevation: 20,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text("Chat")),
                                            Checkbox(
                                                activeColor: Colors.purple[300],
                                                value: chat,
                                                onChanged: (value) {
                                                  setState(() {
                                                    chat = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text("Home Visit")),
                                            Checkbox(
                                                activeColor: Colors.purple[300],
                                                value: home_visit,
                                                onChanged: (value) {
                                                  setState(() {
                                                    home_visit = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text("Video Call")),
                                            Checkbox(
                                                activeColor: Colors.purple[300],
                                                value: video,
                                                onChanged: (value) {
                                                  setState(() {
                                                    video = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text("At Center")),
                                            Checkbox(
                                                activeColor: Colors.purple[300],
                                                value: center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    center = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text("Call")),
                                            Checkbox(
                                                value: call,
                                                activeColor: Colors.purple[300],
                                                onChanged: (value) {
                                                  setState(() {
                                                    call = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        RaisedButton(
                                          elevation: 20,
                                          color: Colors.green[400],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });

                                            options.clear();
                                            if (chat == true)
                                              options.add("chat");
                                            if (home_visit == true)
                                              options.add("Home Visit");
                                            if (video == true)
                                              options.add("Vedio Call");
                                            if (center == true)
                                              options.add("At Center");
                                            if (call == true)
                                              options.add("Call");

                                            var response = await http.post(
                                                "http://3.15.233.253:5000/doctorstatusupdate",
                                                body: {
                                                  "status": "Online",
                                                  "statusservices":
                                                      options.toString(),
                                                  "mobilenumber":
                                                      mobileController.text
                                                });
                                            print(response.body);
                                            setState(() {
                                              loading = false;
                                              save = !save;
                                            });
                                          },
                                          child: Text(
                                            "Save",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Container(
                          height: MediaQuery.of(context).size.width,
                          width: double.infinity,
                          // color: Colors.green,
                          child: GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: position,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),

                        RaisedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeWellnessRequest(),
                            ),
                          ),
                          child: Text("Home Wellness"),
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => form.Form(),
                            ),
                          ),
                          child: Text("Home Wellness"),
                        ),
                      ],
                    ),
                  ),
                ])),
              ),
      ),
    );
  }

  CameraPosition position;
  @override
  void initState() {
    super.initState();
    position = CameraPosition(
        target:
            LatLng(double.parse(data.latitude), double.parse(data.longitude)));
    setState(() {
      loading = false;
    });
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
