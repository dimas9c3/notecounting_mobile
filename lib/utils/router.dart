import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:notecounting/screens/login.screen.dart';
import 'package:notecounting/screens/home.screen.dart';
import 'package:notecounting/screens/account.screen.dart';
import 'package:notecounting/screens/note.screen.dart';
import 'package:notecounting/screens/note.add.screen.dart';

class FluroRouter {
  static Router router = Router();

  static Handler _loginHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => LoginScreen());

  static Handler _homeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => HomeScreen());

  static Handler _accountHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AccountScreen());

  static Handler _noteHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => Note());

  static Handler _noteAddHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AddNote());

  static void setupRouter() {
    router.define(
      'login',
      handler: _loginHandler,
    );

    router.define(
      'home',
      handler: _homeHandler,
    );

    router.define(
      'account',
      handler: _accountHandler,
    );

    router.define(
      'note',
      handler: _noteHandler,
    );

    router.define(
      'note/add',
      handler: _noteAddHandler,
    );
  }

}