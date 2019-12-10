import 'package:flutter/material.dart';
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
  final String noteDueDate;

  DetailsNote({
    Key key,
    @required
    this.noteId,
    this.noteTitle,
    this.noteLabel,
    this.noteType,
    this.noteDescription,
    this.noteDueDate,
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
}
