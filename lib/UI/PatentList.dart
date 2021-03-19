import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/UI/form2.dart';
import 'package:plan_my_health/global/global.dart';
import 'package:plan_my_health/model/Patient.dart';
import 'package:plan_my_health/model/Specialities.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'homewellnessrequest.dart';
import 'account.dart';
import 'healtharticle.dart' as form;

class ParientList extends StatefulWidget {
  ParientList({Key key}) : super(key: key);

  @override
  _ParientListState createState() => _ParientListState();
}

class _ParientListState extends State<ParientList> {
  bool loading = true;
  Completer<GoogleMapController> _controller = Completer();
  List<String> options = [];
  List<Marker> marker = [];
  Location location = new Location();
  LocationData _locationData;
  getLocation() async {
    loading = true;
    _locationData = await location.getLocation();
    setState(() {
      loading = false;
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Welcome to My Plan Health, " + data.name.toString(),
          style: GoogleFonts.dosis(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    child: Column(children: [
                  Container(
                      // width: MediaQuery.of(context).size.width,
                      // color: Colors.greenAccent,
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text("Log Out", style: GoogleFonts.dosis()),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return MyApp();
                          },
                        ));
                      },
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Offline",
                              style: GoogleFonts.dosis(
                                  fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                value: online,
                                activeColor: Colors.greenAccent,
                                onChanged: (value) async {
                                  if (value == false) {
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
                              style: GoogleFonts.dosis(
                                  fontWeight: FontWeight.bold),
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
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Chat",
                                                style: GoogleFonts.dosis(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Checkbox(
                                                activeColor: Colors.green,
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
                                            Expanded(
                                                child: Text(
                                              "Home Visit",
                                              style: GoogleFonts.dosis(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Checkbox(
                                                activeColor: Colors.green,
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
                                            Expanded(
                                                child: Text(
                                              "Video Call",
                                              style: GoogleFonts.dosis(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Checkbox(
                                                activeColor: Colors.green,
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
                                            Expanded(
                                                child: Text(
                                              "At Center",
                                              style: GoogleFonts.dosis(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Checkbox(
                                                activeColor: Colors.green,
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
                                            Expanded(
                                                child: Text(
                                              "Call",
                                              style: GoogleFonts.dosis(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Checkbox(
                                                value: call,
                                                activeColor: Colors.green,
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
                                              // loading = true;
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
                                            style: GoogleFonts.dosis(
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.width,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.greenAccent, width: 2)),
                            // color: Colors.greenAccent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GoogleMap(
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                markers: marker.toSet(),
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(_locationData.latitude,
                                        _locationData.longitude),
                                    zoom: 15),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ])),
              ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(253, 213, 124, 1),
                        border: Border.all(
                          color: Color.fromRGBO(253, 213, 124, 1),
                        )),
                    child: Image.network("http://3.15.233.253/" + data.picture),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(data.name,
                      style: GoogleFonts.dosis(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(data.email, style: GoogleFonts.dosis()),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text("Health Article", style: GoogleFonts.dosis()),
              leading: Icon(Icons.healing_outlined),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => form.Form(),
                ),
              ),
            ),
            ListTile(
                title: Text("Home Wellness", style: GoogleFonts.dosis()),
                leading: Icon(Icons.wallet_travel_outlined),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeWellnessRequest(),
                      ),
                    )),
            ListTile(
              title: Text("Account", style: GoogleFonts.dosis()),
              leading: Icon(Icons.account_balance),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Account(),
                ),
              ),
            ),
            ListTile(
              title: Text("Home Visit", style: GoogleFonts.dosis()),
              leading: Icon(Icons.home),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeVisitForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CameraPosition position;
  @override
  void initState() {
    super.initState();
    loading = true;

    getLocation();
    marker.add(Marker(
        markerId: MarkerId("Location"),
        position:
            LatLng(double.parse(data.latitude), double.parse(data.longitude))));
    position = CameraPosition(
        zoom: 16,
        target:
            LatLng(double.parse(data.latitude), double.parse(data.longitude)));
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
