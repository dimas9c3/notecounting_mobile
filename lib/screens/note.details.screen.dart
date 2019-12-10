import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:notecounting/services/auth.service.dart';
import 'package:notecounting/utils/globals.dart';

AuthService appAuth = new AuthService();
ProgressDialog pr;

class DetailsNote extends StatefulWidget {
  final String noteId;
  final String noteTitle;
  final String noteLabel;
  final String noteType;
  final String noteStatus;
  final String noteDescription;
  final String noteDueDate;

  DetailsNote({
    Key key,
    @required
    this.noteId,
    this.noteTitle,
    this.noteLabel,
    this.noteType,
    this.noteStatus,
    this.noteDescription,
    this.noteDueDate,
  }): super(key: key);

  @override
  _DetailsNoteState createState() => _DetailsNoteState();
}

class _DetailsNoteState extends State < DetailsNote > {
  bool _buttonCompleteVisible;
  String _dueDateValue;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (widget.noteStatus == "OnProgress" || widget.noteStatus == "Overdate") {
      _buttonCompleteVisible = true;
    }else {
      _buttonCompleteVisible = false;
    }

    if (widget.noteDueDate == null) {
      _dueDateValue = "";
    }else {
      _dueDateValue = widget.noteDueDate;
    }

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation < Color > (Colors.purple),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: ListView(
          children: < Widget > [
            Stack(
              children: < Widget > [backgroundHeader(),
                // Summary Header
                Positioned(
                  top: 40,
                  left: 45,
                  child: Container(
                    width: 360,
                    height: 120,
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
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Stack(
                                  children: < Widget > [
                                    Column(
                                      children: < Widget > [
                                        Text(
                                          "Label: " + widget.noteLabel,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                        ),
                                        new Divider(color: Colors.purple, thickness: 1, ),
                                        Text(
                                          "Type: " + widget.noteType,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Stack(
                                  children: < Widget > [
                                    Column(
                                      children: < Widget > [
                                        Text(
                                          "Status: " + widget.noteStatus,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)
                                        ),
                                        new Divider(color: Colors.purple, thickness: 1, ),
                                        Visibility(
                                          visible: _buttonCompleteVisible,
                                          child: Text(
                                            "Due Date: " + _dueDateValue,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
              ],
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
                      padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: < Widget > [
                            Center(
                              child: Text(
                                widget.noteTitle,
                                style: TextStyle(
                                  fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
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
      floatingActionButton: Visibility(
        visible: _buttonCompleteVisible,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                _showDialog();
              },
              tooltip: 'Mark As Complete Notes',
              child: Icon(Icons.check_box, color: Colors.purple,),
              backgroundColor: Colors.white,
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
          title: new Text("Change Notes Status"),
          content: new Text("Are you sure mark this notes as complete ?"),
          actions: < Widget > [
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                submitAsComplete();
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

  void submitAsComplete() async {
    Future.delayed(Duration(milliseconds: 30)).then((onValue) {
      pr.show();
    });

    String _token = await appAuth.readUserKey();

    var url = Globals.apiUrl + "v1/usernotes/changeNoteStatus/complete/" + widget.noteId + _token;

    try {
      Response response = await Dio().get(url);

      pr.hide();

      Future.delayed(Duration(milliseconds: 30)).then((onValue) {
        if (response.data["result"] == 1) {
          var mes = response.data["message"];
          var msg = '{"isRefresh": true, "fromScreen": "DetailsUserNotes", "message": "$mes"}';
          Navigator.pop(context, msg);
        } else {
          var mes = response.data["message"];
          Flushbar(
            message: mes,
            flushbarPosition: FlushbarPosition.TOP,
            icon: Icon(
              Icons.error_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
        }
      });

    } catch (e) {
      pr.hide();
      Flushbar(
        message: "Something error occured or no internet connection",
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue[300],
      )..show(context);
      print(e);
    }
  }

  Widget backgroundHeader() {
    return Container(
      height: 140,
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
                    fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
