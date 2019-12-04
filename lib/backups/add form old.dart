import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:validate/validate.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:notecounting/utils/globals.dart';
// import 'package:notecounting/models/Contact.dart';
import 'package:notecounting/services/auth.service.dart';

AuthService appAuth = new AuthService();

class _FormData {
    String title        = '';
    String description  = '';
}

String _date            = '';

ProgressDialog pr;

class AddNote extends StatefulWidget {
    @override
    _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State < AddNote > {
    // Future < List < Contacts >> contacts;

    List _labels = [{"id": "1","item": "Personal",},{"id": "2","item": "Work",},{"id": "3","item":"Events",},{"id": "4","item": "Friends",},{"id": "5","item": "Others",},];

    List _types = [{"id": "1","item": "Regular",},{"id": "2","item": "Deadline",},];

    List<DropdownMenuItem<String>> _dropDownMenuLabels;
    List<DropdownMenuItem<String>> _dropDownMenuTypes;
    
    String _currentLabels;
    String _currentTypes;
    bool _dueDateVisible = false;

    final GlobalKey < FormState > _formKey = new GlobalKey < FormState > ();
    final passtxt = TextEditingController();

    _FormData _data = new _FormData();

    @override
    void initState() {
      _dropDownMenuLabels = getDropDownMenuLabels();
      // _currentLabels = _dropDownMenuLabels[0].value;
      _dropDownMenuTypes = getDropDownMenuTypes();
      // _currentTypes = _dropDownMenuTypes[0].value;
      super.initState();
    }

    List<DropdownMenuItem<String>> getDropDownMenuLabels() {
      List<DropdownMenuItem<String>> items = new List();
        for (var label in _labels) {
          items.add(new DropdownMenuItem(
              value: label['id'],
              child: new Text(label['item'])
          ));
        }
        return items;
    }

    List<DropdownMenuItem<String>> getDropDownMenuTypes() {
      List<DropdownMenuItem<String>> items = new List();
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
        pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
    
        pr.style(
          message: 'Please wait...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );

        FocusNode txtDescription = new FocusNode();

        final Size screenSize = MediaQuery.of(context).size;
        return Scaffold(
            appBar: AppBar(
                title: Text("Add Note"),
            ),
            body: new Container(
                // margin: EdgeInsets.all(10),
                padding: new EdgeInsets.all(15.0),
                child: new Form(
                    key: this._formKey,
                    child: new ListView(
                        children: < Widget > [
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3.0, // has the effect of softening the shadow
                                        spreadRadius: 3.0, // has the effect of extending the shadow
                                        offset: Offset(
                                          2.0, // horizontal, move right 10
                                          2.0, // vertical, move down 10
                                        ),
                                      )
                                    ],
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                  child: new TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                        hintText: 'Input Title For Your Note',
                                        labelText: 'Note Title',
                                        contentPadding: const EdgeInsets.all(15),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.blue),
                                                    borderRadius: BorderRadius.circular(10.0),
                                            ),
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
                                child: new TextFormField(
                                    focusNode: txtDescription,
                                    maxLines: 10,
                                    keyboardType: TextInputType.multiline,
                                    decoration: new InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue,
                                        hintText: 'Input Description For Your Note',
                                        labelText: 'Note Description',
                                        contentPadding: const EdgeInsets.only( top: 15, left: 15, right: 15, bottom: 15),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.blue),
                                                borderRadius: BorderRadius.circular(10.0),
                                        ),
                                    ),
                                    validator: this._validateDescription,
                                    onSaved: (String value) {
                                        this._data.description = value;
                                    },
                                ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 300.0,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
                                      hint: Text('Select Your Note Label'),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black))),
                                        value: _currentLabels,
                                        items: _dropDownMenuLabels,
                                        onChanged: changedDropDownLabels,
                                        validator: this._validateLabel,
                                        // onSaved: (String value) {
                                        // this._data.label = value;
                                        // },
                                        // style: Theme.of(context).textTheme.subhead,
                                    ),
                                  ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: new Container(
                                  width: 300.0,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
                                      hint: Text('Select Your Note Type'),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black))),
                                        value: _currentTypes,
                                        items: _dropDownMenuTypes,
                                        onChanged: changedDropDownTypes,
                                        validator: this._validateType,
                                      // style: Theme.of(context).textTheme.subhead,
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
                                        color: Colors.blue,
                                    ),
                                    margin: new EdgeInsets.only(
                                        top: 5.0
                                    ),
                                ),
                            ),
                        ],
                    ),
                )
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
      }else {
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
            return 'The Note Label Cant Empty.';
        }

        return null;
    }

     String _validateType(String value) {
        if (_currentTypes == "" || _currentTypes == null) {
            return 'The Note Type Cant Empty.';
        }

        return null;
    }

    void submit() async {
        // First validate form.
        if (this._formKey.currentState.validate()) {
            pr.show();
            _formKey.currentState.save();
            
            String _token = await appAuth.readUserKey();
            String _email = await appAuth.readUserEmail();
            var url = Globals.apiUrl + "v1/usernotes/store" + _token;
            
            try {
              Response response = await Dio().post(url, data: {
                'email': _email,
                'title': _data.title,
                'description': _data.description,
                'label': _currentLabels,
                'type': _currentTypes,
                'due_date': _date,
              });

              pr.hide();
              
              if (response.data["result"] == 1) {
                    var mes = response.data["message"];
                    var msg = '{"isRefresh": true, "fromScreen": "addUserNotes", "message": "$mes"}';
                    Navigator.pop(context, msg);
              } else {
                  
              }
            } catch (e) {
              pr.hide();
              print(e);
            }
        }
    }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("dd-MM-yyyy");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Text('Input Deadline For Your Note (${format.pattern})'),
      Text('Input Deadline For Your Note'),
      DateTimeField(
        format: format,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onShowPicker: (context, currentValue) async {
          final time = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100)
          );

          return time;
        },
        onSaved: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
          _date = value.toString();
        },
      ),
    ]);
  }
}