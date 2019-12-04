import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:notecounting/screens/login.screen.dart';
import 'package:notecounting/screens/account.screen.dart';
import 'package:notecounting/screens/note.screen.dart';
import 'package:notecounting/screens/note.add.screen.dart';
import 'package:notecounting/screens/test.screen.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
    // ** BEGIN APP ROUTE ** //
    Router router = new Router();

    router.define('home', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
      return new HomeScreen();
    }));

    router.define('login', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
      return new LoginScreen();
    }));

    router.define('account', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
      return new AccountScreen();
    }));

    router.define('note/add', handler: new Handler(handlerFunc: (BuildContext context, Map < String, dynamic > params) {
      return new AddNote();
    }));
    // ** END APP ROUTE ** //

		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
				primarySwatch: Colors.purple,
			),
			home: MyHomePage(),
      onGenerateRoute: router.generator,
		);
	}
}

class MyHomePage extends StatefulWidget {
	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State < MyHomePage > {
	int currentIndex = 0;

	GlobalKey bottomNavigationKey = GlobalKey();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			// appBar: AppBar(
			// 	title: Text("NoteCounting"),
			// ),
			body: Container(
				decoration: BoxDecoration(color: Colors.white),
				child: Center(
					child: _getPage(currentIndex),
				),
			),
			bottomNavigationBar: BottomNavyBar(
				selectedIndex: currentIndex,
				showElevation: true,
				itemCornerRadius: 8,
				onItemSelected: (index) => setState(() {
					currentIndex = index;
				}),
				items: [
          BottomNavyBarItem(
						icon: Icon(Icons.apps),
						title: Text('Home'),
						activeColor: Colors.black,
					),
					BottomNavyBarItem(
						icon: Icon(Icons.speaker_notes),
						title: Text('Note'),
						activeColor: Colors.black,
					),
          BottomNavyBarItem(
						icon: Icon(Icons.attach_money),
						title: Text('Accounting'),
						activeColor: Colors.black,
					),
					BottomNavyBarItem(
						icon: Icon(Icons.person),
						title: Text('Account'),
						activeColor: Colors.black,
					),
				],
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
        return new MyApp();
			case 3:
				return new AccountScreen();
		}
	}
}