import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:notecounting/models/notes.dart';
import 'package:notecounting/utils/globals.dart';
import 'package:notecounting/services/auth.service.dart';

AuthService appAuth = new AuthService();
// RefreshController _refreshController = RefreshController(initialRefresh: false);

void main() => runApp(Note());

class Note extends StatefulWidget {
  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State < Note > {
  Future < List < Notes >> notes;

  @override
  void initState() {
    super.initState();
    notes = _fetchNotes();
  }

  Future < List < Notes >> _fetchNotes() async {
    String _token = await appAuth.readUserKey();
    String _email = await appAuth.readUserEmail();
    final String url = Globals.apiUrl + "v1/usernotes/getByEmail" + _token;
    try {
      Response response = await Dio().post(url, data: {
        'email': _email,
      });

      final items = response.data["data"].cast < Map < String, dynamic >> ();
      List < Notes > listOfNotes = items.map < Notes > ((json) {
        return Notes.fromJson(json);
      }).toList();

      return listOfNotes;

    } catch (e) {
      throw Exception(e);
    }
  }

  // void _onRefresh() async {
  //       setState(() {
  //           notes = _fetchNotes();
  //       });

  //       _refreshController.refreshCompleted();
  //   }

  //   void _onLoading() async {

  //       if (mounted)
  //         setState(() {

  //         });
  //       _refreshController.loadComplete();
  //   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Column(
            children: < Widget > [
              Stack(
                children: < Widget > [backgroundHeader(), summary()],
              ),
              FutureBuilder < List < Notes >> (
                future: notes,
                builder: (BuildContext context, AsyncSnapshot < List < Notes >> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        elevation: 8,
                        child: ListTile(
                          leading: Icon(
                            snapshot.data[index].type == "Regular" ? Icons.check_box : Icons.timer,
                            color: snapshot.data[index].type == "Regular" ? Colors.lightGreen : Colors.redAccent,
                          ),
                          title: Text(
                            snapshot.data[index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Label : " + snapshot.data[index].label),
                          trailing: Text(
                            snapshot.data[index].status,
                            style: TextStyle(color: snapshot.data[index].status == "Completed" ? Colors.lightGreen : Colors.redAccent),
                          ),
                        ),
                      );
                    },
                  );

                },
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                _navigateAddScreen(context);
              },
              tooltip: 'Add Note',
              child: Icon(Icons.add),
              backgroundColor: Colors.purple,
            ),
        ),
      ),
    );
  }

  _navigateAddScreen(BuildContext context) async {
    final result = await Navigator.pushNamed(context, 'note/add');

    if (result != null) {
      var res = json.decode(result);

      if (res['fromScreen'] == 'addUserNotes' && res['isRefresh'] == true) {
        setState(() {
            notes = _fetchNotes();
        });
        String msg = res['message'];
        Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500), content: Text("$msg")));
      }
    }
  }
}

Widget summary() {
  return Positioned(
    top: 100,
    left: 45,
    child: Container(
      width: 360,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: < Widget > [
              Column(
                children: < Widget > [
                  Text("Summary"),
                  Divider(),
                  Text(
                    "There's 2 On Progress Notes",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
      ),
    ),
  );
}

Widget backgroundHeader() {
  return Container(
    height: 200,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.purple,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: < Widget > [
              Text(
                "User Notes",
                style: TextStyle(
                  fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ),
    ),
  );
}