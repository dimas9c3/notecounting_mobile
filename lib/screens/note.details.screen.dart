import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:notecounting/utils/globals.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:notecounting/services/auth.service.dart';

AuthService appAuth = new AuthService();
ProgressDialog pr;

class DetailsNote extends StatefulWidget {
  final String noteId;
  final String noteTitle;
  final String noteLabel;
  final String noteType;
  final String noteDescription;

  DetailsNote({
     Key key,
     @required 
     this.noteId,
     this.noteTitle,
     this.noteLabel,
     this.noteType,
     this.noteDescription,
   }): super(key: key);

  @override
  _DetailsNoteState createState() => _DetailsNoteState();
}

class _DetailsNoteState extends State < DetailsNote > {
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    final Size screenSize = MediaQuery.of(context).size;

    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: < Widget > [
            IconButton(icon: Icon(Icons.delete), onPressed: _showDialog),
          ],
        ),
        body: Container(
          child: ListView(
            children: < Widget > [
              Stack(
                children: < Widget > [backgroundHeader(), summary()],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: screenSize.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: < Widget > [
                            Center(
                              child: Text(
                                widget.noteTitle,
                                style: TextStyle(
                                  fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                                child: Text(
                                 widget.noteDescription,
                                  style: TextStyle(
                                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                            )
                          ],
                        ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, 'note/add');
              },
              tooltip: 'Edit Note',
              child: Icon(Icons.edit, color: Colors.black,),
              backgroundColor: Colors.white,
            ),
        ),
      ),
    );
  }

  Widget summary() {
    return Positioned(
      top: 40,
      left: 45,
      child: Container(
        width: 360,
        height: 80,
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
                    // Text("Summary"),
                    // Divider(),
                    Text(
                      "Label: " + widget.noteLabel,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Column(
                  children: < Widget > [
                    // Text("Summary"),
                    // Divider(),
                    Text(
                      "Type: " + widget.noteType,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
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
      height: 100,
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
          padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: < Widget > [
                Text(
                  "Details User Notes",
                  style: TextStyle(
                    fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Notes"),
          content: new Text("Are you sure delete this notes ?"),
          actions: < Widget > [
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                submitDelete();
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void submitDelete() async {
    Future.delayed(Duration(milliseconds: 30)).then((onValue) {
      pr.show();
    });

    String _token = await appAuth.readUserKey();

    var url = Globals.apiUrl + "v1/usernotes/delete/" + widget.noteId + _token;

    try {
      Response response = await Dio().get(url);

      pr.hide();

      Future.delayed(Duration(milliseconds: 30)).then((onValue) {
        if (response.data["result"] == 1) {
          var mes = response.data["message"];
          var msg = '{"isRefresh": true, "fromScreen": "deleteNotes", "message": "$mes"}';
          Navigator.pop(context, msg);
        } else {
          // showToast(response.data["reason"]["0"], duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
      });

    } catch (e) {
      Navigator.pop(context, false);
      // showToast("Network failure", gravity: Toast.TOP);
    }
  }
}

