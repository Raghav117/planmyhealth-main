import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:plan_my_health/UI/homeVistForm.dart';
import 'package:plan_my_health/global/design.dart';
import 'package:plan_my_health/global/global.dart';
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

  Set<Polyline> _polylines = {};

// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //!  --------------  For getting Location  -------------------------

  getLocation() async {
    loading = true;
    _locationData = await location.getLocation();
    setState(() {
      loading = false;
    });
    setPolylines();
  }

  //!  --------------  For Making Path  -------------------------

  setPolylines() async {
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        "AIzaSyChfbb57VsD7N7LQK_L4Upl6Yma47jzIps",
        PointLatLng(_locationData.latitude, _locationData.longitude),
        PointLatLng(double.parse(data.latitude), double.parse(data.longitude)));
    if (result != null) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: primary,
          width: 5,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    setPolylines();
  }
  //!  --------------  Main Method  -------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          "Welcome to My Plan Health, " + data.name.toString(),
          style: GoogleFonts.roboto(
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
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text("Log Out", style: GoogleFonts.roboto()),
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
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Switch(
                                value: online,
                                activeColor: primary,
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
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                          ],
                        ),
                        online == false
                            ? Container()
                            : Material(
                                elevation: 2,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: primary.withOpacity(0.5),
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
                                                style: GoogleFonts.roboto(
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
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                            Checkbox(
                                                activeColor: Colors.green,
                                                value: homeVisit,
                                                onChanged: (value) {
                                                  setState(() {
                                                    homeVisit = value;
                                                  });
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              "Video Call",
                                              style: GoogleFonts.roboto(
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
                                              style: GoogleFonts.roboto(
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
                                              style: GoogleFonts.roboto(
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
                                        // ignore: deprecated_member_use
                                        RaisedButton(
                                          elevation: 5,
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
                                            if (homeVisit == true)
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
                                            style: GoogleFonts.roboto(
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
                                border: Border.all(color: primary, width: 2)),
                            // color: primary,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GoogleMap(
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                polylines: _polylines,
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
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.email,
                    style: GoogleFonts.roboto(),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Health Article", style: GoogleFonts.roboto()),
              leading: Icon(
                Icons.healing_outlined,
                color: primary,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => form.Form(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Divider(
                color: primary,
              ),
            ),
            ListTile(
                title: Text("Home Wellness", style: GoogleFonts.roboto()),
                leading: Icon(
                  Icons.wallet_travel_outlined,
                  color: primary,
                ),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeWellnessRequest(),
                      ),
                    )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Divider(
                color: primary,
              ),
            ),
            ListTile(
              title: Text("Account", style: GoogleFonts.roboto()),
              leading: Icon(
                Icons.account_balance,
                color: primary,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Account(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Divider(
                color: primary,
              ),
            ),
            ListTile(
              title: Text("Home Visit", style: GoogleFonts.roboto()),
              leading: Icon(
                Icons.home,
                color: primary,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeVisitForm(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Divider(
                color: primary,
              ),
            ),
            ListTile(
                title: Text("Logout", style: GoogleFonts.roboto()),
                leading: Icon(
                  Icons.logout,
                  color: primary,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ));
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Divider(
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
