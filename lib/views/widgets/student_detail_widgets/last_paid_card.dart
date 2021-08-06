import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LastPaidCard extends StatelessWidget {
  LastPaidCard({
    Key? key,
    required this.colorLizer,
    required this.colors,
    required this.id,
    this.lastPaidDate = "NA",
    this.lastPaidmonth = "NA",
    this.lastPaidYear = "NA",
    this.lastPaidAmount = 0,
  }) : super(key: key);

  final ColorLizer colorLizer;
  var id;
  var lastPaidDate;
  var lastPaidmonth;
  var lastPaidYear;
  final int lastPaidAmount;
  final List<Color> colors;
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: studentsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Container(
            padding: EdgeInsets.all(20),
            height: 150,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: colorLizer.getSpecialFiledColor(colors),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Last Paid",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Text(
                  "$lastPaidDate $lastPaidmonth",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                Text(
                  "Amount : $lastPaidAmount",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          );
        });
  }
}
