import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/PatentList.dart';
import 'package:plan_my_health/UI/UsersListScreen.dart';
import 'package:plan_my_health/UI/editProfile.dart';
import 'package:plan_my_health/global/design.dart';
import 'search.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;
  final tab = [
    ParientList(),
    Search(
      previous: false,
    ),
    UserListScreen(),
    EditProfile(),
  ];

//!  -----------------  Main Method  --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedItem,
          onItemSelected: (index) => setState(() {
            _selectedItem = index;
            print(index);
          }),
          items: [
            BottomNavyBarItem(
              inactiveColor: Colors.grey,
              activeColor: primary,
              // icon: Container(
              //   height: 25,
              //   width: 25,
              //   child: Image.asset(
              //     "assets/img/nav_icon/plus.png",
              //     color: primary,
              //   ),
              // ),
              icon: Icon(
                Icons.medical_services,
                size: 25,
                color: primary,
              ),
              title: Text('Medical', style: GoogleFonts.roboto(color: primary)),
            ),
            BottomNavyBarItem(
              activeColor: primary,
              inactiveColor: Colors.grey,
              // icon: Container(
              //   height: 25,
              //   width: 25,
              //   child: Image.asset(
              //     "assets/img/nav_icon/search.png",
              //     color: primary,
              //     fit: BoxFit.contain,
              //   ),
              // ),
              icon: Icon(
                Icons.dashboard_customize,
                size: 25,
                color: primary,
              ),
              title: Text('Prescriptions', style: GoogleFonts.roboto()),
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.grey,
              activeColor: primary,
              // icon: Container(
              //   height: 25,
              //   width: 25,
              //   child: Image.asset(
              //     "assets/img/nav_icon/ticket.png",
              //     color: primary,
              //   ),
              // ),
              icon: Icon(
                Icons.stroller_rounded,
                size: 25,
                color: primary,
              ),
              title: Text('Booking', style: GoogleFonts.roboto()),
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.grey,
              activeColor: primary,
              // icon: Container(
              //   height: 25,
              //   width: 25,
              //   child: Image.asset(
              //     "assets/img/nav_icon/message.png",
              //     color: primary,
              //   ),
              // ),
              icon: Icon(
                Icons.account_circle,
                size: 25,
                color: primary,
              ),
              title: Text('Profile', style: GoogleFonts.roboto()),
            ),
          ],
        ),
        body: tab[_selectedItem]);
  }
}
