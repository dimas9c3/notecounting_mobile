import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(Note());

class Note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Column(
            children: < Widget > [
              Stack(
                children: < Widget > [backgroundHeader(), summaryCash()],
              ),
              cardDetail('Makan Siang', 'Beli Makan Di Warteg', '10.000', 'out'),
              cardDetail('Bonus', 'Dapat Bonus Proyek', '500.000', 'in'),
              cardDetail('Beli Baju', 'Baju Kemeja Kantor', '250.000', 'out'),
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
                // setState(() {
                //     contacts = _fetchContacts();
                // });
                String msg = res['message'];
                Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(duration: const Duration(milliseconds: 1500), content: Text("$msg")));
            }
        }
    }
}

Widget cardDetail(title, description, price, type) {
  return Card(
    margin: EdgeInsets.only(top: 15, left: 15, right: 15),
    elevation: 8,
    child: ListTile(
      leading: Icon(
        type == 'out' ? Icons.subdirectory_arrow_left : Icons.subdirectory_arrow_right,
        color: type == 'out' ? Colors.redAccent : Colors.lightGreen,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
      trailing: Text(
        "Rp " + price,
        style: TextStyle(color: type == 'out' ? Colors.redAccent : Colors.lightGreen),
      ),
    ),
  );
}

Widget summaryCash() {
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