import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flushbar/flushbar.dart';
import 'package:notecounting/utils/router.dart';
import 'package:notecounting/models/notes.dart';
import 'package:notecounting/utils/globals.dart';
import 'package:notecounting/services/auth.service.dart';
import 'package:notecounting/screens/note.details.screen.dart';
import 'package:notecounting/screens/note.edit.screen.dart';

AuthService appAuth = new AuthService();
RefreshController _refreshController = RefreshController(initialRefresh: false);

void main() async {
  FluroRouter.setupRouter();
  runApp(Note());
}

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

  void _onRefresh() async {
    setState(() {
      notes = _fetchNotes();
    });

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {

    if (mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: FluroRouter.router.generator,
      home: Scaffold(
        body: Container(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropMaterialHeader(color: Colors.black,),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CircularProgressIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(
              children: < Widget > [
                Stack(
                  children: < Widget > [backgroundHeader(), summary()],
                ),
                Container(
                  // padding: const EdgeInsets.only(top: 10),
                    child:
                    FutureBuilder < List < Notes >> (
                      future: notes,
                      builder: (BuildContext context, AsyncSnapshot < List < Notes >> snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                              child: Center(child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation < Color > (Colors.purple)
                              )),
                          );
                        }

                        if (snapshot.data.length == 0) {
                          return Container(
                            child: Column(
                              children: < Widget > [
                                Center(
                                  child: Card(
                                    margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                                    elevation: 8,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.hourglass_empty,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        "Data Is Empty Or No Internet Connection",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text("Please Create New Note Or Connect To Internet"),
                                      trailing: Icon(Icons.warning, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
                              elevation: 8,
                              child: ListTile(
                                onLongPress: () async {
                                  final result = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => EditNote(
                                      noteId: snapshot.data[index].id.toString(),
                                      noteTitle: snapshot.data[index].title,
                                      noteLabel: snapshot.data[index].label,
                                      noteType: snapshot.data[index].type,
                                      noteDescription: snapshot.data[index].description,
                                      noteDueDate: snapshot.data[index].dueDate,
                                    )),
                                  );

                                  if (result != null) {
                                    var res = json.decode(result);

                                    if (res['fromScreen'] == 'EditUserNotes' && res['isRefresh'] == true){
                                      setState(() {
                                        notes = _fetchNotes();
                                      });

                                      String msg = res['message'];
                                      Flushbar(
                                        message: msg,
                                        flushbarPosition: FlushbarPosition.TOP,
                                        icon: Icon(
                                          Icons.info_outline,
                                          size: 28.0,
                                          color: Colors.blue[300],
                                        ),
                                        duration: Duration(seconds: 3),
                                        leftBarIndicatorColor: Colors.blue[300],
                                      )..show(context);
                                    }
                                  }
                                },
                                onTap: () async {
                                  // final result = await Navigator.pushNamed(context, 'note/details');
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => DetailsNote(
                                      noteId: snapshot.data[index].id.toString(),
                                      noteTitle: snapshot.data[index].title,
                                      noteLabel: snapshot.data[index].label,
                                      noteType: snapshot.data[index].type,
                                      noteDescription: snapshot.data[index].description,
                                      noteDueDate: snapshot.data[index].dueDate,
                                    )),
                                  );
                                },
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
                ),
              ],
            ),
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
        Flushbar(
          message: msg,
          flushbarPosition: FlushbarPosition.TOP,
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
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