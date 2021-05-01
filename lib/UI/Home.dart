import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plan_my_health/UI/PatentList.dart';
import 'package:plan_my_health/UI/UsersListScreen.dart';
import 'package:plan_my_health/UI/editProfile.dart';
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
              activeColor: Colors.greenAccent,
              icon: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  "assets/img/nav_icon/plus.png",
                  color: Colors.greenAccent,
                ),
              ),
              title: Text('Madical',
                  style: GoogleFonts.dosis(color: Colors.greenAccent)),
            ),
            BottomNavyBarItem(
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.grey,
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
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.grey,
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
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.grey,
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
            ),
          ],
        ),
        body: tab[_selectedItem]);
  }
}
