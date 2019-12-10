import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:notecounting/utils/globals.dart';
import 'package:notecounting/services/auth.service.dart';

AuthService appAuth = new AuthService();

class _FormData {
  String title = '';
  String description = '';
}

String _date = '';
DateTime _dueDateValue;
ProgressDialog pr;

class EditNote extends StatefulWidget {
  final String noteId;
  final String noteTitle;
  final String noteLabel;
  final String noteType;
  final String noteDescription;
  final String noteDueDate;

  EditNote({
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
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State < EditNote > {
  List _labels = [{
    "id": "1",
    "item": "Personal",
  }, {
    "id": "2",
    "item": "Work",
  }, {
    "id": "3",
    "item": "Events",
  }, {
    "id": "4",
    "item": "Friends",
  }, {
    "id": "5",
    "item": "Others",
  }, ];

  List _types = [{
    "id": "1",
    "item": "Regular",
  }, {
    "id": "2",
    "item": "Deadline",
  }, ];

  List < DropdownMenuItem < String >> _dropDownMenuLabels;
  List < DropdownMenuItem < String >> _dropDownMenuTypes;

  String _currentLabels;
  String _currentTypes;
  bool _dueDateVisible;

  final GlobalKey < FormState > _formKey = new GlobalKey < FormState > ();

  _FormData _data = new _FormData();

  @override
  void initState() {
    if (widget.noteLabel == "Personal") {
      _currentLabels = "1";
    } else if (widget.noteLabel == "Work") {
      _currentLabels = "2";
    } else if (widget.noteLabel == "Events") {
      _currentLabels = "3";
    } else if (widget.noteLabel == "Friends") {
      _currentLabels = "4";
    } else if (widget.noteLabel == "Others") {
      _currentLabels = "5";
    }

    if (widget.noteType == "Regular") {
      _currentTypes = "1";
      _dueDateVisible = false;
    } else if (widget.noteType == "Deadline") {
      _currentTypes = "2";
      _dueDateVisible = true;
      String _dueDateVal = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.noteDueDate));
      _dueDateValue = DateTime.parse(_dueDateVal);
    }

    _dropDownMenuLabels = getDropDownMenuLabels();
    _dropDownMenuTypes = getDropDownMenuTypes();
    super.initState();
  }

  List < DropdownMenuItem < String >> getDropDownMenuLabels() {
    List < DropdownMenuItem < String >> items = new List();
    for (var label in _labels) {
      items.add(new DropdownMenuItem(
        value: label['id'],
        child: new Text(label['item'])
      ));
    }
    return items;
  }

  List < DropdownMenuItem < String >> getDropDownMenuTypes() {
    List < DropdownMenuItem < String >> items = new List();
    for (var type in _types) {
      items.add(new DropdownMenuItem(
        value: type['id'],
        child: new Text(type['item'])
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {


    FocusNode txtDescription = new FocusNode();
    final Size screenSize = MediaQuery.of(context).size;
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
            ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: < Widget > [
                Padding(
                  padding: new EdgeInsets.all(15.0),
                  child: new Form(
                    key: this._formKey,
                    child: new Column(
                      children: < Widget > [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Material(
                            elevation: 10.0,
                            shadowColor: Colors.black45,
                            borderRadius: BorderRadius.circular(10.0),
                            child: new TextFormField(
                              keyboardType: TextInputType.text,
                              initialValue: widget.noteTitle,
                              decoration: new InputDecoration(
                                // icon: new Icon(Icons.lock, color: Color(0xff224597)),
                                prefixIcon: new Icon(Icons.title, color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Input Title For Your Note',
                                // labelText: 'Note Title',
                                errorStyle: TextStyle(fontSize: 16.0, ),
                                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.grey, width: 1.0))
                              ),
                              validator: this._validateTitle,
                              onSaved: (String value) {
                                this._data.title = value;
                              },
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(txtDescription);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.black45,
                            borderRadius: BorderRadius.circular(10.0),
                            child: new TextFormField(
                              initialValue: widget.noteDescription,
                              focusNode: txtDescription,
                              maxLines: 8,
                              keyboardType: TextInputType.multiline,
                              decoration: new InputDecoration(
                                // icon: new Icon(Icons.lock, color: Color(0xff224597)),
                                prefixIcon: new Icon(Icons.description, color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Input Description For Your Note',
                                // labelText: 'Note Description',
                                errorStyle: TextStyle(fontSize: 16.0, ),
                                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(30.0),
                                // borderSide: BorderSide(color: Colors.white, width: 3.0))
                              ),
                              validator: this._validateDescription,
                              onSaved: (String value) {
                                this._data.description = value;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.black45,
                            borderRadius: BorderRadius.circular(10.0),
                            child: new Container(
                              width: screenSize.width,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  hint: Text('Select Your Note Label'),
                                  decoration: InputDecoration(
                                    prefixIcon: new Icon(Icons.label, color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorStyle: TextStyle(fontSize: 16.0, ),
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                    // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(30.0),
                                    // borderSide: BorderSide(color: Colors.white, width: 3.0))
                                  ),
                                  value: _currentLabels,
                                  items: _dropDownMenuLabels,
                                  onChanged: changedDropDownLabels,
                                  validator: this._validateLabel,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                            elevation: 10.0,
                            shadowColor: Colors.black45,
                            borderRadius: BorderRadius.circular(10.0),
                            child: new Container(
                              width: screenSize.width,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  hint: Text('Select Your Note Type'),
                                  decoration: InputDecoration(
                                    prefixIcon: new Icon(Icons.merge_type, color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.white,
                                    errorStyle: TextStyle(fontSize: 16.0, ),
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                    // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(30.0),
                                    // borderSide: BorderSide(color: Colors.white, width: 3.0))
                                  ),
                                  value: _currentTypes,
                                  items: _dropDownMenuTypes,
                                  onChanged: changedDropDownTypes,
                                  validator: this._validateType,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: new BasicDateField(),
                          ),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: _dueDateVisible,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: new Container(
                            width: screenSize.width,
                            height: 45.0,
                            child: new RaisedButton(
                              color: Colors.purple,
                              splashColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              child: new Text(
                                'Submit',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white
                                ),
                              ),
                              onPressed: () {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                submit();
                              },
                            ),
                            margin: new EdgeInsets.only(
                              top: 5.0
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changedDropDownLabels(String selectedLabel) {
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentLabels = selectedLabel;
    });
  }

  void changedDropDownTypes(String selectedType) {
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
      _currentTypes = selectedType;
    });

    if (selectedType == "2") {
      setState(() {
        _dueDateVisible = true;
      });
    } else {
      setState(() {
        _dueDateVisible = false;
      });
    }
  }

  String _validateTitle(String value) {
    if (value == "") {
      return 'The Title cant empty.';
    }

    if (value.length < 4) {
      return 'The Title must be at least 4 characters.';
    }

    return null;
  }

  String _validateDescription(String value) {
    if (value == "") {
      return 'The Description cant empty.';
    }

    if (value.length < 6) {
      return 'The Description must be at least 6 characters.';
    }

    return null;
  }

  String _validateLabel(String value) {
    if (_currentLabels == "" || _currentLabels == null) {
      return 'The Label Cant Empty.';
    }

    return null;
  }

  String _validateType(String value) {
    if (_currentTypes == "" || _currentTypes == null) {
      return 'The Type Cant Empty.';
    }

    return null;
  }

  void submit() async {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      pr.show();
      _formKey.currentState.save();

      String _token = await appAuth.readUserKey();
      var url = Globals.apiUrl + "v1/usernotes/update" + _token;

      try {
        Response response = await Dio().post(url, data: {
          'noteId': widget.noteId,
          'title': _data.title,
          'description': _data.description,
          'label': _currentLabels,
          'type': _currentTypes,
          'due_date': _date,
        });

        pr.hide();

        if (response.data["result"] == 1) {
          var mes = response.data["message"];
          var msg = '{"isRefresh": true, "fromScreen": "EditUserNotes", "message": "$mes"}';
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
          var msg = '{"isRefresh": true, "fromScreen": "EditUserNotes", "message": "$mes"}';
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
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(10.0),
      child: Column(children: < Widget > [
        // Text('Input Deadline For Your Note (${format.pattern})'),
        DateTimeField(
          initialValue: _dueDateValue,
          decoration: InputDecoration(
            prefixIcon: new Icon(Icons.calendar_today, color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            // enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(30.0),
            // borderSide: BorderSide(color: Colors.white, width: 3.0))
          ),
          format: format,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onShowPicker: (context, currentValue) async {
            final time = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate : DateTime(2100)
            );

            return time;
          },
          onSaved: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
            _date = value.toString();
          },
        ),
      ]),
    );
  }
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
                    "Change This Form To Edit Your Notes",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
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
                "Edit User Notes",
                style: TextStyle(
                  fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ),
    ),
  );
}