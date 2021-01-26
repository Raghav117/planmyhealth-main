import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/model/PatientList.dart';
import 'package:url_launcher/url_launcher.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with WidgetsBindingObserver {
  List<Doctorlist> orderList;
  bool onCall = false;
  ApiHelper apiHelper = ApiHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("geting doctore list");
    getuserlist();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (onCall) {
      _showDialog();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _showDialog() {
    print("dialog box call");
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Call Conformation"),
          content: new Text("Do you wish to make prescription for pationt ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Prescription()));
              },
            ),
          ],
        );
      },
    );
  }

  // Future<List<Doctorlist> getuserlist() {
  //   apiHelper.getOderList().then((userlist) {
  //     // print(userlist.doctorlist[0].userdata[0].name);
  //     for (Doctorlist doctorlist in userlist.doctorlist) {
  //       List<Doctorlist> orderList = [];
  //       orderList.add(doctorlist);
  //       // for (Userdata userdata in doctorlist.userdata) {
  //       //   print(userdata.name);
  //       // }
  //     }
  //   });
  //   return orderList;
  // }

  Future<List<Doctorlist>> getuserlist() async {
    List<Doctorlist> days = [];
    await apiHelper.getOderList().then((userlist) {
      for (int i = 0; i <= userlist.doctorlist.length; i++) {
        print("adding");
        days.add(userlist.doctorlist[i]);
      }
    });
    print("--------------------------------------- check-------------");
    print(days);
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Page title'),
        actions: [
          Icon(Icons.favorite),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.search),
          ),
          Icon(Icons.more_vert),
        ],
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<List<Doctorlist>>(
            future: getuserlist(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Doctorlist> data = snapshot.data;
                return _jobsListView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                child: Container(
                    height: 40, width: 40, child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }

  ListView _jobsListView(data) {
    print("---------------------");
    print("length of get users list" + data.length);
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].userdata[0]);
        });
  }

  ListTile _tile(dynamic user) => ListTile(
        tileColor: Colors.green.shade50,
        // onTap: () async => await launch(url("+91 " + user.mobile.toString())),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PatientDetails(number: user.mobile.toString())));
        },
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
              user.name,
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
            user.mobile.toString(),
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
              " [ " + user.gender + " ]",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Container(
                child: Text(user.age.toString() + " Years",
                    style: TextStyle(color: Colors.black))),
          ],
        ),
      );

  String url(String phone) {
    print("Call url function");
    if (Platform.isAndroid) {
      // add the [https]
      setState(() {
        onCall = true;
      });
      return "https://wa.me/$phone/?text= "; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone= "; // new line
    }
  }
}
