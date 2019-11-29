import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:notecounting/services/auth.service.dart';
import 'package:notecounting/screens/login.screen.dart';
import 'package:notecounting/screens/home.screen.dart';

AuthService appAuth = new AuthService();

void main() async {

  // ** BEGIN APP ROUTE ** //
  Router router = new Router();

  router.define('home', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
    return new HomeScreen();
  }));

  router.define('login', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
    return new LoginScreen();
  }));
  // ** END APP ROUTE ** //

  Widget _defaultHome = new LoginScreen();

  String _result = await appAuth.readUserKey();
  if (_result != 'false') {
    _defaultHome = new HomeScreen();
  }

  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    onGenerateRoute: router.generator,
    // routes: <String, WidgetBuilder>{
    //   '/home': (BuildContext context) => new HomeScreen(),
    //   '/login': (BuildContext context) => new LoginScreen()
    // },
  ));
}