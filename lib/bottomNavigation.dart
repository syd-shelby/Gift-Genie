import 'package:flutter/material.dart';
import 'package:gift_genie/utils/user.dart';
import 'package:gift_genie/calendar/calendarPage.dart';
import 'package:gift_genie/contacts/contactPage.dart';
import 'package:gift_genie/home/homePage.dart';
import 'package:gift_genie/profile/profilePage.dart';
import 'package:gift_genie/list/listPage.dart';
import 'package:gift_genie/auth/state_widget.dart';
import 'package:gift_genie/auth/state.dart';


class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}

class BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottomNavigationColor = Colors.blue;
  int _currentIndex = 2;
  List<Widget> pages = List<Widget>();
  StateModel _appState;
  User user;


  @override
  void initState() {
    /*
    pages.add(CalendarPage(title: "Scheduler",));
    pages.add(ListPage());
    pages.add(HomePage());
    pages.add(ContactPage());
    pages.add(ProfilePage());
    */
  }

  @override
  Widget build(BuildContext context) {

    _appState = StateWidget.of(context).state;
    user = _appState.uuser;

    setState(() {
      pages.add(CalendarPage(title: "Scheduler",));
      pages.add(ListPage());
      pages.add(HomePage());
      pages.add(ContactPage());
      pages.add(ProfilePage());
    });

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'CALENDAR',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'LIST',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'HOME',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.contacts,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'CONTACTS',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'PROFILE',
                style: TextStyle(color: _bottomNavigationColor),
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pages[_currentIndex],
    );
  }
}
