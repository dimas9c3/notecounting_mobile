import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      ),
    );
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
    top: 180,
    left: 20,
    child: Container(
      width: 370,
      height: 140,
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
                  Text("Penghasilan"),
                  Divider(),
                  Text(
                    "Rp 500.000",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: < Widget > [
                  Text("Pengeluaran"),
                  Divider(),
                  Text(
                    "Rp 260.000",
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
    height: 300,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.pink,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: < Widget > [
            Text(
              "Anugrah Sandi",
              style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "085343966997",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
        ),
    ),
  );
}