import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/PatentList.dart';
import 'package:plan_my_health/UI/PatientDetails.dart';
import 'package:plan_my_health/UI/UsersListScreen.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/editProfile.dart';
import 'package:plan_my_health/components/NavBarCustom.dart';
import 'search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;
  final Tab = [
    ParientList(),
    Search(
      previous: false,
    ),
    UserListScreen(),
    EditProfile(),
  ];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedItem,
          showElevation: true, //00 use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedItem = index;
            print(index);

            // _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              activeColor: Colors.greenAccent,
              icon: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/img/nav_icon/plus.png",
                  color: Colors.greenAccent,
                ),
              ),
              title: Text('Madical', style: GoogleFonts.dosis()),
              // activeColor: firstColor,
            ),
            BottomNavyBarItem(
              activeColor: Colors.greenAccent,
              icon: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/img/nav_icon/search.png",
                  color: Colors.greenAccent,
                  fit: BoxFit.contain,
                ),
              ),
              title: Text('Prescriptions', style: GoogleFonts.dosis()),
              // activeColor: firstColor,
            ),
            BottomNavyBarItem(
              activeColor: Colors.greenAccent,
              icon: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/img/nav_icon/ticket.png",
                  color: Colors.greenAccent,
                ),
              ),
              title: Text('Booking', style: GoogleFonts.dosis()),
              // activeColor: firstColor
              //  activeColor: Colors.pink
            ),
            BottomNavyBarItem(
              activeColor: Colors.greenAccent,
              icon: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/img/nav_icon/message.png",
                  color: Colors.greenAccent,
                ),
              ),
              title: Text('Profile', style: GoogleFonts.dosis()),
              // activeColor: firstColor,
              //  activeColor: Colors.purpleAccent
            ),
          ],
        ),
        body: Tab[_selectedItem]);
  }
}
