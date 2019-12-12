import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notecounting/screens/note.screen.dart';
import 'package:notecounting/screens/account.screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State < HomeScreen > {
  int currentPage = 0;
  DateTime currentBackPressTime;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        onWillPop: onWillPop),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
            iconData: Icons.home,
            title: "Home",
            onclick: () {
              final FancyBottomNavigationState fState =
                bottomNavigationKey.currentState;
              fState.setPage(0);
            }),
          TabData(
            iconData: Icons.note,
            title: "User Notes",
            onclick: () {
              final FancyBottomNavigationState fState =
                bottomNavigationKey.currentState;
              fState.setPage(1);
            }),
          TabData(
            iconData: Icons.account_balance_wallet,
            title: "Balance",
            onclick: () {
              final FancyBottomNavigationState fState =
                bottomNavigationKey.currentState;
              fState.setPage(2);
            }),
          TabData(
            iconData: Icons.account_box,
            title: "Account",
            onclick: () {
              final FancyBottomNavigationState fState =
                bottomNavigationKey.currentState;
              fState.setPage(3);
            }),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: < Widget > [
            Text("This is the home page"),
            RaisedButton(
              child: Text(
                "Change to page Account Screen",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.pushNamed(context, 'account');
              },
            )
          ],
        );
      case 1:
        return new Note();
      case 2:
        return new AccountScreen();
      case 3:
        return new AccountScreen();
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}