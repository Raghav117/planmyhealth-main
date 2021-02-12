import 'package:flutter/material.dart';
import 'package:plan_my_health/UI/PatentList.dart';
import 'package:plan_my_health/UI/UsersListScreen.dart';
import 'package:plan_my_health/UI/prescription.dart';
import 'package:plan_my_health/UI/editProfile.dart';
import 'package:plan_my_health/components/NavBarCustom.dart';
import 'search.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;
  final Tab = [
    ParientList(),
    Search(),
    Prescription(),
    EditProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavBarCustom(
          iconList: [
            "assets/img/nav_icon/plus.png",
            "assets/img/nav_icon/search.png",
            "assets/img/nav_icon/ticket.png",
            "assets/img/nav_icon/message.png",
          ],
          iconList_feel: [
            "assets/img/nav_icon/plus_feel.png",
            "assets/img/nav_icon/search_feel.png",
            "assets/img/nav_icon/ticket_feel.png",
            "assets/img/nav_icon/message_feel.png",
          ],
          iconTitle: [
            "Madical",
            "Prescriptions",
            "Booking",
            "Profile",
          ],
          onChange: (val) {
            setState(() {
              _selectedItem = val;
            });
          },
          defaultSelectedIndex: 0,
        ),
        body: Tab[_selectedItem]);
  }
}
