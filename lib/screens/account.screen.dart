import 'package:flutter/material.dart';
import 'package:notecounting/utils/router.dart';
import 'package:notecounting/services/sign_in.service.dart';
import 'package:notecounting/services/auth.service.dart';

void main() async {
  FluroRouter.setupRouter();
  runApp(AccountScreen());
}

AuthService appAuth = new AuthService();

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyAccount(),
    );
  }
}

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State < MyAccount > {

  String _userEmail = "";
  String _userName  = "";
  String _userImage = "";

  _MyAccountState() {
    getEmailFromFile().then((val) => setState(() {
      _userEmail = val;
    }));

    getNameFromFile().then((val) => setState(() {
      _userName = val;
    }));

    getImageFromFile().then((val) => setState(() {
      _userImage = val;
    }));
  }

  Future<String> getEmailFromFile() async {
    return await appAuth.readUserEmail();
  }

  Future<String> getNameFromFile() async {
    return await appAuth.readUserName();
  }

  Future<String> getImageFromFile() async {
    return await appAuth.readUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: < Widget > [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  // imageUrl != null ? imageUrl : "https://via.placeholder.com/150/771796",
                  _userImage,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
              ),
              Text(
                _userName,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
              ),
              Text(
                _userEmail,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  appAuth.deleteUserKey().then(
                    (_) => Navigator.pushReplacementNamed(context, 'login')
                  );
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}