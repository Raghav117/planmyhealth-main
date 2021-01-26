import 'package:flutter/material.dart';

class NavBarCustom extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<String> iconList;
  final List<String> iconList_feel;
  final List<String> iconTitle;

  NavBarCustom(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.iconList_feel,
      @required this.iconTitle,
      @required this.onChange});

  @override
  _NavBarCustomState createState() =>
      _NavBarCustomState();
}

class _NavBarCustomState extends State<NavBarCustom> {
  int _selectedIndex = 0;
  List<String> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(
          _iconList[i], i, widget.iconTitle[i], widget.iconList_feel[i]));
    }

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200, //background color of box
                  blurRadius: 15.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                  offset: Offset(-0, -7),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: Row(
            children: _navBarItemList,
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(
      String icon, int index, String title, String icon_feel) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width / _iconList.length - 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 2.5,
              width: 30,
              color: index == _selectedIndex
                  ? Colors.green
                  : Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child:  Image.asset(
                      index == _selectedIndex ? icon_feel : icon,
                      height: 25,
                      width: 25,
                      // color: index == _selectedIndex
                      //     ? AppColors.PRIMARY_COLOR
                      //     : AppColors.TEXT_LIGHT_COLOR,
                      // size: 25,
                    ),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: index == _selectedIndex
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
