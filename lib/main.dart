import 'package:flutter/material.dart';
import 'package:notecounting/services/auth.service.dart';
import 'package:notecounting/utils/router.dart';
import 'package:notecounting/screens/login.screen.dart';
import 'package:notecounting/screens/home.screen.dart';

AuthService appAuth = new AuthService();

void main() async {
  FluroRouter.setupRouter();
  Widget _defaultHome = new LoginScreen();

  String _result = await appAuth.readUserKey();
  if (_result != 'false' || _result == null) {
    _defaultHome = new HomeScreen();
  }

  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    onGenerateRoute: FluroRouter.router.generator,
  ));
}